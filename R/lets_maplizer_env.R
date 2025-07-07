#' Map species attributes in both environmental and geographic spaces
#'
#'@author Bruno Vilela
#'
#'@description
#'Summarize species-level attributes (e.g., traits or conservation data) within each cell of environmental and geographic presence–absence matrices, enabling trait-based mapping across environmental gradients and geographic space.
#'
#'@param x An object produced by \code{\link{lets.envpam}}.
#'@param y A numeric vector containing the species attributes to be summarized (e.g., description year, body size).
#'@param z A character vector with species names corresponding to the values in \code{y}. These names must match the species columns in the presence-absence matrices in `x`. 
#'@param func A function used to summarize the attribute across species in each cell (e.g., \code{mean}, \code{median}, \code{sum}). Must return a single numeric value.
#'@param ras Logical. If \code{TRUE}, the result includes the attribute maps as \code{SpatRaster} objects.
#'
#'@return A list with the following elements:
#'\itemize{
#'  \item \code{Matrix_env}: A matrix with summarized attribute values in environmental space.
#'  \item \code{Matrix_geo}: A matrix with summarized attribute values in geographic space.
#'  \item \code{Env_Raster}: A \code{SpatRaster} with the attribute values mapped in environmental space.
#'  \item \code{Geo_Raster}: A \code{SpatRaster} with the attribute values mapped in geographic space.
#'}
#'
#'@details
#'This function is useful for trait-based macroecological analyses that aim to
#'understand how species attributes vary across environments or space. It uses
#'the output of \code{\link{lets.envpam}}, applies a summary function to the
#'trait values of all species present in each cell, and returns raster layers
#'for visualization.
#'
#'@seealso \code{\link{lets.envpam}}, \code{\link{lets.maplizer}}, \code{\link{lets.plot.envpam}}
#'
#'@examples \dontrun{
#' # Load data
#' data("Phyllomedusa")
#' data("prec")
#' data("temp")
#' data("IUCN")
#'
#' prec <- unwrap(prec)
#' temp <- unwrap(temp)
#' PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
#' envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
#' colnames(envs) <- c("Temperature", "Preciptation")
#' wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
#' PAM <- lets.pamcrop(PAM, vect(wrld_simpl))
#'
#' # Create environmental PAM
#' res <- lets.envpam(PAM, envs, remove.cells = FALSE)
#'
#' # Map mean description year
#' res_map <- lets.maplizer.env(res, 
#'                              y = IUCN$Description_Year,
#'                              z = IUCN$Species)
#'
#' # Plotting trait maps
#' lets.plot.envpam(res_map)
#'}
#'
#'@export
#'@import terra


lets.maplizer.env <- function(x, y, z, func = mean,
                              ras = TRUE) {
  temp_res_geo <- .map_env(x, y, z, func,
           space = "geo")
  temp_res_env <- .map_env(x, y, z, func,
           space = "env")
  return(list(Matrix_env = temp_res_env[[1]], 
              Matrix_geo = temp_res_geo[[1]],
              Env_Raster = temp_res_env[[2]],
              Geo_Raster = temp_res_geo[[2]]))
  
}

# Auxiliary func
.map_env <- function(x, y, z, func = mean, space = "geo") {
  if (space == "geo") {
    k = 2
    k_p = 1:4
    k_max = 5
    k_p2 = 3:4
  } 
  if (space == "env") {
    k = 1
    k_p = 1:3
    k_max = 4
    k_p2 = 2:3
  } 
  
  # Change factor to numbers
  if (is.factor(y)) {
    y <- as.numeric(levels(y))[y]
  }
  
  # To avoid being transformed in NA
  y[y == 0] <- 0.00000000000000000000000000000000000001
  
  # Get the matrix without coordinates
  p <- x[[k]][, -(k_p)]
  
  for(i in 1:ncol(p)) {
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
  
  resum <- apply(p, 1, func2)
  
  
  # Back to zero
  resum[resum <= 0.0000000000000000000000000000000000001] <- 0
  
  # Matrix of result 
  resultado <- cbind(x[[k]][, k_p], resum)
  resu2 <- stats::na.omit(resultado)
  
  # Name change
  name <- paste("Variable", as.character(substitute(func)),
                sep = "_")
  colnames(resultado)[k_max] <- name 
  
  
  # Return result with or without the raster
    r <- terra::rasterize(resu2[, k_p2], 
                          x[[k + 2]], 
                          resu2[, k_max])
    return(list(Matrix = resultado, Raster = r))
}
