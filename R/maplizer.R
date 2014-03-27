#' Create a matrix summarizing a species atribute 
#' 
#' @author Bruno Vilela
#' 
#' @description Summarize species atributes per cell in a presence-absence matrix.
#'
#' @usage lets.maplizer(x, y, z, func=mean, ras=FALSE)
#' 
#' @param x A PresenceAbsence object.
#' @param y Species atribute to be maped 
#' @param z Species names in the same order of the atributes.
#' @param func function to summarize the atribute.
#' @param ras If True the raster file will be returned together with the matrix
#' 
#' @return Return a matrix with coordinates and the atributes summarized.
#' 
#' 
#' @seealso lets.presab
#' 
#' @export

lets.maplizer <- function(x, y, z, func=mean, ras=F){

  if(is.factor(y)){
  y <- as.numeric(levels(y))[y]
 }

 p <- x$P[, -(1:2)]

 for(i in 1:ncol(p)){
  pos <- which(x$S[i]==z)
  if(length(pos)>0){
  p[, i] <- p[, i]*y[pos]
  pos2 <- which(p[, i]==0)
  p[pos2, i] <- NA
  }else{
    p[, i] <- NA
  }  
 }

 resum <- apply(p, 1, func, na.rm=T)
 resultado <- cbind(x$P[, 1:2], resum)
 resu2 <- na.omit(resultado)

 if(ras==T){
  r <- rasterize(resu2[, 1:2], x$R, resu2[, 3])
  return(list(Matrix=resultado, raster=r))
 }else{
  return(resultado)
 }
}
