#' Create a Presence–Absence Matrix in Trait Space
#'
#' @title Attribute-space Presence–Absence Matrix (attrPAM)
#' @description
#' Builds a presence–absence matrix (PAM) in a two-dimensional **trait space**,
#' by binning species occurrences along two quantitative attributes (e.g., body size and mass).
#' Each species can have one or multiple entries in the trait dataset.
#'
#' @param x A data frame where the first column contains species (character vector),
#'          and the next two columns contain numeric trait values (2D space).
#' @param n_bins Integer. Number of bins per axis (default = 10).
#' @param remove.cells Logical. If `TRUE`, remove empty cells from the PAM (default).
#' @param remove.sp Logical. If `TRUE`, remove species absent from all cells (default).
#' @param count Logical. If `TRUE`, display a text progress bar while building the PAM.
#'
#' @details
#' The two trait axes are divided into equal-interval bins, generating a grid of
#' `n_bins × n_bins` cells. Each species occurrence is assigned to a cell, and
#' the resulting PAM indicates which species are present in each trait cell.
#'
#' @return A list with two components:
#' \itemize{
#'   \item \code{PAM_attribute}: a matrix with cell ID, trait coordinates, and species presence (0/1).
#'   \item \code{Attr_Richness_Raster}: a raster of richness (number of species) in trait space.
#' }
#'
#' @examples
#' \dontrun{
#' # n <- 2000
# Species <- paste0("sp", 1:n)
# trait_a <- rnorm(n)
# trait_b <- trait_a * .2 + rnorm(n)
# x <- data.frame(Species, trait_a, trait_b)
# test <- lets.attrpam(x, n_bins = 30)
# lets.plot.attrpam(test)
#' }
#' 
#' @import terra
#' @export
lets.attrpam <- function(x,
                         n_bins = 10,
                         remove.cells = TRUE,
                         remove.sp = TRUE,
                         count = FALSE) {
  
  ## --- Input checks ---------------------------------------------------------
  if (!is.character(x[, 1])) {
    stop("The first column must be a character vector with species names.")
  }
  taxa_raw <- x[, 1]
  taxa     <- unique(taxa_raw)
  
  # Extract trait matrix (2D)
  x <- as.matrix(x[, 2:3])
  
  # Handle missing values
  keep <- !(is.na(x[, 1]) | is.na(x[, 2]))
  if (any(!keep)) {
    warning("Some species entries had NA values and were excluded.")
    x    <- x[keep, ]
    taxa <- taxa[keep]
  }
  
  ## --- Build 2D grid --------------------------------------------------------
  # Ranges of trait axes
  x_range <- range(x[, 1], na.rm = TRUE)
  y_range <- range(x[, 2], na.rm = TRUE)
  
  # Bin edges
  x_breaks <- seq(x_range[1], x_range[2], length.out = n_bins + 1)
  y_breaks <- seq(y_range[1], y_range[2], length.out = n_bins + 1)
  
  # Assign each observation to bins
  x_bin <- cut(x[, 1], breaks = x_breaks, include.lowest = TRUE)
  y_bin <- cut(x[, 2], breaks = y_breaks, include.lowest = TRUE)
  
  # Frequency table of occurrences per cell
  freq_table  <- table(x_bin, y_bin)
  freq_matrix <- matrix(as.numeric(freq_table), nrow = n_bins, ncol = n_bins)
  freq_matrix[freq_matrix == 0] <- NA
  
  # Flip y-axis for correct orientation
  freq_matrix <- t(freq_matrix[, ncol(freq_matrix):1])
  
  # Build raster
  ras <- terra::rast(freq_matrix)
  terra::ext(ras) <- c(min(x_breaks), max(x_breaks),
                       min(y_breaks), max(y_breaks))
  
  ## --- Build species × cell matrix ------------------------------------------
  n_cells <- length(terra::values(ras))
  coord   <- terra::xyFromCell(ras, 1:n_cells)
  colnames(coord) <- colnames(x)
  
  # Identify cell membership for each occurrence
  cell_ids <- terra::extract(ras, x, cells = TRUE)[, 1]
  
  # Empty species × cell matrix
  n <- length(taxa)
  pam_matrix <- matrix(0, nrow = n_cells, ncol = n)
  colnames(pam_matrix) <- taxa
  
  if (count) {
    pb <- utils::txtProgressBar(min = 0, max = n, style = 3)
  }
  
  for (i in seq_len(n)) {
    pam_matrix[cell_ids[taxa[i] == taxa_raw], i] <- 1
    if (count) utils::setTxtProgressBar(pb, i)
  }
  
  if (count) close(pb)
  
  ## --- Clean-up and richness raster -----------------------------------------
  Result <- cbind("Cell_attr" = 1:n_cells, coord, pam_matrix)
  if (remove.cells) Result <- .removeCells(Result)
  if (remove.sp)    Result <- .removeSp(Result)
  
  # Richness raster
  ras_rich <- ras
  richness <- rowSums(pam_matrix)
  terra::values(ras_rich) <- ifelse(richness == 0, NA, richness)
  
  # Distinguish true zeros from NAs
  pos_0 <- which(is.na(terra::values(ras_rich)) & !is.na(terra::values(ras)))
  terra::values(ras_rich)[pos_0] <- 0
  
  ## --- Output ---------------------------------------------------------------
  list("PAM_attribute"        = Result,
       "Attr_Richness_Raster" = ras_rich)
}
