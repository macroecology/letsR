#' Transform values of a vector
#' 
#' @author Bruno Vilela
#' 
#' @description Transform each element of a vector.
#'
#' @usage lets.transf(x, y, z, NUMERIC=TRUE)
#' 
#' @param x A vector to be transformed.
#' @param y levels to be transformed. 
#' @param z The value to be atributed to each level (same order as y).
#' @param NUMERIC logical, if TRUE z will be considered numbers.

#' @return Return a vector with changed values.
#' 
#' 
#' @export



lets.transf <- function (x, y, z, NUMERIC=TRUE) 
{
    if(is.factor(x)){
      x <- as.numeric(levels(x))[x]
    }
    
    if(is.factor(y)){
      y <- as.numeric(levels(y))[y]
    }

  for(i in 1:length(y)){  
  x[x == y[i]] <- z[i]
  }
  if(NUMERIC==TRUE){
    x <- as.numeric(x)
  }
  return(x)
  
}
