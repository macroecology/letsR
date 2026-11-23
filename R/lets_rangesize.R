#' Compute species' geographic range sizes
#'
#' @author Bruno Vilela
#'
#' @description This function calculates species' range sizes from a
#'   PresenceAbsence object or directly from the species' shapefiles.
#'
#' @param x A \code{\link{PresenceAbsence}} or an
#'   \code{SpatVector} object.
#' @param species_name  Species names in the same order as in the
#'   \code{SpatVector} (only needed if x is a
#'   \code{SpatVector}).
#' @param coordinates "geographical" or "planar". Indicate whether the shapefile
#'   has geographical or planar coordinates(only needed if x is a
#'   \code{SpatVector}).
#' @param units "cell" or "squaremeter". Indicate if the size units wanted are
#'   in number of cells occupied or in square meters(only needed if x is a
#'   \code{PresenceAbsence} object).
#'
#' @return The result is a matrix with the range size of each species. If the
#'   range size accounts for the earth curvature (Yes or No) or its size unit
#'   may differ for each argument combination:
#' @return 1) SpatVector & geographical = Square meters. Yes.
#' @return 2) SpatVector & planar = Square meters.
#'   No.
#' @return 3) PresenceAbsence & cell = number of cells. No.
#' @return 4) PresenceAbsence & squaremeter = Square meters. Yes.
#'
#' @examples \dontrun{
#' # SpatialPolygonsDataFrame & geographical
#' data(Phyllomedusa)
#' rangesize <- lets.rangesize(x = Phyllomedusa,
#'                             coordinates = "geographic")
#'
#' # SpatialPolygonsDataFrame & planar
#' rangesize2 <- lets.rangesize(x = Phyllomedusa,
#'                              coordinates = "planar")
#'
#' # PresenceAbsence & cell
#' data(PAM)
#' rangesize3 <- lets.rangesize(x = PAM,
#'                              units = "cell")
#'
#' # PresenceAbsence & squaremeter
#' rangesize4 <- lets.rangesize(x = PAM,
#'                              units = "squaremeter")
#' }
#'
#'
#' @export


lets.rangesize <- function(x, species_name = NULL,
                           coordinates = "geographic", 
                           units = "cell") {
  
  
  
  
  # For PresenceAbsence
  if (inherits(x, "PresenceAbsence")) {
    x <- .check_pam(x)
    # Error control
    unt <- c("cell", "squaremeter")
    if (!any(units == unt)) {
      stop(paste("The units",  units,
                 "is not implemented.", 
                 "Please check the spelling."))
    }
    
    if (units == "cell") {
      Range_Size <- colSums(x$P[, -(1:2), drop = FALSE])
    }
    
    if (units == "squaremeter") {
      cellsize <- terra::cellSize(x[[2]])
      cellsize <-
        terra::values(cellsize)[terra::cellFromXY(cellsize, x[[1]][, 1:2])]
      Range_Size <- lets.summarizer(cbind(x[[1]], cellsize), 
                                    ncol(x[[1]]) + 1, fun = sum)
      
      Range_Size <- Range_Size[, 2]
    }
    
  } else {
    x <- .check_shape(x)
  }
  
  # For SpatVect
  if (inherits(x, "SpatVector")) {
    if (is.null(species_name)) {
      names(x) <- toupper(names(x))
      check_names <- names(x) %in% c("SCINAME", "SCI_NAME",
                                     "SPECIES", "BINOMIAL")
      if (!any(check_names)) {
        stop("argument species_name not provided")
      }
      names(x)[check_names] <- "BINOMIAL"
      species_name <- x$BINOMIAL
    }
    # Error control
    coords <- c("geographic", "planar")
    if (!any(coordinates == coords)) {
      stop(paste("The coordinates",  coordinates,
                 "is not implemented.", 
                 "Please check the spelling."))
    }
    
    if (coordinates == "planar") {
      Range_Size <- expanse(x, transform = FALSE)
    }
    
    if (coordinates == "geographic") {
      Range_Size <- expanse(x)
    }
    Range_Size <- as.matrix(Range_Size)
    rownames(Range_Size) <- species_name
    Range_Size2 <- aggregate(Range_Size[, 1] ~ species_name,
                             FUN = sum)
    Range_Size <- Range_Size2[, 2, drop = FALSE]
    rownames(Range_Size) <- Range_Size2[, 1]
  }
  
  # Return
  Range_Size <- as.matrix(Range_Size)
  colnames(Range_Size) <- 'Range_size'
  return(Range_Size)    
}


