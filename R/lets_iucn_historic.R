#' Download species' temporal trend in conservation status from the IUCN RedList online database
#' 
#' @author Bruno Vilela
#' 
#' @description Get species conservation status over time (i.e. from 1980 to the present date available) from the IUCN website(\url{http://www.iucnredlist.org/}) for one or more species.
#' 
#' @usage lets.iucn.his(input, count=FALSE)
#' 
#' @param input character vector with one or more species names,
#' or an object of class PresenceAbsence.
#' @param count Logical, if \code{TRUE} a counting window will open.

#' @return A data frame with the species names in the first column rows and the years (1980 - present) in the remaining columns, 
#' the code represents the species' conservation status (see the IUCN RedList website for details). If species do not have information (i.e. have not been evaluated), the result is: NE (Not evaluated).
#'
#' @details Note that you must be connected to the internet to use this function. 
#'
#' @import XML
#' 
#' @seealso \code{\link{lets.iucn.ha}}
#' @seealso \code{\link{lets.iucn}}
#' 
#' @examples \dontrun{
#' # Single species
#' lets.iucn.his("Panthera onca")
#' 
#' # Multiple species
#' lets.iucn.his(c("Rhincodon typus", "Ailuropoda melanoleuca"))
#' }
#' 
#' @export


lets.iucn.his <- function(input, count=FALSE){  
  
  if(class(input)=="PresenceAbsence"){
    input <- input$S
  }
  
  input <- gsub(input, pattern="_", replacement=" ")
  resus <- c()
  n <- length(input)

  if(count == TRUE){
  dev.new(width=2, height=2, pointsize = 12)
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
  
  input <- gsub(as.matrix(input), pattern=" ", replacement="-")
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
  Species <- gsub(as.matrix(input), pattern="-", replacement=" ")
  matriz <- cbind(Species, matriz)
  colnames(matriz)[1] <- "Species"
  return(matriz)
}


