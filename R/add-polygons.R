#' Add polygon values to a PresenceAbscence object
#' 
#' @author Bruno Vilela
#' 
#' @description Add polygon information to a PresenceAbsence object.
#'
#' @usage lets.addpoly(x, y, onlyvar=F)
#' 
#' @param x An PresenceAbsence object. 
#' @param y Polygon information to be added.
#' @param z Name of the information inside the polygon.
#' @param onlyvar If True only the variable matrix will be returned.
#' 
#' @return The result is a matrix of species presence/absence with 
#' the polygon information columns added at the end. The Values repesent
#' the porcentage of the cell covered by the polygon.   
#'  
#' @seealso lets.presab.birds
#' @seealso lets.presab
#' @seealso lets.addvar
#' 
#' @export

lets.addpoly <- function(x, y, z, onlyvar=F){

pos1 <- which(names(y)==z)
 names(y)[pos1] <- "NOME"
 valores <- values(x$R)
 n <- nrow(y)
 matriz <- matrix(0, ncol=n, nrow=length(valores))
 nomes <- y$NOME
 colnames(matriz) <- nomes
 xy <- xyFromCell(x$R, 1:length(valores))
 for(i in 1:n){
  celu <- extract(x$R, y[i,], cellnumber=T, small=T,  weights=T)
  celu2 <- do.call(rbind.data.frame, celu)
  matriz[celu2[,1], i] <- celu2[,3]
 }
 r <- rasterize(xy, x$R, matriz)
 r_e <- extract(r, x$P[,1:2])
 resultado <- cbind(x$P, r_e)

 if(onlyvar==T){
  return(r_e) 
 }else{
  return(resultado)
 }
}