#' Transform IUCN conservation status to continuos values
#' 
#' @author Bruno Vilela
#' 
#' @description Transform IUCN conservation status to continuos values from 0 to 5.
#'
#' @usage lets.iucncont(x, dd=NA, ne=NA)
#' 
#' @param x A vector or a matrix containing IUCN codes.
#' @param dd The value to be atributed to DD species, the default option is NA. 
#' @param ne The value to be atributed to NE species, the default option is NA. 

#' @return Return a vector with continuos values from 0 to 5.
#' @details EX and EW = 5
#' 
#' EN = 4
#' 
#' CR = 3
#' 
#' VU = 2
#' 
#' NT = 1
#' 
#' LC = 0
#' 
#' DD = NA
#' 
#' NE = NA
#' 
#' @seealso lets.iucn
#' 
#' @export



lets.iucncont <- function (x, dd=NA, ne=NA) 
{

  x <- as.matrix(x)
  
  for(i in 1:ncol(x)){
   if(is.factor(x[, i])){
    x[, i] <- as.numeric(levels(x[, i]))[x[, i]]
   }
  }
  x[(x == "EX" | x == "EW")] <- 5
  x[x == "EN"] <- 4
  x[x == "CR"] <- 3
  x[x == "VU"] <- 2
  x[x == "NT"] <- 1
  x[x == "LC"] <- 0
  x[x == "DD"] <- dd
  x[x == "NE"] <- ne
  if (ncol(x) == 1) {
    x <- as.numeric(as.vector(x))
  }
  else {
    x <- as.data.frame(x)
  }
  return(x)
}
