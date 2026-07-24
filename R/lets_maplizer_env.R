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
#' @param weighted If TRUE, argument func is ignored, and weighted mean is
#'   calculated. Weights are attributed to each species according to 1/N cells that the species occur.
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
                              ras = TRUE, weighted = FALSE) {
  temp_res_geo <- .map_all(x, y, z, func,
           space = "geo", ras, weighted)
  temp_res_env <- .map_all(x, y, z, func,
           space = "env", ras, weighted)
  return(list(Matrix_env = temp_res_env[[1]], 
              Matrix_geo = temp_res_geo[[1]],
              Env_Raster = temp_res_env[[2]],
              Geo_Raster = temp_res_geo[[2]]))
  
}

