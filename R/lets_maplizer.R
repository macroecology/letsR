#' Create a matrix summarizing species' attributes within cells of a PresenceAbsence object
#' 
#' @author Bruno Vilela
#' 
#' @description Summarize species atributes per cell in a presence-absence matrix.
#'
#' @usage lets.maplizer(x, y, z, func=mean, ras=FALSE)
#' 
#' @param x A PresenceAbsence object.
#' @param y Species attribute to be considered.
#' @param z Species names in the same order as the attributes.
#' @param func function to summarize the species' atribute.
#' @param ras If \code{TRUE} the raster object will be returned together with the matrix
#' 
#' @return Returns a matrix with the cells' geographic coordinates and the summarized species' attributes within them.
#' 
#' 
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#' 
#' 
#' @examples \dontrun{
#' data(PAM)
#' trait <- runif(32)
#' resu <- lets.maplizer(PAM, trait, PAM$S, ras=TRUE)
#' head(resu$Matrix)
#' plot(resu$raster) ; map(add=T)
#' }
#' 
#' @export

lets.maplizer <- function(x, y, z, func=mean, ras=FALSE){

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
