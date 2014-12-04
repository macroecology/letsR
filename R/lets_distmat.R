#' Geographic distance matrix
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Calculates geographic distance matrix based on a two column matrix of x(longitude) and y(latitude).
#'
#' @usage lets.distmat(xy, count=TRUE)
#' 
#' @param xy Matrix with two columns, first the longitude and second the latitude.
#' @param count Logical, if \code{TRUE} a counting window will open.
#' 
#' @return Returns an object of class "dist".
#'   
#' @export


lets.distmat <- function(xy, count=TRUE){
  n <- nrow(xy)
  distan <- matrix(ncol=n, nrow=n)
  
  if(count == TRUE){
    dev.new(width=2, height=2, pointsize = 12)
    par(mar=c(0, 0, 0, 0))
    x <- 0 
    n2 <- ((n*n)-n)/2
  for(i in (1:(n-1))){
    for(j in ((i+1):n)){
      x <- x+1
      plot.new()
      text(0.5, 0.5, paste(paste("Total:", n2, "\n","Runs to go: ", (n2-x))))      
      distan[j,i] <- rdist.earth(as.matrix(xy[i, ]), as.matrix(xy[j, ]), miles=F)      
    }
  }
  }
  
  if(count == FALSE){
    for(i in (1:(n-1))){
      for(j in ((i+1):n)){
        distan[j,i] <- rdist.earth(as.matrix(xy[i, ]), 
                                   as.matrix(xy[j, ]),
                                   miles=F)      
      }
    }
  }
  
  
  return(as.dist(distan))
}

