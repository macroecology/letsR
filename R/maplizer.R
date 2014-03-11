#' Create a matrix summarizing a species atribute 
#' 
#' @author Bruno Vilela
#' 
#' @description Create a matrix summarizing a species atribute.
#'
#' @usage lets.maplizer(x, y, z, func=mean, ras=FALSE)
#' 
#' @param x 
#' @param y
#' @param z
#' @param func
#' @param ras
#' 
#' @return 
#' 
#' @details 
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
  pos <- which(x$S[i]== z)
  p[, i] <- p[, i]*y[pos]
  pos2 <- which(p[, i]==0)
  p[pos2, i] <- NA
 }
 resum <- apply(p, 1, func, na.rm=T)
 resultado <- cbind(x$P[, 1:2], resum)
 if(ras==T){
  r <- rasterize(x$P[, 1:2], x$R, resum)
  return(list(Matrix=resultado, raster=r))
 }else{
  return(resultado)
 }
}
