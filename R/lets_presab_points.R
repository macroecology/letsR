#'Create a presence-absence matrix based on species' point occurrences
#'
#'@author Bruno Vilela & Fabricio Villalobos
#'
#'@description Convert species' occurrences points into a presence-absence
#'  matrix based on a user-defined grid.
#'
#'@inheritParams lets.presab
#'@param xy A matrix with geographic coordinates of species occurrences, first
#'  column is the longitude (or x), and the second latitude (or y).
#'@param species Character vector with species names, in the same order as the
#'  coordinates.
#'
#'@inherit lets.presab return
#'
#'
#'@details The function creates the presence-absence matrix based on a raster
#'  file. Depending on the cell size, extension used and number of species it
#'  may require a lot of memory, and may take some time to process it. Thus,
#'  during the process, if \code{count} argument is set \code{TRUE}, a counting
#'  window will open so you can see the progress (i.e. in what polygon the
#'  function is working). Note that the number of polygons is not the same as
#'  the number of species that you have (i.e. a species may have more than one
#'  polygon/shapefiles).
#'
#'@seealso \code{\link{plot.PresenceAbsence}}
#'@seealso \code{\link{lets.presab.birds}}
#'@seealso \code{\link{lets.presab}}
#'@seealso \code{\link{lets.shFilter}}
#'
#' @examples \dontrun{
#' species <- c(rep("sp1", 100), rep("sp2", 100),
#'              rep("sp3", 100), rep("sp4", 100))
#' x <- runif(400, min = -69, max = -51)
#' y <- runif(400, min = -23, max = -4)
#' xy <- cbind(x, y)
#' PAM <- lets.presab.points(xy, species, xmn = -93, xmx = -29,
#'                           ymn = -57, ymx = 15)
#' summary(PAM)
#' # Species richness map
#' plot(PAM, xlab = "Longitude", ylab = "Latitude",
#'      main = "Species richness map (simulated)")
#'
#' # Map of the specific species
#' plot(PAM, name = "sp1")
#' }
#' 
#' 
#' @export
#' @import terra



lets.presab.points <- function(xy,
                               species,
                               xmn = NULL,
                               xmx = NULL,
                               ymn = NULL,
                               ymx = NULL,
                               resol = NULL,
                               remove.cells = TRUE,
                               remove.sp = TRUE,
                               show.matrix = FALSE,
                               crs = "+proj=longlat +datum=WGS84",
                               count = FALSE) {
  
  # Get species name
  if (is.factor(species)) {
    nomes <- levels(species)
    nomes <- nomes[nomes %in% species]
  } else {
    nomes <- levels(factor(species))
  }
  
  # Adjust null limits and resolution
  if (any(is.null(c(xmn, xmx, ymn, ymx)))) {
    limits <- terra::ext(terra::vect(xy, crs = crs))
    xmn <- limits[1]
    xmx <- limits[2]
    ymn <- limits[3]
    ymx <- limits[4]
  }
  
  if (is.null(resol)) {
    resol <- terra::res(terra::project(terra::rast(), crs))
  }
  
  # Raster creation
  ras <- terra::rast(xmin = xmn,
                xmax = xmx,
                ymin = ymn,
                ymax = ymx,
                crs = as.character(crs),
                resolution = resol)
  terra::values(ras) <- 1
  
  # Coordinates xy
  l.values <- length(values(ras))
  coord <- terra::xyFromCell(ras, 1:l.values)
  colnames(coord) <- c("Longitude(x)", "Latitude(y)")
  
  # Matrix creation
  n <- length(nomes)
  matriz <- matrix(0, ncol = n, nrow = l.values)
  colnames(matriz) <- nomes
  
  # progress bar
  if (count) {
    pb <- utils::txtProgressBar(min = 0,
                                max = n,
                                style = 3)
  }

  for (i in seq_len(n)) {
    celulas2 <- .extractpos.points(species, nomes[i], xy, ras)
    matriz[celulas2, i] <- 1
    if (count) {
      utils::setTxtProgressBar(pb, i)
    }
    
  }

  
  Resultado <- cbind(coord, matriz)
  
  if (remove.cells) {
    Resultado <- .removeCells(Resultado)
  }
  if (remove.sp) {
    Resultado <- .removeSp(Resultado)
  }
  
  # Close progress bar
  if (count) {
    close(pb)
  }
  
  if (show.matrix) {
    return(Resultado)
  } else {
    terra::values(ras) <- rowSums(matriz)
    final <- list("Presence_and_Absence_Matrix" = Resultado,
                  "Richness_Raster" = ras, 
                  "Species_name" = colnames(Resultado)[-(1:2)])
    class(final) <- "PresenceAbsence"
    return(final)
  }
}


# Axuliar function to avoid code repetition inside the loop <<<<<<<<<

# Function to extract cell positions in the raster

.extractpos.points <- function(species, nomesi, xy, ras) {
  pos <- species == nomesi
  xy2 <- xy[pos, , drop = FALSE]
  celulas <- terra::extract(ras, xy2, cells = TRUE)[, 1]
  return(celulas)
}
