#' Fits a PAM object into a grid
#' 
#' @author Bruno Vilela
#' 
#' @description This function create a grid in shapefile format and add its IDs to the presence absence matrix.
#' The function was created to make easier the use of Presence Absence Matrix for the ones who prefer to work into a grid in shapefile. 
#' 
#' @param x A PresenceAbsence object.
#' 
#' @return The result is a list of two objects. The first is a grid in shapefile format;
#' the second is a presence absence matrix with an aditional column called SP_ID (shapefile cell identifier).
#'  
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab.birds}} 
#' 
#' 
#' @export

lets.gridirizer <- function(x){
  
  grid <- rasterToPolygons(x$R)
  r <- rasterize(grid, x$R, 1:nrow(grid@data))
  SP_ID <- extract(r, x$P[, 1:2])
  resultado <- cbind(SP_ID, x$P)
  colnames(grid@data) <- "Species_Richness"
  return(list("Grid"=grid, "Presence Absence Matrix"=resultado))
  
}