#' Add polygon coverage to a PresenceAbscence object
#' 
#' @author Bruno Vilela
#' 
#' @description Add polygon coverage within cells of a PresenceAbsence object.
#'
#' @usage lets.addpoly(x, y, z, onlyvar=F)
#' 
#' @param x A PresenceAbsence object. 
#' @param y Polygon of interest.
#' @param z A character indicating the column name of the polygon containing the attributes to be used.
#' @param onlyvar If \code{TRUE} only the matrix object will be returned.
#' 
#' @return The result is a presence-absence matrix of species with 
#' the polygons' attributes used added as columns at the right-end of the matrix . The Values represent
#' the percentage of the cell covered by the polygon attribute used.   
#'  
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.addvar}}
#' 
#' @examples \dontrun{
#' data(PAM)  # Phyllomedusa presence-absence matrix
#' data(wrld_simpl)  # World map
#' Brazil <- wrld_simpl[wrld_simpl$NAME=="Brazil", ]  # Brazil (polygon)
#' 
#' # Check where is the variable name (in this case it is in "NAME" which will be my z value)
#' names(Brazil)
#' 
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
  grid <- rasterToPolygons(x$R)
  areagrid <- try(areaPolygon(grid), silent=TRUE)
  if(class(areagrid)=="try-error"){areagrid <- values(area(r))*1000000}  
  areashape <- areaPolygon(y)
  position <- which(!is.na(valores))
  for(i in 1:n){
    celu <- extract(x$R, y[i,], cellnumber=T, small=T,  weights=T)
    celu2 <- do.call(rbind.data.frame, celu)
    if(!is.null(celu2[, 2])){
      celu2 <- celu2[!is.na(celu2[, 2]), ]
    }
    prop <- round((celu2[, 3]*areashape[i])/areagrid[position%in%celu2[, 1]], 2)
    if(any(prop>1)){
      prop[prop>1] <- 1
    }
    matriz[celu2[, 1], i] <- prop
  }
  
  r <- rasterize(xy, x$R, matriz)
  r_e <- extract(r, x$P[, 1:2])
  r_e <- as.matrix(r_e)
  colnames(r_e) <- nomes
  
  if(onlyvar==T){
    return(r_e) 
  }else{
    resultado <- cbind(x$P, r_e)
    return(resultado)
  }
}
