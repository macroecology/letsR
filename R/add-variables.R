#' Add variables to a PresenceAbscence object
#' 
#' @author Bruno Vilela
#' 
#' @description Add variables (in raster format) to a PresenceAbsence object.
#'
#' @usage lets.addvar(x, y, onlyvar=F, fun=mean)
#' 
#' @param x A PresenceAbsence object. 
#' @param y Variables to be added in Raster or RasterStack format.
#' @param onlyvar If \code{TRUE} only the matrix object will be returned.
#' @param fun Function used to aggregate values.
#' 
#' @return The result is a presence-absence matrix of species with 
#' the variables added as columns at the right-end of the matrix.  
#'  
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.addpoly}}
#' 
#' @examples \dontrun{
#' data(temp)  # Global mean temperature
#' data(PAM)  # Phyllomedusa presence-absence matrix
#' PAM_temp <- lets.addvar(PAM, temp)
#' }
#' 
#' @export

lets.addvar <- function(x, y, onlyvar=F, fun=mean){
 var_c <- crop(y, x$R)
 res1 <- res(var_c)[1]
 res2 <- res(x$R)[1]
 if(res2>res1){
   var_a <- aggregate(var_c, fact= (res2/res1), na.rm=T, fun)
 }
 if(res2<res1){
   var_a <- disaggregate(var_c, fact= (res1/res2), na.rm=T)
 }
 if(res2==res1){
   var_a <- var_c
 }
 var_r <- resample(var_a, x$R)
 var_e <- extract(var_r, x$P[, 1:2]) 
 var_e <- as.matrix(var_e)
 colnames(var_e) <- names(y)
 resultado <- cbind(x$P, var_e)
 if(onlyvar==T){
  return(var_e) 
 }else{
 return(resultado)
}
}
