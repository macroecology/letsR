#' Fits a grid into a PresenceAbsence object
#' 
#' @author Bruno Vilela
#' 
#' @description This function creates a grid in shapefile format and adds its cells' IDs to the presence-absence matrix.
#' The function was created to facilitate the use of the PresenceAbsence object for the ones who prefer to work with a grid in shapefile format. 
#' 
#' @param x A \code{\link{PresenceAbsence}} object.
#' 
#' @return The result is a list of two objects. The first is a grid in shapefile format;
#' the second is a presence-absence matrix with an aditional column called SP_ID (shapefile cell identifier).
#'  
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab.birds}} 
#' 
#' 
#' @export

lets.gridirizer <- function(x) {
  
  grid <- rasterToPolygons(x[[2]])
  r <- rasterize(grid, x[[2]], 1:nrow(grid@data))
  SP_ID <- extract(r, x[[1]][, 1:2])
  resultado <- cbind(SP_ID, x[[1]])
  colnames(grid@data) <- "Species_Richness"
  return(list("Grid" = grid, "Presence_Absence_Matrix" = resultado))
  
}
