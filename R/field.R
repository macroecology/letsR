#' Create variables based on species range field
#' 
#' @author Bruno Vilela
#' 
#' @description Create a variable based on other species values that cooccur in the geographic range.
#'
#' @usage lets.field(x, y, z, weigth=TRUE)
#' 
#' @param x A PresenceAbsence object.
#' @param y Species atribute to be maped 
#' @param z Species names in the same order of the atributes.
#' @param weigth If TRUE the value is weighted by species range cover, 
#' if FASLSE the value is the mean of all species that cooccur with the
#'  species target.
#' 
#' @return Return a matrix with species x values.
#' 
#' @seealso lets.presab
#' 
#' @export


lets.field <- function(x, y, z, weigth=T){
  
 if(is.factor(y)){
  y <- as.numeric(levels(y))[y]
 }

 p <- x$P[, -(1:2)]
 p2 <- p


 for(i in 1:ncol(p2)){
  pos <- which(x$S[i]==z)
  if(length(pos)>0){
    p2[, i] <- p2[, i]*y[pos]
    pos2 <- which(p2[, i]==0)
    p2[pos2, i] <- NA
  }else{
    p2[, i] <- NA
  }  
 }

 media <- numeric(ncol(p))
 
 for(i in 1:length(media)){
  pos3 <- p[, i]==1
  p3 <- p[pos3, -i]
  p4 <- p2[pos3, -i]
  mult <- p3*p4
  if(weigth==T){
   media[i] <- mean(mult, na.rm=T)
  }
  if(weigth==F){
   me <- colMeans(mult, na.rm=T)
   media[i] <- mean(me, na.rm=T)
  }
 }

 resultado <- cbind(x$S, media)
 colnames(resultado) <- c("Species", "Value")
 resultado <- as.data.frame(resultado)
 resultado[, 2] <- as.numeric(levels(resultado[, 2]))[resultado[, 2]]
 return(resultado)
}