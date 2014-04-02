#' Download habitat information from IUCN
#' 
#' @author Bruno Vilela
#' 
#' @description Get species conservation status history information from IUCN website for one or more species.
#' 
#' @usage lets.iucn.his(input, count=FALSE)
#' 
#' @param input character vector with one or more species names,
#' or an object of the PresenceAbsence class.
#' @param count Logical, if TRUE a counting window will be open.

#' @return A data frame with the species names in the rows and the years (1980 - 2014) in the columns, 
#' the code represents the conservation status of the species (see IUCN website for details).
#' NE = Not evaluated.
#' 
#' @details Depending on your internet conection and the number of species, the function 
#' may take some time. So, we open a count window where you can follow the progress.
#' Note that the internet must be turned on during all the process. 
#' 
#' @import XML
#' 
#' @seealso lets.iucn
#' @seealso lets.iucn.ha
#' 
#' 
#' @export


lets.iucn.his <- function(input, count=FALSE){  
  
  if(class(input)=="PresenceAbsence"){
    input <- input$S
  }
  
  resus <- c()
  n <- length(input)

  if(count == TRUE){
  x11(2, 2, pointsize=12)
  par(mar=c(0, 0, 0, 0))  
    
  for(i in 1:n){    

    plot.new()
    text(0.5, 0.5, paste(paste("Total:", n, "\n", "Runs to go: ", (n-i))))      
    
    resu <- .Hist(input[i])
    resus <- rbind(resus, resu)
  }   
  
  dev.off()
  }
  
  if(count == FALSE){

    for(i in 1:n){              
      resu <- .Hist(input[i])
      resus <- rbind(resus, resu)
    }   
    
  }
  return(as.data.frame(resus))
}



###
.Hist <- function(input){
  
  input <- gsub(as.matrix(input), patt=" ", replace="-")
  h2 <- try(htmlParse(paste("http://api.iucnredlist.org/go/",input, sep = "")),silent=TRUE)
  b <- try(xpathSApply(h2, '//div', xmlValue),silent=TRUE)[1]
  c <- as.numeric(gsub("\\D", "", b))
  
  ano1 <- try(xpathSApply(h2, '//div[@id="modified_year"]', xmlValue), silent=TRUE)
  ameaca1 <- try(xpathSApply(h2, '//div[@id="red_list_category_code"]', xmlValue), silent=T)
  anos <- 1980:2014
  matriz <- matrix(ncol=length(anos))
  colnames(matriz) <- anos
  matriz[, ] <- "NE"
  
  h <- try(htmlParse(paste("http://www.iucnredlist.org/details/full/", c, "/0", sep = "")), silent=TRUE)
  a <- try(xpathSApply(h, '//td[table]', xmlValue),silent=T)
  a <- a[2]
  a <- gsub("\n", "", a)
  a <- gsub("\t", "", a)
  b <- strsplit(a, "          ")[[1]]
  b <- strsplit(b, "      ")
  c <- do.call("rbind", b)
  c <- matrix(c, ncol=1)
  c <- c[-which(duplicated(c)), ]
  ano <- substr(gsub("\\D", "", c), 1, 4)
  
  if(length(ano)>=1){
    d <- gsub("[0-9]", "", c)
    d <- gsub("[[:punct:]]", "", d)
    d2 <- gsub("\\W", "", d)
    
    EX <- grep("Extinct", d2)
    EW <- grep("ExtinctintheWild", d2)
    VU <- grep("Vulnerable", d2)
    EN <- grep("Endangered", d2)
    CR <- grep("CriticallyEndangered", d2)
    LC <- grep("LeastConcern", d2)
    NT <- grep("NearThreatened", d2)
    DD <- grep("DataDeficient", d2)
    CT <- grep("CommerciallyThreatened", d2)
    IN <- grep("Indeterminate", d2)
    IK <- grep("InsufficientlyKnown", d2)
    LR <- grep("LowerRisk", d2)
    RA <- grep("Rare", d2)
    
    ameaca <- numeric(length(ano))
    
    ameaca[EX] <- "EX"
    ameaca[EW] <- "EW"
    ameaca[VU] <- "VU"
    ameaca[EN] <- "EN"
    ameaca[CR] <- "CR"
    ameaca[LC] <- "LC"
    ameaca[NT] <- "NT"
    ameaca[IK] <- "IK"
    ameaca[DD] <- "DD"
    ameaca[IN] <- "IN"
    ameaca[RA] <- "RA"
    ameaca[CT] <- "CT"
    ameaca[LR] <- "LR"
    
    ameaca <- ameaca[which(!(duplicated(ano)))]
    ano <- ano[which(!(duplicated(ano)))]
    
    for(i in 1:length(ano)){      
      matriz[anos%in%ano[i]] <- ameaca[i]  
    }
    
    ameaca <- c(ameaca, ameaca1)
    ano <- c(ano, ano1)
    ameaca <- ameaca[which(!(duplicated(ano)))]
    ano <- ano[which(!(duplicated(ano)))]        
    pos <- which(anos%in%ano)
    pos2 <- sort(ano, index.return=T)$ix
    ameaca <- ameaca[pos2]
    
    for(i in 1:(length(ameaca)-1)){
      matriz[seq(from=(pos[i]+1),(pos[i+1]-1))] <- ameaca[i]
    }
  }
  if(ano1%in%anos){
    pos3 <- which(anos%in%ano1)
    matriz[pos3:ncol(matriz)] <- ameaca1
  }
  Species <- gsub(as.matrix(input), patt="-", replace=" ")
  matriz <- cbind(Species, matriz)
  colnames(matriz)[1] <- "Species"
  return(matriz)
}


