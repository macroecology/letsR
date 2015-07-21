#' Create a presence-absence matrix of species' geographic ranges 
#' within a user's grid shapefile (beta version)
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Convert species' ranges (in shapefile format) into a presence-absence matrix based on a grid in shapefile format.
#'
#' @param shapes Object of class \code{SpatialPolygonsDataFrame} (see function \code{\link{readShapePoly}} 
#' to open these files) containing the distribution of one or more species.
#' Species names should be in a column (within the .DBF table of the shapefile)
#' called BINOMIAL/binomial or SCINAME/sciname.
#' @param grid Object of class shapefile representing the spatial grid (e.g. regular/irregular cells, 
#' political divisions, hexagonal grids, etc). 
#' The grid and the shapefiles must be in the same projection.
#' @param sample.unit Object of class \code{character} with the name of the column 
#' representing the sample units of the presence absence matrix.
#' @param presence A vector with the code numbers for the presence type to be considered in the process 
#' (for IUCN spatial data \url{http://www.iucnredlist.org/technical-documents/spatial-data}, see metadata). 
#' @param origin A vector with the code numbers for the origin type to be considered in the process 
#' (for IUCN spatial data).
#' @param seasonal A vector with the code numbers for the seasonal type to be considered in the process 
#' (for IUCN spatial data).
#' 
#' @details This function is an alternative way to create a presence absence matrix when users
#' already have their own grid. 
#'  
#' @return The result is a \code{list} containing two objects: 
#' 
#'  (I) A matrix the species presence (1) and absence (0) values per sample unity.
#'  
#'  (II) The original grid.
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.shFilter}} 
#' 
#' @examples \dontrun {
#' 
#' # Grid 
#' sp.r <- rasterToPolygons(raster(resol = 5))
#' slot(sp.r, "data") <- cbind("ID" = 1:length(sp.r),
#'                             slot(sp.r, "data"))
#'  
#' # Species polygons
#' data(Phyllomedusa)
#' projection(Phyllomedusa) <- projection(sp.r)
#' 
#' # PAM
#' resu <- lets.presab.grid(Phyllomedusa, sp.r, "ID")
#' 
#' # Plot
#' rich_plus1 <- rowSums(resu$PAM) + 1
#' colfunc <- colorRampPalette(c("#fff5f0", "#fb6a4a", "#67000d"))
#' colors <- c("white", colfunc(max(rich_plus1)))
#' plot(resu$grid, border = "gray40",
#'      col = colors[rich_plus1])
#' map(add = TRUE)
#' 
#' }
#' 
#' 
#' @import rgeos
#' 
#' @export


lets.presab.grid <- function(shapes, 
                             grid,
                             sample.unit,
                             presence = NULL,
                             origin = NULL, 
                             seasonal = NULL) {
  
  # Check projection
  if (projection(shapes) != projection(grid)) {
    stop("The shapes object and the grid 
         should be in the same projection")
  }
  
  
  # Filter the species range distribution
  if (!all(is.null(presence), is.null(origin), is.null(seasonal))) {
    shapes <- lets.shFilter(shapes = shapes, 
                            presence = presence, 
                            origin = origin, 
                            seasonal = seasonal)
  }
  
  
  # Error control for no shapes after filtering
  if (is.null(shapes)) {
    stop("After filtering no species distributions left")
  }
  
  # Cover
  gover <- gOverlaps(shapes, grid, byid = TRUE)*1
  colnames(gover) <- shapes@data$binomial
  gcontains <- gContains(shapes, grid, byid = TRUE)*1
  colnames(gcontains) <- shapes@data$binomial
  
  # Sum
  pam.par <- ifelse(gover + gcontains > 0 , 1, 0)
  
  # remove duplicated
  result <- .unicas(pam.par)
  
  # Final table names
  rownames(result) <- grid@data[, sample.unit]
  
  # Return row and column position
  return (list("PAM" = result, "grid" = grid))
}
