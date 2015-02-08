#' Download species' information from the IUCN RedList online database
#' 
#' @author Bruno Vilela
#' 
#' @description Get species' information from the IUCN website(\url{http://www.iucnredlist.org/}) for one or more species.
#' 
#' @usage lets.iucn(input, count=FALSE)
#' 
#' @param input Character vector with one or more species names,
#' or an object of class PresenceAbsence.
#' @param count Logical, if \code{TRUE} a counting window will open.
#' 
#' @return Returns a data frame with the Species Name, Family, Conservation Status, 
#' Criteria used to estabilish the conservation status, Population Status, Year of Description, and the Countries where it occurs. If species do not have information (i.e. have not been evaluated), the result is: NE (Not evaluated).
#' 
#' @details Note that you must be connected to the internet to use this function. 
#' 
#' @import XML
#' 
#' @seealso \code{\link{lets.iucn.ha}}
#' @seealso \code{\link{lets.iucn.his}}
#' 
#' @examples \dontrun{
#' # Single species
#' lets.iucn("Pongo pygmaeus")
#' 
#' # Multiple species
#' lets.iucn(c("Musonycteris harrisoni", "Ailuropoda melanoleuca", "Cebus flavius"))
#' }
#' 
#' @export

lets.iucn <- function(input, count=FALSE){
  
  if(class(input)=="PresenceAbsence"){
    input <- input$S
  }
  
  input <- gsub(as.matrix(input), pattern=" ", replacement="-")
  input <- gsub(as.matrix(input), pattern="_", replacement="-")
  
  #vetor para guardar o status
  ln <- length(input)
  matriz1 <- matrix(nrow=ln)
  status <-  matriz1
  criterio <- matriz1
  populacao <- matriz1
  familia <- matriz1
  autor <- matriz1  
  pais <- matriz1
  
  if(count == TRUE){
  
  dev.new(width=2, height=2, pointsize = 12)
  par(mar=c(0, 0, 0, 0))  
  
  #Loop para procurar o status de cada especie da matriz no site da IUCN
  for (i in 1:ln){

    
    plot.new()
    text(0.5, 0.5, paste(paste("Total:", ln, "\n", "Runs to go: ", (ln-i))))      
  
    h <- try(htmlParse(paste("http://api.iucnredlist.org/go/",input[i], sep = "")),silent=TRUE)
    
    if((class(h)[1])=="try-error"){
      status[i, 1]<-"NE"
      criterio[i, 1] <-""
      populacao[i, 1]<-"Unknown"
      familia[i, 1]<-""
      autor[i, 1]<-""
      pais[i, ]<-""      
    }else{
      status[i, 1] <- try(xpathSApply(h, '//div[@id="red_list_category_code"]', xmlValue), silent=TRUE)
      criterio[i, 1] <- try(xpathSApply(h, '//div[@id="red_list_criteria"]', xmlValue), silent=TRUE)
      pop <- try(xpathSApply(h, '//div[@id="population_trend"]', xmlValue), silent=TRUE)
      populacao[i, 1] <- ifelse(is.list(pop), "Unknown",pop)
      familia[i, 1] <- try(xpathSApply(h, '//div[@id="family"]', xmlValue), silent=TRUE)
      autor[i, 1] <- try(xpathSApply(h, '//div[@id="species_authority"]', xmlValue), silent=TRUE)            
      
      if(status[i, 1]=="LR/nt"){
        status[i, 1] <- "NT"
      }
      
      if(status[i, 1]=="LR/lc"){
        status[i, 1] <- "LC"
      }
      ###Pais
      distr1 <- try(xpathSApply(h, '//ul[@class="countries"]', xmlValue), silent=TRUE)

      
      if(is.list(distr1)){
        pais[i, 1] <- ""
      }else{
        distr2 <- try(unlist(strsplit(distr1, "\n")), silent=TRUE)
        distr2[distr2 == "Russian Federation"] <- "Russia"
        distr2[distr2 == "Bolivia, Plurinational States of"] <- "Bolivia"
        distr2[distr2 == "Venezuela, Bolivarian Republic of"] <- "Venezuela"
        distr2[distr2 == "Korea, Democratic People's Republic of"] <- "Democratic People's Republic of Korea"
        distr2[distr2 == "Congo, The Democratic Republic of the"] <- "The Democratic Republic of the Congo"
        distr2[distr2 == "Tanzania, United Republic of"] <- "United Republic of Tanzania"
        distr2[distr2 == "Palestinian Territory, Occupied"] <- "Occupied Palestinian Territory"
        distr2[distr2 == "Micronesia, Federated States of"] <- "Federated States of Micronesia"
        distr2[distr2 == "Macedonia, the former Yugoslav Republic of"] <- "The former Yugoslav Republic of Macedonia"
        distr2[distr2 == "Korea, Republic of"] <- "Republic of Korea"
        distr2[distr2 == "Iran, Islamic Republic of"] <- "Islamic Republic of Iran"
        distr2[distr2 == "Disputed Territory, Djibouti"] <- "Djibouti Disputed Territory"
        distr2[distr2 == "Virgin Islands, U.S."] <- "Virgin Islands(U.S.)"
        distr2[distr2 == "Virgin Islands, British"] <- "Virgin Islands(British)"
                      
        pais[i, 1] <- paste(distr2, collapse = ", ")
      }     
    }
  }
    
  dev.off()
  }
  
  if(count == FALSE){
    for (i in 1:ln){          
      
      h <- try(htmlParse(paste("http://api.iucnredlist.org/go/",input[i], sep = "")),silent=TRUE)
      
      if((class(h)[1])=="try-error"){
        status[i, 1]<-"NE"
        criterio[i, 1] <-""
        populacao[i, 1]<-"Unkown"
        familia[i, 1]<-""
        autor[i, 1]<-""
        pais[i, ]<-""      
      }else{
        status[i, 1] <- try(xpathSApply(h, '//div[@id="red_list_category_code"]', xmlValue), silent=TRUE)
        criterio[i, 1] <- try(xpathSApply(h, '//div[@id="red_list_criteria"]', xmlValue), silent=TRUE)
        pop <- try(xpathSApply(h, '//div[@id="population_trend"]', xmlValue), silent=TRUE)
        populacao[i, 1] <- ifelse(is.list(pop), "Unknown",pop)
        familia[i, 1] <- try(xpathSApply(h, '//div[@id="family"]', xmlValue), silent=TRUE)
        autor[i, 1] <- try(xpathSApply(h, '//div[@id="species_authority"]', xmlValue), silent=TRUE)            
        
        if(status[i, 1]=="LR/nt"){
          status[i, 1] <- "NT"
        }
        
        if(status[i, 1]=="LR/lc"){
          status[i, 1] <- "LC"
        }
        ###Pais
        distr1 <- try(xpathSApply(h, '//ul[@class="countries"]', xmlValue), silent=TRUE)
        
        if(is.list(distr1)){
          pais[i, 1] <- ""
        }else{
          distr2 <- try(unlist(strsplit(distr1, "\n")), silent=TRUE)
          distr2[distr2 == "Russian Federation"] <- "Russia"
          distr2[distr2 == "Bolivia, Plurinational States of"] <- "Bolivia"
          distr2[distr2 == "Venezuela, Bolivarian Republic of"] <- "Venezuela"
          distr2[distr2 == "Korea, Democratic People's Republic of"] <- "Democratic People's Republic of Korea"
          distr2[distr2 == "Congo, The Democratic Republic of the"] <- "The Democratic Republic of the Congo"
          distr2[distr2 == "Tanzania, United Republic of"] <- "United Republic of Tanzania"
          distr2[distr2 == "Palestinian Territory, Occupied"] <- "Occupied Palestinian Territory"
          distr2[distr2 == "Micronesia, Federated States of"] <- "Federated States of Micronesia"
          distr2[distr2 == "Macedonia, the former Yugoslav Republic of"] <- "The former Yugoslav Republic of Macedonia"
          distr2[distr2 == "Korea, Republic of"] <- "Republic of Korea"
          distr2[distr2 == "Iran, Islamic Republic of"] <- "Islamic Republic of Iran"
          distr2[distr2 == "Disputed Territory, Djibouti"] <- "Djibouti Disputed Territory"
          distr2[distr2 == "Virgin Islands, U.S."] <- "Virgin Islands(U.S.)"
          distr2[distr2 == "Virgin Islands, British"] <- "Virgin Islands(British)"
          
          pais[i, 1] <- paste(distr2, collapse = ", ")
        }     
      }
    }
    
  }
  
  
  #Fazendo a tabela final
  resu <- cbind(input, familia, status, criterio, populacao, autor, pais)
  colnames(resu) <- c("Species", "Family", "Status", "Criteria", "Population", "Description_Year", "Country")
  
  #Trocando a messagem de erro das especies que nao foram encontradas pelo status NE(not evaluated)
  for (i in 1:nrow(resu)){

    if(nchar(resu[i,2])>15){
      resu[i, 2] <- ""
    }  
    if(nchar(resu[i,3])>2){
      resu[i, 3] <- "NE"
    }
    if(nchar(resu[i,4])>20){
      resu[i, 4] <- ""
    }    
    if(nchar(resu[i,5])>15){
      resu[i, 5] <- "Unknown"
    }
    
  }
  
  
  #Retirando os tracos e colocando de novo o espaco entre as palavras
  resu[, 1] <- gsub(resu[, 1],pattern="-",replacement=" ")

  resu[, 6] <-gsub("[[:alpha:]]", "", resu[, 6])
  resu[, 6] <- gsub("[[:punct:]]", "", resu[, 6])
  resu[, 6] <- gsub("[[:cntrl:]]", "", resu[, 6])
  resu[, 6] <- as.numeric(gsub("\\D", "", resu[, 6]))
  resu[, 6] <- as.numeric(substr(resu[, 6], 1, 4))
  resu <- as.data.frame(resu)
  resu[, 6] <- as.numeric(levels(resu[, 6]))[resu[, 6]]
  return(resu)
}
