#' Map species attributes in attribute space (based on AttrPAM)
#'
#' @title Map species-level attributes over the attribute-space grid
#'
#' @author Bruno Vilela
#'
#' @description
#' Summarizes species attributes (e.g., trait values, description year) within
#' each **attribute-space** cell of a presence–absence matrix produced by
#' \code{\link{lets.attrpam}}. A summary function (\code{func}) is applied across
#' the attributes of species present in each cell, producing a per-cell attribute
#' surface and an optional raster for visualization.
#'
#' @param x An object returned by \code{\link{lets.attrpam}}, containing the
#'   attribute-space PAM (matrix) and its raster.
#' @param y A numeric vector with species attributes to summarize (one value per
#'   species in \code{z}). If \code{y} is a factor, it is coerced to numeric by
#'   level codes.
#' @param z A character vector of species names corresponding to \code{y}. These
#'   names must match the species columns in the attribute-space PAM within \code{x}.
#' @param func A function to summarize attributes across species within each cell
#'   (e.g., \code{mean}, \code{median}, \code{sum}). Must return a single numeric value.
#' @param ras Logical; if \code{TRUE}, include the attribute map as a
#'   \link[terra]{SpatRaster} in the output.
#' @param weighted If TRUE, argument func is ignored, and weighted mean is
#'   calculated. Weights are attributed to each species according to 1/N cells
#'   that the species occur.
#'
#' @return A \code{list} with:
#' \itemize{
#'   \item \code{Matrix_attr}: matrix/data.frame with summarized attribute values
#'         per attribute cell (first columns are the cell ID and the two attribute axes).
#'   \item \code{Attr_Raster}: \link[terra]{SpatRaster} with the summarized attribute
#'         mapped in attribute space.
#' }
#'
#' @details
#' Internally, the function multiplies each species presence column by its attribute
#' value in \code{y} (matched by name via \code{z}), sets zeros to \code{NA} so that
#' summary functions ignore absences, applies \code{func} across species for each cell,
#' and rasterizes the resulting per-cell summaries onto the attribute raster template.
#' Cells with no species remain as \code{NA}.
#'
#' @examples
#' \dontrun{
#' # Simulate a dataset of 2000 species with two traits
#' n <- 2000
#' Species <- paste0("sp", 1:n)
#' trait_a <- rnorm(n)
#' trait_b <- trait_a * 0.2 + rnorm(n)
#' df <- data.frame(Species, trait_a, trait_b)
#'
#' # Build attribute-space PAM
#' x <- lets.attrpam(df, n_bins = 30)
#'
#' # Map species-level attribute (here, trait_b) by cell using the mean
#' res <- lets.maplizer.attr(x, y = trait_b, z = Species)
#'
#' # Plot attribute raster
#' lets.plot.attrpam(res)
#' }
#'
#' @seealso \code{\link{lets.attrpam}}, \code{\link{lets.plot.attrpam}},
#'   \code{\link{lets.attrcells}}
#' @import terra stats
#' @export
lets.maplizer.attr <- function(x, y, z, func = mean,
                               ras = TRUE, weighted = FALSE) {
  
  # Compute attribute summaries in attribute space (matrix + raster)
  temp_res_attr <- .map_all(x, y, z, func, "att", ras, weighted)
  return(list(Matrix_attr = temp_res_attr[[1]], 
              Attr_Raster = temp_res_attr[[2]]))
}
