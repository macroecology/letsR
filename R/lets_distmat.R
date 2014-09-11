#' Geographic distance matrix
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Calculates geographic distance matrix based on a two column matrix of x(longitude) and y(latitude).
#'
#' @usage lets.distmat(xy)
#' 
#' @param xy Matrix with two columns, first the longitude and second the latitude.
#'
#' @return Returns an object of class "dist".
#'   
#' @export


lets.distmat <- function(xy){
  n <- nrow(xy)
  distan <- matrix(ncol=n, nrow=n)
  for(i in (1:(n-1))){
    for(j in ((i+1):n)){
      distan[j,i] <- distCosine(p1=xy[i, ], p2=xy[j, ])      
    }
  }
  return(as.dist(distan))
}

