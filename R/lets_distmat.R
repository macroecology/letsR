#' Compute a geographic distance matrix
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Calculates a geographic distance matrix based on a two column matrix of x(longitude) and y(latitude).
#'
#' 
#' @param xy A PresenceAbsence object or a matrix with two columns (longitude, latitude).
#' @param asdist Logical, if \code{TRUE} the result will be an object of class "dist",
#' if \code{FALSE} the result will be an object of class "matrix".
#' @param ... Arguments to be passed to the function \link{\code{rdist.earth}}.
#'   
#' @details This function basically facilitates the use of \link{\code{rdist.earth}} of 
#' the package fields on a PresenceAbsence object, allowing also the user to have directly 
#' a "dist" object.
#' 
#'  @return The user can choose between "dist" and "matrix" class object to be return.
#'  The resulting values are in kilometers (but see the argument 'miles' in \link{\code{rdist.earth}}).  
#'    
#' @examples \dontrun{
#' data(PAM)
#' distPAM <- lets.distmat(PAM)   
#' }       
#' @export


lets.distmat <- function(xy, asdist = TRUE, ...) {
  
  # If a presence absence change to coordinates
  if (class(xy) == "PresenceAbsence"){
    xy <- xy[[1]][, 1:2]
  }
  
  # Default in Km
  if (exists("miles")) {
    # Calculate the distance matrix
    distan <- rdist.earth(xy, miles = FALSE, ...)
  } else {
    distan <- rdist.earth(xy, ...)
  }
  
  # Transform in a distance matrix
  if (asdist) {
    distan <- as.dist(distan)
  }
  
  return(distan)
}

