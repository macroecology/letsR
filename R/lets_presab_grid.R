#' Create a presence-absence matrix of species' geographic ranges 
#' within a user's grid shapefile (beta version)
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Convert species' ranges (in shapefile format) into a presence-absence matrix based on a grid in shapefile format.
#'
#' @inheritParams lets.presab 
#' @param grid Object of class shapefile representing the spatial grid (e.g. regular/irregular cells, 
#' political divisions, hexagonal grids, etc). 
#' The grid and the shapefiles must be in the same projection.
#' @param sample.unit Object of class \code{character} with the name of the column (in the grid) 
#' representing the sample units of the presence absence matrix.
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
#' @examples \dontrun{
#' # Species polygons
#' data("Phyllomedusa")
#' 
#' # Grid 
#' sp.r <- terra::as.polygons(terra::rast(resol = 5, 
#' crs = terra::crs(Phyllomedusa),
#' xmin = -93, xmax = -29, ymin = -57, ymax = 15))
#' sp.r$ID <- 1:length(sp.r)
#'                          
#' 
#' # PAM
#' resu <- lets.presab.grid(Phyllomedusa, sp.r, "ID")
#' 
#' # Plot
#' rich_plus1 <- rowSums(resu$PAM[, -1]) + 1
#' colfunc <- colorRampPalette(c("#fff5f0", "#fb6a4a", "#67000d"))
#' colors <- c("white", colfunc(max(rich_plus1)))
#' plot(resu$grid, border = "gray40",
#'      col = colors[rich_plus1])
#' map(add = TRUE)
#' }
#' 
#' 
#' @import terra sf
#' 
#' @export


lets.presab.grid <- function(shapes, 
                             grid,
                             sample.unit,
                             remove.sp = TRUE,
                             presence = NULL,
                             origin = NULL, 
                             seasonal = NULL) {
  
  if (is.null(sample.unit)) {
   stop("Object sample.unit not defined, without a default") 
  }
  if (is.null(shapes)) {
    stop("Object shapes not defined, without a default") 
  }
  if (is.null(grid)) {
    stop("Object grid not defined, without a default") 
  }
  if (!any(sample.unit %in% names(grid))) {
    stop("sample.unit name not found in the grid object")
  }
  
  shapes <- .check_shape(shapes)
  
  proj1 <-
    is.null(terra::crs(shapes, proj = TRUE)) |
    is.na(terra::crs(shapes, proj = TRUE))
  proj2 <-
    is.null(terra::crs(grid, proj = TRUE)) |
    is.na(terra::crs(grid, proj = TRUE))
  
  if (!(proj1 | proj2)) {
    
    # Check projection
    if (terra::crs(shapes, proj = TRUE) != terra::crs(grid, proj = TRUE)) {
      stop("The shapes object and the grid 
         should be in the same projection")
    }
    
  } else {
    
    if (!(proj1 & proj2)) {
      stop("The shapes object and the grid 
         should be in the same projection")
    }
  }
  # Filter the species range distribution
  if (!all(is.null(presence), is.null(origin), is.null(seasonal))) {
    shapes <- lets.shFilter(shapes = shapes, 
                            presence = presence, 
                            origin = origin, 
                            seasonal = seasonal)
  }
  
  
  # Error control for no shapes after filtering
  if (is.null(shapes) | nrow(shapes) == 0) {
    stop("After filtering no species distributions left")
  }

  # species
  names(shapes) <- toupper(names(shapes))
  names(shapes)[names(shapes) %in% c("SCINAME",
                                     "SCI_NAME",
                                     "SPECIES")] <- "BINOMIAL"
  spp <- unique(shapes$BINOMIAL)
  n <- length(spp)
  su <- grid[[sample.unit]][, 1]
  n_row <- length(su)
  
  # Matrix
  pam.par <- matrix(0, ncol = n + 1, nrow = n_row)
  
  # Cover
  a <- terra::intersect(grid, shapes)
  gover <- as.data.frame(a[, c(sample.unit, "BINOMIAL")])
  for (i in seq_len(nrow(gover))) {
    pam.par[gover[i, 1], which(gover[i, 2] == spp) + 1] <- 1
  }
  
  # Final table names
  colnames(pam.par) <- c(sample.unit, as.character(spp))
  pam.par[, 1] <- grid[[sample.unit]][, 1]
  
  # remove duplicated
  result <- .unicas(pam.par)
  
  # Remove.sp
  if (remove.sp) {
  result <- result[, colSums(result) != 0, drop = FALSE] 
  }
  
  # Return row and column position
  return(list("PAM" = result, "grid" = grid))
}
