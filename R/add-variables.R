#' Add variables to a PresenceAbscence object
#' 
#' @author Bruno Vilela
#' 
#' @description Add variables in raster format to a PresenceAbsence object.
#'
#' @usage lets.addvar(x, y, onlyvar=F)
#' 
#' @param x A PresenceAbsence object. 
#' @param y Variables to be added in Raster or RasterStack format.
#' @param onlyvar If True only the variable matrix will be returned.
#' @return The result is a matrix of species presence/absence with 
#' the variables columns added at the end.  
#'  
#' @seealso lets.presab.birds
#' @seealso lets.presab
#' @seealso lets.addpoly
#' 
#' @export

lets.addvar <- function(x, y, onlyvar=F){
 var_c <- crop(y, x$R)
 res1 <- res(var_c)[1]
 res2 <- res(x$R)[1]
 if(res2>res1){
   var_a <- aggregate(var_c, fact= (res2/res1), na.rm=T)
 }
 if(res2<res1){
   var_a <- disaggregate(var_c, fact= (res1/res2), na.rm=T)
 }
 if(res2==res1){
   var_a <- var_c
 }
 var_r <- resample(var_a, x$R)
 var_e <- extract(var_r, x$P[, 1:2]) 
 resultado <- cbind(x$P, var_e)
 if(onlyvar==T){
  return(var_e) 
 }else{
 return(resultado)
}
}
