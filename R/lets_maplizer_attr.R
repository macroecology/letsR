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
#' lets.plot.attrpam(x)
#'
#' # Map species-level attribute (here, trait_b) by cell using the mean
#' res <- lets.maplizer.attr(x, y = trait_b, z = Species, func = mean)
#'
#' # Plot attribute raster
#' plot(res$Attr_Raster)
#' }
#'
#' @seealso \code{\link{lets.attrpam}}, \code{\link{lets.plot.attrpam}},
#'   \code{\link{lets.attrcells}}
#' @import terra stats
#' @export
lets.maplizer.attr <- function(x, y, z, func = mean,
                               ras = TRUE) {
  
  # Compute attribute summaries in attribute space (matrix + raster)
  temp_res_attr <- .map_attr(x, y, z, func)
  return(list(Matrix_attr = temp_res_attr[[1]], 
              Attr_Raster = temp_res_attr[[2]]))
}

# -------------------------------------------------------------------
# Auxiliary function: attribute-space summarization
# -------------------------------------------------------------------
.map_attr <- function(x, y, z, func = mean) {
  
  # Index bookkeeping for attribute matrix/raster layout
  k    <- 1        # index of PAM_attribute in list
  k_p  <- 1:3      # cols: Cell_attr + 2 attributes
  k_max <- 4       # col position for summary variable
  k_p2 <- 2:3      # cols used as XY coords for rasterize
  
  # Convert factor attributes to numeric if needed
  if (is.factor(y)) {
    y <- as.numeric(levels(y))[y]
  }
  
  # Tiny epsilon to avoid NA propagation when multiplying by zero
  y[y == 0] <- 1e-38
  
  # Extract species presence/absence matrix only (drop ID and traits)
  p <- x[[k]][, -(k_p)]
  
  # Multiply each species column by its attribute value; mark absences as NA
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
  
  # Cell-wise summary across species (ignoring NAs)
  func2 <- function(x) {
    pos <- is.na(x) 
    resu <- func(x[!pos])
  }
  resum <- apply(p, 1, func2)
  
  # Reset near-zero epsilons back to 0
  resum[resum <= 1e-38 & resum >= 0] <- 0
  
  # Build final result matrix
  resultado <- cbind(x[[k]][, k_p], resum)
  resu2 <- stats::na.omit(resultado)
  
  # Name summary column dynamically by function
  name <- paste("Variable", as.character(substitute(func)), sep = "_")
  colnames(resultado)[k_max] <- name 
  
  # Rasterize attribute values back to grid
  r <- terra::rasterize(resu2[, k_p2], 
                        x[[k + 1]], 
                        resu2[, k_max])
  
  return(list(Matrix = resultado, Raster = r))
}
