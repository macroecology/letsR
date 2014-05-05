#' Add polygon values to a PresenceAbscence object
#' 
#' @author Bruno Vilela
#' 
#' @description Add polygon values to a PresenceAbsence object.
#'
#' @usage lets.addpoly(x, y, z, onlyvar=F)
#' 
#' @param x A PresenceAbsence object. 
#' @param y Polygon values to add.
#' @param z Column name of where is located the polygon names to be used.
#' @param onlyvar If \code{TRUE} only the matrix object will be returned.
#' 
#' @return The result is a presence-absence matrix of species with 
#' the polygons names added as columns at the right-end of the matrix . The Values represent
#' the percentage of the cell covered by the polygon.   
#'  
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.addvar}}
#' 
#' @examples \dontrun{
#' data(PAM)  # Phyllomedusa presence-absence matrix
#' data(wrld_simpl)  # World map
#' Brazil <- wrld_simpl[wrld_simpl$NAME=="Brazil", ]  # Brazil (polygon)
#' names(Brazil)  # Check where is the variable name (in this case it is in "NAME" which will be my z value) 
#' PAM_pol <- lets.addpoly(PAM, Brazil, "NAME")
#' }
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
 r_e <- extract(r, x$P[, 1:2])
 r_e <- as.matrix(r_e)
 colnames(r_e) <- nomes
 resultado <- cbind(x$P, r_e)
 if(onlyvar==T){
  return(r_e) 
 }else{
  return(resultado)
 }
}
