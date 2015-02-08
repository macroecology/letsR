#' Summarize variable(s) values in a presence-absence matrix within species' ranges
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Based on a Presence-Absence matrix with variables added (see \code{\link{lets.addvar}}) summarizes the values of such variable(s) per species (i.e. within their ranges). 
#'
#' @usage lets.summarizer(x, pos, xy=TRUE, fun=mean)
#' 
#' @param x Presence-absence matrix with variables added.
#' @param pos Column position of the variables of interest.
#' @param xy Logical, if \code{TRUE} the input matrix contains geographic coordinates in the first two columns. 
#' @param fun Function to be used to summarize the variable per species.
#' 
#' @seealso \code{\link{lets.addvar}}
#' @seealso \code{\link{lets.addpoly}}
#' @seealso \code{\link{lets.field}}
#' 
#' 
#' @export


lets.summarizer <- function(x, pos, xy=TRUE, fun=mean){
  
  var <- x[, pos]
  sp <- x[, -pos]  
  
  if(xy==TRUE){
    sp <- sp[, -(1:2)]
  }
  
  Species <- colnames(sp)
  n <- length(Species)
  resum <- matrix(NA, nrow=n, ncol=length(pos))
  colnames(resum) <- colnames(var)
  var <- as.matrix(var)
  for(i in 1:n){
    vari <- var[(sp[, i]==1), ]
    if(!is.matrix(vari)){
      vari <- as.matrix(vari)
    }
    resum[i, ] <- apply(vari, 2, fun, na.rm=TRUE)    
  }
  
  resul <- as.data.frame(cbind(Species, resum))
  
  for(i in 2:ncol(resul)){
    resul[, i] <- as.numeric(levels(resul[, i]))[resul[, i]]
  }
  
  return(resul)
}
