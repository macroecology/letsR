#' Transform IUCN RedList conservation status to continuous values
#' 
#' @author Bruno Vilela
#' 
#' @description Transform IUCN RedList conservation status to continuous values ranging from 0 to 5.
#'
#' @usage lets.iucncont(x, dd=NA, ne=NA)
#' 
#' @param x A vector or a matrix containing IUCN codes to be transformed.
#' @param dd The value to be attributed to DD (data-deficient) species, the default option is NA. 
#' @param ne The value to be attributed to NE (not-evaluated) species, the default option is NA. 

#' @return Returns a vector/matrix with continuos values from 0 to 5.
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
#' @seealso \code{\link{lets.iucn}}
#' 
#' @examples \dontrun{
#' #Vector transformation
#' status <- sample(c("EN","VU", "NT", "CR", "DD", "LC", "EX"), 30, replace=TRUE) 
#' transV <- lets.iucncont(status)
#' 
#' #matrix transformation
#' data(IUCN)
#' transM <- lets.iucncont(iucn)
#' 
#' }
#' 
#' @export
#'
#' @references Purvis A et al., 2000. Predicting extinction risk in declining species. Proceedings of the Royal Society of London. Series B: Biological Sciences, 267.1456: 1947-1952. 



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
