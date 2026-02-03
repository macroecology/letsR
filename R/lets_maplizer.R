#' Create a matrix summarizing species' attributes within 
#' cells of a PresenceAbsence object
#' 
#' @author Bruno Vilela
#' 
#' @description Summarize species atributes per cell in a presence-absence matrix.
#' 
#' @param x A \code{\link{PresenceAbsence}} object.
#' @param y Species attribute to be considered. It must be a numeric attribute.
#' @param z Species names in the same order as the attributes and exactly the 
#' same as named in the \code{PresenceAbsence} object.
#' @param func A function to summarize the species' atribute in each cell (the function must return only one value).
#' @param ras If \code{TRUE} the raster object will be returned 
#' together with the matrix.
#' @param weighted If TRUE, argument func is ignored, and weighted mean is
#'   calculated. Weights are attributed to each species according to 1/N cells
#'   that the species occur.
#' @return The result can be both a \code{matrix} or a \code{list} cointaining 
#' the follow objects:
#' @return \strong{Matrix}: a \code{matrix} object with the cells' geographic 
#' coordinates and the summarized species' attributes within them.
#' @return \strong{Raster}: The summarized species'attributed maped in a 
#' \code{SpatRaster} object.
#' 
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#' 
#' 
#' @examples \dontrun{
#' data(PAM)
#' data(IUCN)
#' trait <- IUCN$Description_Year
#' resu <- lets.maplizer(PAM, trait, PAM$S, ras = TRUE)
#' head(resu$Matrix)
#' plot(resu$Raster, xlab = "Longitude", ylab = "Latitude", 
#' main = "Mean description year per site")
#' 
#' }
#' 
#' @export

lets.maplizer <- function(x, y, z, func = mean, ras = FALSE, weighted = FALSE) {
  .map_all(x, y, z, func = mean, space = "geo", ras,
           weighted)
}

# Auxiliary func
.map_all <- function(x, y, z, func, space, ras,
                     weighted) {
  if (space == "geo") {
    if (methods::is(x, "PresenceAbsence")) {
      k = 1
      k2 = 0
      k_p = 1:2
      k_max = 3
      k_p2 = k_p
      x$Richness_Raster = terra::unwrap(x$Richness_Raster)
    } else {
      k = 2
      k2 = k
      k_p = 1:4
      k_max = 5
      k_p2 = 3:4
    }
  } 
  if (space == "env") {
    k = 1
    k2 = k
    k_p = 1:3
    k_max = 4
    k_p2 = 2:3
  } 
  if (space == "att") {
    k = 1
    k2 = 0
    k_p = 1:3
    k_max = 4
    k_p2 = 2:3
  }
  
  # Change factor to numbers
  if (is.factor(y)) {
    y <- as.numeric(levels(y))[y]
  }
  
  # To avoid being transformed in NA
  y[y == 0] <- 1e-38
  
  # Get the matrix without coordinates
  p <- x[[k]][, -(k_p)]
  
  for (i in 1:ncol(p)) {
    pos <- colnames(p)[i] == z
    if (sum(pos) > 0) {
      p[, i] <- p[, i] * y[pos]
      pos2 <- p[, i] == 0
      p[pos2, i] <- NA
    } else {
      p[, i] <- NA
    }
  }
  
  func2 <- function(x) {
    pos <- is.na(x) 
    resu <- func(x[!pos])
  }
  
  if (weighted) {
    ranges <- colSums(p, na.rm = TRUE) 
    w <- 1/ranges
    w <- ifelse(is.infinite(w), 0, w)
    n <- nrow(p)
    resum <- numeric()
    for (i in seq_len(n)) {
      p_temp <- p[i, ]
      resum[i] <- weighted.mean(p_temp, w, na.rm = TRUE)
    }
  } else {
    resum <- apply(p, 1, func2)
  }  
  # Back to zero
  resum[resum <= 1e-38 & resum >= 0] <- 0
  
  # Matrix of result 
  resultado <- cbind(x[[k]][, k_p], resum)
  resu2 <- stats::na.omit(resultado)
  
  # Name change
  name <- paste("Variable", as.character(substitute(func)),
                sep = "_")
  colnames(resultado)[k_max] <- name 
  
  
  # Return result with or without the raster
  if (ras) {
    r <- terra::rasterize(resu2[, k_p2], 
                          x[[k2 + 2]], 
                          resu2[, k_max])
    return(list(Matrix = resultado, Raster = r))
  } else {
    return(resultado)
  }
}
