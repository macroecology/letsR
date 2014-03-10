# Summary for object of class PresenceAbsence
# Bruno Vilela
#' @export

summary.PresenceAbsence <- function(x){
  class <- class(x)
  Numberofspecies <- ncol(x$Pre)-2
  Numberofcells <- nrow(x$Pre)
  x2<- x$Pre[,-(1:2)]
  if(is.vector(x2)){
    nomes <- names(x2)
    x2 <- matrix(x2, ncol=length(x2))
    colnames(x2) <- nomes          
  }
  
  if(Numberofspecies>1){
  Cellswithpresence <- sum(rowSums(x2)>0)
  Cellswithoutanypresence <- sum(rowSums(x2)==0)
  Specieswithoutanypresence <- sum(colSums(x2)==0)
  SpeciesLargestRange <- names(2+which(colSums(x2)==max(colSums(x2))))
  }
  if(Numberofspecies==1){
    Cellswithpresence <- sum(x2>0)
    Cellswithoutanypresence <- sum(x2==0)
    Specieswithoutanypresence <- ifelse(Numberofcells==Cellswithoutanypresence, 1, 0)
    SpeciesLargestRange <- x$S
  }
  resolution <- res(x$Ri)
  extention <- extent(x$Ri)
  coordRef <- projection(x$R)  
  result <- list(class=class,Numberofspecies=Numberofspecies, Numberofcells=Numberofcells, 
       Cellswithpresence=Cellswithpresence, Cellswithoutanypresence=Cellswithoutanypresence,
       Specieswithoutanypresence=Specieswithoutanypresence, SpeciesLargestRange=SpeciesLargestRange,
       resolution=resolution, extention=extention, coordRef=coordRef)
  class(result) <- "summary.PresenceAbsence" 
  return(result)
}



