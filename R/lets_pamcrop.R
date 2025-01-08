#' Crop a PresenceAbsence object based on an input shapefile
#'
#' @author Bruno Vilela
#'
#' @description Crop a PresenceAbsence object based on a shapefile provided by
#'   the user.
#'
#' @param x A \code{\link{PresenceAbsence}} object.
#' @param shp Object of class SpatVector (see function
#'   \code{terra::vect}) to crop the PresenceAbsence object.
#' @param remove.sp Logical, if \code{TRUE} the final matrix will not contain
#'   species that do not match any cell in the grid.
#'@param remove.cells Logical, if \code{FALSE} the final matrix will not contain
#'  cells in the grid with a value of zero (i.e. sites with no species present).
#'
#' @return The result is an object of class PresenceAbsence croped.
#'
#'
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab.birds}}
#'
#' @examples \dontrun{
#' data(PAM)
#' data("wrld_simpl")
#' 
#' # PAM before crop
#' plot(PAM, xlab = "Longitude", ylab = "Latitude",
#'      main = "Phyllomedusa species richness")
#' 
#' # Crop PAM to Brazil
#' data(wrld_simpl)  # World map
#' Brazil <- wrld_simpl[wrld_simpl$NAME == "Brazil", ]  # Brazil (polygon)
#' PAM_crop <- lets.pamcrop(PAM, Brazil, remove.sp = TRUE)
#' plot(PAM_crop, xlab = "Longitude", ylab = "Latitude",
#'      main = "Phyllomedusa species richness (Brazil crop)")
#' plot(sf::st_geometry(wrld_simpl), add = TRUE)
#' }
#' @importFrom stats na.exclude
#' @export


lets.pamcrop <- function(x, shp, remove.sp = TRUE,
                         remove.cells = FALSE) {
  
  if (!methods::is(x, "PresenceAbsence")) {
    stop("x is not a PresenceAbsence object")
  } else {
    x <- .check_pam(x)
  }
  shp <- .check_shape(shp)
  
  # Set NA to raster data outside shp
  remover <- terra::extract(x[[2]], shp, cells = TRUE, 
                      weights = TRUE)[, 3]
  remover <- na.exclude(remover)
  terra::values(x[[2]])[-remover] <- NA
  
  if (all(is.na(terra::values(x[[2]])))) {
    stop("No species left after croping the PAM")
  }
  
  # Remove cells from the matrix
  manter <- terra::extract(x[[2]], x[[1]][, 1:2])
  if (remove.cells) {
    x[[1]] <- x[[1]][!is.na(manter[, 1]), ]
  } else {
    x[[1]][is.na(manter[, 1]), -(1:2)] <- 0
  }
  # Remove species without presence
  if (remove.sp) {
    x[[1]] <- .removeSp(x[[1]])
  }
  
  # Rename columns
  x[[3]] <- colnames(x[[1]])[-(1:2)]
  
  return(x)
}
