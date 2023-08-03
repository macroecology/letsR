#' Compute a geographic distance matrix
#'
#' @author Bruno Vilela & Fabricio Villalobos
#'
#' @description Calculates a geographic distance matrix based on a
#'   \code{PresenceAbsence} or a two column \code{matrix} of x(longitude) and
#'   y(latitude).
#'
#' @param xy A \code{\link{PresenceAbsence}} object or a \code{matrix} with two
#'   columns (longitude, latitude).
#' @param asdist Logical, if \code{TRUE} the result will be an object of class
#'   \code{dist}, if \code{FALSE} the result will be an object of class
#'   \code{matrix}.
#'
#' @details This function basically facilitates the use of
#'   \code{terra::distance} on a \code{PresenceAbsence} object, allowing also
#'   the user to have directly a \code{dist} object. The distance is always
#'   expressed in meter if the coordinate reference system is
#'   longitude/latitude, and in map units otherwise. Map units are typically
#'   meter, but inspect crs(x) if in doubt.


#'
#' @return The user can choose between \code{dist} and \code{matrix} class
#'   object to be returned. The resulting values are in kilometres (but see the
#'   argument 'unit' in \code{rdist.earth}).
#'
#' @examples \dontrun{
#' data(PAM)
#' distPAM <- lets.distmat(PAM)
#' }
#'
#' @export


lets.distmat <- function(xy, asdist = TRUE) {
  
  # If a presence absence change to coordinates
  if (!is.matrix(xy)) {
    if (inherits(xy, "PresenceAbsence")) {
      xy <- xy[[1]][, 1:2]
    }
  }

  distan <- terra::distance(xy, lonlat = TRUE)

  # Transform in a distance matrix
  if (!asdist) {
    distan <- as.matrix(distan)
  }
  
  return(distan)
}

