#' Transform IUCN conservation status to continuos values
#' 
#' @author Bruno Vilela
#' 
#' @description Transform IUCN conservation status to continuos values from 0 to 5.
#'
#' @usage lets.iucncont(x, dd=NA)
#' 
#' @param x A vector or a matrix containing IUCN codes.
#' @param dd The value to be atributed to DD and NE species, the default option is NA. 
#' 
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



lets.iucncont <- function(x, dd=NA){
 x <- as.matrix(x)
 x[(x=="EX" | x=="EW")] <- 5
 x[x=="EN"] <- 4
 x[x=="CR"] <- 3
 x[x=="VU"] <- 2
 x[x=="NT"] <- 1
 x[x=="LC"] <- 0
 x[(x=="DD" | x=="NE")] <- dd

 if(ncol(x)==1){
   x <- as.numeric(as.vector(x))
 }else{
   x <- as.data.frame(x)
 }
return(x)
}