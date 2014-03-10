#' Download habitat information from IUCN
#' 
#' @author Bruno Vilela
#' 
#' @description Get species habitat information from IUCN website for one or more species.
#' 
#' @usage lets.iucn.ha(input)
#' 
#' @param input character vector with one or more species names,
#' or an object of the PresenceAbsence class.
#' 
#' @return A data frame with the species names in the rows and the habitats in the columns,
#' the number 1 indicates the use of the habitat while the 0 indicates that the species do 
#' not use the habitat.
#' 
#' @details Depending on your internet conection and the number of species, the function 
#' may take some time. So, we open a count window where you can follow the progress.
#' Note that the internet must be turned on during all the process. 
#' 
#' @import XML
#' 
#' @seealso lets.iucn
#' 
#' 
#' @export

lets.iucn.ha <- function(input){
  #keep species name
  
  if(class(input)=="PresenceAbsence"){
    input <- input$S
  }
  
  
  sps <- input 
  
  #enpty matrix
  habitat <- matrix(0, nrow=length(input), ncol=19) 
  
  #Habitat names (and the name "species" that will be used in the matrix columns names)
  names <- c("Species", "Forest", "Savanna", "Shrubland", "Grassland", 
             "Wetlands", "Rocky areas", "Caves and Subterranean Habitats", 
             "Desert", "Marine Neritic", "Marine Oceanic", "Marine Deep Ocean Floor", 
             "Marine Intertidal", "Marine Coastal/Supratidal", "Artificial/Terrestrial", 
             "Artificial/Aquatic", "Introduced Vegetation", "Other", "Unknown")
  
  #Adding the column names
  colnames(habitat) <- names
  
  n <- length(input)
  cat("This action may take some time...\nWe will take the liberty to open a counting window so you can follow the progress...")
  
  x11(2, 2, pointsize=12)
  par(mar=c(0, 0, 0, 0))  
  
  for(i in 1:n){
    
    plot.new()
    text(0.5, 0.5, paste(paste("Total:", n, "\n", "Runs to go: ", (n-i))))      
    
    #Taking the Website code from the internet
    input <- gsub(as.matrix(input), patt=" ", replace="-")
    h <- try(htmlParse(paste("http://api.iucnredlist.org/go/", input[i], sep = "")), silent=TRUE)
    b <- try(xpathSApply(h, '//div', xmlValue), silent=TRUE)[1]
    c <- as.numeric(gsub("\\D", "", b))
    h2 <- try(htmlParse(paste("http://www.iucnredlist.org/details/classify/", c, "/0", sep = "")), silent=TRUE)
    
    #taking the specific parts that contains the habitat names
    b2 <- try(xpathSApply(h2, '//html', xmlValue), silent=TRUE)
    
    #look for the habitat names inside the string (if the sting contains the name, it will be marked 1)
    for(t in 2:18){
      if(sum(grep(names[t], b2))>0){
        habitat[i, t] <- 1
      }
    }
    
    #If none of the habitat names have been found or also if the species have not been found in IUCN archives.
    #it will be marked 1 in the column Unknwon
    if(sum(habitat[i, ])==0){
      habitat[i, 19] <- 1
    }
  }
  
  dev.off()
  cat("\nThank you for your patience!")
  
  #Adding species names to the first column
  habitat[, 1] <- sps
  
  #Return the matrix
  return(as.data.frame(habitat))
}
