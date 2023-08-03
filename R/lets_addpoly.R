#' Add polygon coverage to a PresenceAbscence object
#' 
#' @author Bruno Vilela
#' 
#' @description Add polygon coverage within cells of a PresenceAbsence object.
#' @inheritParams lets.presab
#' @param x A \code{\link{PresenceAbsence}} object. 
#' @param y Polygon of interest.
#' @param z A character indicating the column name of the polygon containing the
#'  attributes to be used.
#' @param onlyvar If \code{TRUE} only the matrix object will be returned.
#' 
#' @return The result is a presence-absence matrix of species with 
#' the polygons' attributes used added as columns at the right-end of the matrix.
#' The Values represent the percentage of the cell covered by the polygon 
#' attribute used.   
#'  
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.addvar}}
#' 
#' @examples \dontrun{
#' data(PAM)  # Phyllomedusa presence-absence matrix
#' data(wrld_simpl)  # World map
#' Brazil <- wrld_simpl[wrld_simpl$NAME == "Brazil", ]  # Brazil (polygon)
#' 
#' # Check where is the variable name 
#' # (in this case it is in "NAME" which will be my z value)
#' names(Brazil)
#' 
#' PAM_pol <- lets.addpoly(PAM, Brazil, "NAME", onlyvar = TRUE)
#' }
#' 
#' @import terra sf
#' @export

lets.addpoly <- function(x, y, z, onlyvar = FALSE, count = FALSE){
  
  # Defensive functions
  ## Check shape
  y <- .check_shape(y)
  
  if (!z %in% names(y)) {
    stop(paste("Couldn't find the atttribute", z, "in the polygon y"))
  }
  
  if (!methods::is(x, "PresenceAbsence")) {
    stop("x is not a PresenceAbsence object")
  } else {
    x <- .check_pam(x)
  }
  ## Projections
  if (as.character(terra::crs(y)) != as.character(terra::crs(x[[2]]))) {
    warning("Reprojecting y to match the projection in x")
    y <- terra::project(y, terra::crs(x[[2]]))
  }
  
  n <- terra::ncell(x[[2]])
  ids <- unique(y[[z]][[1]])
  res <- matrix(0, nrow = n, ncol = length(ids))

  # progress bar
  if (count) {
    pb <- utils::txtProgressBar(min = 0,
                                max = length(ids),
                                style = 3)
  }

  for (i in seq_along(ids)) {
    cells_pos <- terra::extract(x[[2]],
                                y[ids[i] == y[[z]][[1]], ],
                                cells = TRUE,
                                weights = TRUE)
    res[cells_pos[, 3], i] <- round(cells_pos[, 4], 4)
    # progress bar
    if (count) {
      utils::setTxtProgressBar(pb, i)
    }
    
  }
  colnames(res) <- ids
  res <- res[terra::cellFromXY(x[[2]], x[[1]][, 1:2]), , drop = FALSE]
  
  if (onlyvar) {
    return(res) 
  } else {
    resultado <- cbind(x[[1]], res)
    return(resultado)
  }
}
