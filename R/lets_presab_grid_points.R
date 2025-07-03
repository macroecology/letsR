#' Create a presence-absence matrix based on species' point occurrences 
#' within a user's grid shapefile (beta version)
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description  Convert species' occurrences points into a presence-absence
#'   matrix based on a grid in shapefile format.
#' @inheritParams lets.presab
#' @inheritParams lets.presab.grid
#' @inheritParams lets.presab.points
#' @param abundance Logical. If TRUE, the resulting matrix will display number
#'   of occurrences per species in each cell. If FALSE, the resulting matrix
#'   will show presence-absence values.
#' 
#' @details This function is an alternative way to create a presence absence
#'   matrix when users already have their own grid.
#'  
#' @return The result is a \code{list} containing two objects: 
#' 
#'  (I) A matrix the species presence (1) and absence (0) values per sample unity.
#'  
#'  (II) The original grid.
#' 
#' @seealso \code{\link{lets.presab.points}}
#' @seealso \code{\link{lets.presab.grid}} 
#' 
#' @examples \dontrun{
#' # Species polygons
#' data("wrld_simpl")
#' 
#' # Grid
#' crs = "+proj=longlat +datum=WGS84 +no_defs"
#' sp.r <- terra::as.polygons(terra::rast(
#'   resol = 5,
#'   crs = crs,
#'   xmin = -93,
#'   xmax = -29,
#'   ymin = -57,
#'   ymax = 15
#' ))
#' sp.r$ID <- 1:length(sp.r)
#' 
#' # Occurrence Points
#' N = 20
#' species <- c(rep("sp1", N), rep("sp2", N),
#'              rep("sp3", N), rep("sp4", N))
#' x <- runif(N * 4, min = -69, max = -51)
#' y <- runif(N * 4, min = -23, max = -4)
#' xy <- cbind(x, y)
#' 
#' # PAM
#' resu <- lets.presab.grid.points(xy, species, sp.r, "ID", abundance = FALSE)
#' 
#' # Plot
#' rich_plus1 <- rowSums(resu$PAM[, -1, drop = FALSE]) + 1
#' colfunc <- colorRampPalette(c("#fff5f0", "#fb6a4a", "#67000d"))
#' colors <- c("white", colfunc(max(rich_plus1)))
#' occs <- terra::vect(xy, crs = crs)
#' plot(resu$grid, border = "gray40",
#'      col = colors[rich_plus1])
#' plot(sf::st_geometry(wrld_simpl), add = TRUE)
#' plot(occs, cex = 0.5, col = rep(1:4, each = N), add = T)
#' }
#' 
#' 
#' 
#' @export



lets.presab.grid.points <- function(xy,
                                    species, 
                                    grid,
                                    sample.unit,
                                    remove.sp = TRUE,
                                    abundance = TRUE) {
  
  if (is.null(sample.unit)) {
    stop("Object sample.unit not defined, without a default") 
  }
  if (is.null(xy) | !is.matrix(xy) | (ncol(xy) != 2)) {
    stop("Object xy should be two dimension matrix") 
  }
  if (is.null(species) | length(species) != nrow(xy) | !is.character(species)) {
    stop("Object species should be a character of same length as xy") 
  }
  if (is.null(grid)) {
    stop("Object grid not defined, without a default") 
  }
  if (!any(sample.unit %in% names(grid))) {
    stop("sample.unit name not found in the grid object")
  }
  
  shapes <- terra::vect(xy, crs = terra::crs(grid, proj = TRUE))
  shapes$BINOMIAL <- species
  proj1 <-
    is.null(terra::crs(shapes, proj = TRUE)) |
    is.na(terra::crs(shapes, proj = TRUE))
  proj2 <-
    is.null(terra::crs(grid, proj = TRUE)) |
    is.na(terra::crs(grid, proj = TRUE))
  
  spp <- unique(species)
  n <- length(spp)
  su <- grid[[sample.unit]][, 1]
  n_row <- length(su)
  
  # Matrix
  pam.par <- matrix(0, ncol = n + 1, nrow = n_row)
  
  # Cover
  #a <- terra::intersect(grid, shapes)
  a <- terra::relate(shapes, grid,  "within", pairs = TRUE)
  gover <- data.frame("BINOMIAL" = species, sample.unit = a[, 2])
  for (i in seq_len(nrow(gover))) {
    ri <- gover[i, 2] == su
    ci <- which(gover[i, 1] == spp) + 1
    pam.par[ri, ci] <- 1 + pam.par[ri, ci]
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
  if (!abundance) {
    result <- ifelse(result[, -1, drop = FALSE] > 0, 1, 0) 
  }
  
  
  # Return row and column position
  return(list("PAM" = result, "grid" = grid))
}
