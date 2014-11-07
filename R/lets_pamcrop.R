#' Crop a PAM object from a shapefile
#' 
#' @author Bruno Vilela
#' 
#' @description Crop a PresenceAbsence object based on a shapefile.
#' 
#' @param x A PresenceAbsence object to be croped.
#' @param shp Object of class SpatialPolygonsDataFrame (see function \code{\link{readShapePoly}} to to crop the PresenceAbsence object.
#' @param remove.cells Logical, if \code{TRUE} the final matrix will not contain cells in the grid with a value of zero (i.e. sites with no species present).
#' @param remove.sp Logical, if \code{TRUE} the final matrix will not contain species that do not match any cell in the grid.
#' 
#' 
#' @return The result is an object of class PresenceAbsence croped.
#' 
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab.birds}} 
#' 
#' 
#' @export


lets.PAMcrop <- function(x, shp, remove.cells=TRUE, remove.sp=TRUE){

remover1 <- extract(x$R, shp, cellnumbers=T, weights=T, small=T)
remover2 <- do.call(rbind.data.frame, remover1)[, 1]
values(x[[2]])[-remover2] <- NA
manter <- extract(x$R, x$P[, 1:2])
x[[1]] <- x$P[!is.na(manter), ]

if(remove.cells){
  x[[1]] <- .removeCells(x$P)
}
if(remove.sp){
  x[[1]] <- .removeSp(x$P)
}
x[[3]] <- colnames(x$P)[-(1:2)]

return(x)
}