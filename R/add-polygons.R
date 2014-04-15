#' Add polygon values to a PresenceAbscence object
#' 
#' @author Bruno Vilela
#' 
#' @description Add polygon values to a PresenceAbsence object .
#'
#' @usage lets.addpoly(x, y, onlyvar=F)
#' 
#' @param x A PresenceAbsence object. 
#' @param y Polygon values to add.
#' @param z Name of polygon values.
#' @param onlyvar If True only the matrix object will be returned.
#' 
#' @return The result is a presence-absence matrix of species with 
#' the polygon values added as columns at the right-end of the matrix . The Values represent
#' the percentage of the cell covered by the polygon.   
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