#' Summarize metrics of the attribute-space PAM
#'
#' @title Descriptors of position, centrality, and isolation in attribute space
#'
#' @description
#' Computes a suite of descriptor variables for each cell of an
#' \emph{attribute-space} presence–absence matrix, as returned by
#' \code{\link{lets.attrpam}}. Attribute variables are treated as a
#' two-dimensional space, and the function
#' derives metrics that characterize: (i) the position of each attribute
#' cell relative to the attribute-space centroid (mean and
#' frequency-weighted distances), (ii) its proximity to attribute-space
#' borders (zero-richness frontier, quantified via multiple distance-based
#' proxies), and (iii) its isolation within attribute space
#' (frequency-weighted Euclidean distance to other cells).
#'
#' When a geographic presence–absence matrix is supplied, the function also
#' links each attribute cell to the geographic cells occupied by the taxa
#' occurring in that cell, allowing the calculation of: (iv) frequency in
#' geographic space, (v) total geographic area, and (vi) geographic
#' isolation statistics (summaries of pairwise distances among associated
#' geographic cells).
#'
#' @param x A list produced by \code{\link{lets.attrpam}} containing, at
#'   minimum:
#'   \itemize{
#'     \item \code{$PAM_attribute}: a data frame in which the first column
#'     is the attribute-cell identifier (\code{Cell_attr}), the second and
#'     third columns are the coordinates of the two attribute axes, and the
#'     remaining columns are taxa coded as presence (1) or absence (0).
#'     \item \code{$Attr_Richness_Raster}: a
#'     \link[terra]{SpatRaster} containing the richness of taxa in each
#'     attribute cell.
#'   }
#' @param y A geographic presence–absence object produced by
#'   \code{\link{lets.presab}}. If supplied, the function calculates the
#'   number of geographic cells associated with each attribute cell, the
#'   total area of those cells, and summary statistics of pairwise
#'   geographic distances among them. If \code{NULL}, these geographic
#'   descriptors are not calculated, and attribute-cell richness is used as
#'   the weighting variable for the attribute-space metrics.
#' @param perc Numeric value in the interval 0 to 1 indicating the
#'   proportion of the shortest distances to empty attribute cells to be
#'   averaged in the robust border-distance metric. Default is
#'   \code{0.1}.
#' @param remove.cells Logical. If \code{TRUE}, removes attribute cells that
#'   were not originally present in \code{x$PAM_attribute} and that were
#'   added internally to complete the raster support.
#'
#' @details
#' The two attribute variables are standardized to zero mean and unit variance
#' before distance-based calculations.
#'
#' If \code{y} is provided, the function first identifies the taxa present
#' in each attribute cell, then retrieves the geographic cells occupied by
#' those taxa in the geographic PAM. Based on these linked geographic
#' cells, the function computes:
#' \itemize{
#'   \item \code{Frequency}: number of associated geographic cells;
#'   \item \code{Area}: total area of the associated geographic cells;
#'   \item summary statistics of pairwise geographic distances among those
#'   cells.
#' }
#'
#' If \code{y = NULL}, geographic descriptors are not computed. In this
#' case, attribute-cell richness is used as the weighting variable in the
#' midpoint and frequency-weighted distance calculations.
#'
#' Empty attribute cells are defined as cells with zero frequency when
#' \code{y} is provided, or zero richness when \code{y = NULL}. Cells with
#' \code{NA} values in the richness raster are treated as empty.
#'
#' Distances to the weighted and unweighted midpoints are returned as
#' negative values so that larger values indicate greater centrality in
#' attribute space.
#'
#'
#' @return
#' A \code{data.frame} with one row per attribute cell. The output always
#' contains:
#' \itemize{
#'   \item \code{Cell_attr}: attribute-cell identifier.
#'   \item \code{Weighted Mean Distance to midpoint}: negative Euclidean
#'   distance from the cell to the weighted midpoint of occupied attribute
#'   space.
#'   \item \code{Mean Distance to midpoint}: negative Euclidean distance
#'   from the cell to the unweighted midpoint of occupied attribute space.
#'   \item \code{Minimum Zero Distance}: minimum distance from the cell to
#'   any empty attribute cell.
#'   \item \code{Minimum X\% Zero Distance}: mean distance from the cell to
#'   the nearest fraction of empty attribute cells defined by
#'   \code{perc}, where \code{X = perc * 100}.
#'   \item \code{Distance to MCP border}: distance from the cell to the
#'   border of the minimum convex polygon enclosing occupied attribute
#'   cells.
#'   \item \code{Frequency Weighted Distance}: weighted mean distance from
#'   the cell to all other attribute cells.
#' }
#'
#' When \code{y} is provided, the output additionally includes:
#' \itemize{
#'   \item \code{Frequency}: number of geographic cells associated with the
#'   taxa present in the attribute cell.
#'   \item \code{Area}: summed area of those associated geographic cells.
#'   \item \code{Isolation (Min.)}, \code{Isolation (1st Qu.)},
#'   \code{Isolation (Median)}, \code{Isolation (Mean)},
#'   \code{Isolation (3rd Qu.)}, and \code{Isolation (Max.)}: summary
#'   statistics of pairwise geographic distances among associated
#'   geographic cells.
#' }
#'
#' @examples
#' \dontrun{
#' # Example using a geographic PAM and simulated attribute data
#' data("PAM")
#'
#' n <- length(PAM$Species_name)
#' Species <- PAM$Species_name
#' trait_a <- rnorm(n)
#' trait_b <- trait_a * 0.2 + rnorm(n)
#' df <- data.frame(Species, trait_a, trait_b)
#'
#' # Build the attribute-space PAM
#' x <- lets.attrpam(df, n_bins = 4)
#'
#' # Calculate attribute-cell descriptors using the geographic PAM
#' cell_desc <- lets.attrcells(x, y = PAM)
#'
#' # Plot the resulting descriptors
#' lets.plot.attrcells(x, cell_desc)
#' }
#'
#' @import terra grDevices graphics
#' @export

lets.attrcells <- function(x, y = NULL, perc = 0.1,
                           remove.cells = FALSE) {
  
  
  # If a geographic PAM is supplied, link each attribute cell to the
  # geographic cells occupied by the taxa present in that attribute cell.
  if (!is.null(y)) {
    
    # Geographic species-by-cell matrix
    mat <- y$Presence_and_Absence_Matrix[, -(1:2), drop = FALSE]
    cells_sp <- apply(mat, 2, function(x) which(x == 1))
    mat2 <- x$PAM_attribute[, -1, drop = FALSE]
    sps_cells <- apply(mat2, 1, function(x) names(x)[(x == 1)])
    geo_cells <- lapply(sps_cells, function(spp_vec) {
      Reduce(union, cells_sp[spp_vec])
    })
    geo_xy <- lapply(geo_cells, function(x) {
      y$Presence_and_Absence_Matrix[x, 1:2]
    })
    
    # Number and total area of geographic cells associated with each
    # attribute cell
    Frequency <- sapply(geo_cells, length)
    vs <- terra::values(terra::cellSize(terra::unwrap(y$Richness_Raster)))[, 1]
    Area <- sapply(geo_cells, function(i) sum(vs[i]))
    
    # Summary statistics of pairwise geographic distances among cells
    # associated with each attribute cell
    n <- nrow(x$PAM_attribute)
    dists <- lapply(geo_xy, function(x) lets.distmat(matrix(x, ncol = 2)))
    sum_dists <- t(sapply(dists, summary))
    isolation <- ifelse(is.na(sum_dists), 0, sum_dists)
    iso_names <- c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max.")
    colnames(isolation) <- paste0("Isolation (", iso_names, ")")
    freq_iso <- as.data.frame(cbind(Frequency, Area, isolation))
    
    # Add attribute cells with no associated geographic cells and replace
    # missing values with zero so all raster cells are represented
    freq_iso$ID <- as.numeric(rownames(freq_iso))
    all_freq <- data.frame(ID = 1:terra::ncell(x$Attr_Richness_Raster))
    df_complete <- merge(all_freq, freq_iso, by = "ID", all.x = TRUE)[, -1]
    df_complete[is.na(df_complete)] <- 0
    Frequency <- df_complete$Frequency
  } else {
    # If no geographic PAM is supplied, use attribute-cell richness as the
    # weighting variable in attribute-space calculations
    Frequency_full <- values(x$Attr_Richness_Raster)[, 1]
    Frequency  <- ifelse(is.na(Frequency_full), 0, Frequency_full)
  }
  
  
  # Recover attribute-cell identifiers from the raster support
  attr_ids  <- x$PAM_attribute[, 1]
  ids_full <- 1:ncell(x$Attr_Richness_Raster)
  n_cells <- length(ids_full)
  if (n_cells > length(attr_ids)) {
    n_c <- ncol(x$PAM_attribute)
    pam_attr <- matrix(0, nrow = n_cells, ncol = n_c)
    pam_attr[, 1:3] <- cbind(ids_full, xyFromCell(x$Attr_Richness_Raster, ids_full))
    pam_attr[attr_ids, 4:n_c] <- x$PAM_attribute[, -(1:3)]
    x$PAM_attribute <- pam_attr
  }
  
  attr_cell  <- x$PAM_attribute[, 1]
  n <- length(attr_cell)
  
  
  
  # Standardize attribute coordinates before computing distances
  attr <- x$PAM_attribute[, 2:3, drop = FALSE]
  attr <- apply(attr, 2, base::scale)
  
  # Weighted and unweighted midpoints calculated from occupied cells only
  pam_mid <- cbind(attr, Frequency)
  pam_mid <- pam_mid[Frequency > 0, , drop = FALSE]
  
  mid_wm <- matrix(c(
    stats::weighted.mean(pam_mid[, 1], pam_mid[, 3]),
    stats::weighted.mean(pam_mid[, 2], pam_mid[, 3])
  ), ncol = 2)
  
  mid_m  <- matrix(c(mean(pam_mid[, 1]), mean(pam_mid[, 2])), ncol = 2)
  
  dist_all_env <- as.matrix(stats::dist(rbind(mid_wm, mid_m, attr)))
  mid_dist <- dist_all_env[-(1:2), 1:2, drop = FALSE]
  colnames(mid_dist) <- c("Weighted Mean Distance to midpoint",
                          "Mean Distance to midpoint")
  
  # Pairwise distances among all attribute cells
  dist_env <- dist_all_env[-(1:2), -(1:2), drop = FALSE]
  
  # Minimum distance from each cell to any empty attribute cell
  zero_idx <- which(Frequency == 0)
  if (length(zero_idx) > 0) {
    dist_bord  <- apply(dist_env[zero_idx, , drop = FALSE], 2, min)
  } else {
    dist_bord  <- rep(NA_real_, n)
  }
  
  # Robust border metric: mean distance to the nearest perc fraction of
  # empty attribute cells
  n_min <- function(x, n = NULL, perc) {
    if (is.null(n)) n <- ceiling(length(x) * perc)
    mean(sort(x)[seq_len(min(n, length(x)))])
  }
  if (length(zero_idx) > 0) {
    dist_bord2 <- apply(dist_env[zero_idx, , drop = FALSE], 2, n_min, perc = perc)
  } else {
    dist_bord2 <- rep(NA_real_, n)
  }
  
  # Distance from each cell to the border of the minimum convex polygon
  # enclosing occupied attribute cells
  attr2 <- x$PAM_attribute[Frequency > 0, 2:3, drop = FALSE]
  if (nrow(attr2) >= 3) {
    hp <- grDevices::chull(attr2)
    hp <- c(hp, hp[1])
    p  <- terra::vect(attr2[hp, ], type = "polygons")
    
    ext_df <- terra::extract(x$Attr_Richness_Raster, p, cells = TRUE)
    cell_col <- if ("cell" %in% names(ext_df)) "cell" else names(ext_df)[3]
    out_bord <- ext_df[[cell_col]]
    
    keep <- setdiff(seq_len(n), unique(out_bord))
    if (length(keep) > 0) {
      dist_bord3 <- apply(dist_env[keep, , drop = FALSE], 2, min)
    } else {
      dist_bord3 <- rep(NA_real_, n)
    }
  } else {
    dist_bord3 <- rep(NA_real_, n)
  }
  
  # Weighted mean distance from each attribute cell to all other cells
  weighted_mean_distances <- function(xmat, w) {
    n <- nrow(xmat)
    out <- numeric(n)
    for (i in seq_len(n)) {
      dists   <- sqrt(rowSums((t(t(xmat[-i, , drop = FALSE]) - xmat[i, ]))^2))
      weights <- w[-i]
      out[i]  <- sum(dists * weights) / sum(weights)
    }
    out
  }
  w_isol <- weighted_mean_distances(attr, Frequency)
  
  perc_label <- paste0("Minimum ", round(perc * 100), "% Zero Distance")
  
  # Assemble output; midpoint distances are multiplied by -1 so that
  # larger values indicate greater centrality
  if (!is.null(y)) {
    preds <- data.frame(
      "Cell_attr"                    = x$PAM_attribute[, 1],
      df_complete,
      as.data.frame(-mid_dist),
      "Minimum Zero Distance"        = dist_bord,
      setNames(list(dist_bord2), perc_label),
      "Distance to MCP border"       = dist_bord3,
      "Frequency Weighted Distance"  = w_isol,
      check.names = FALSE
    )
    
  } else {
    preds <- data.frame(
      "Cell_attr"                    = x$PAM_attribute[, 1],
      as.data.frame(-mid_dist),
      "Minimum Zero Distance"        = dist_bord,
      setNames(list(dist_bord2), perc_label),
      "Distance to MCP border"       = dist_bord3,
      "Frequency Weighted Distance"  = w_isol,
      check.names = FALSE
    )
    
  }
  
  # Optionally keep only the original attribute cells present in the
  # input PAM, excluding cells added internally to complete the raster
  if (remove.cells) {
    preds <- preds[attr_ids, ]
  }
  
  return(preds)
}

#' Plot attribute-cell descriptors as rasters
#'
#' @title Map AttrPAM descriptor layers
#' @description
#' Maps each descriptor column returned by \code{\link{lets.attrcells}} back
#' onto the attribute raster. Optionally returns the rasters without plotting.
#'
#' @param x A list returned by \code{\link{lets.attrpam}} (must contain
#'   \code{$Attr_Richness_Raster} and \code{$PAM_attribute}).
#' @param y A \code{data.frame} returned by \code{\link{lets.attrcells}}, with
#'   one row per attribute cell (aligned with \code{x}).
#' @param ras Logical; if \code{TRUE}, returns a named list of
#'   \link[terra]{SpatRaster} layers for each descriptor column (default \code{FALSE}).
#' @param plot_ras Logical; if \code{TRUE}, plots each raster (default \code{TRUE}).
#' @param col_func A custom color ramp palette function to use for plotting variables (e.g., from \code{colorRampPalette}).
#' @param mfrow A vector of the form c(nr, nc). The figures will be drawn in an
#'   nr-by-nc array on the device by rows as in par documentation.
#'   
#' @details
#' Rows with zero or \code{NA} richness are masked before plotting, to avoid
#' edge artifacts from empty attribute cells. The plotting grid defaults to
#' \code{par(mfrow = c(4, 4))}; adjust as needed.
#'
#' @return
#' If \code{ras = TRUE}, returns a named \code{list}
#' of \link[terra]{SpatRaster} layers (one per descriptor column).
#'
#' @examples
#' \dontrun{
#' # Example with simulated traits
#' data(PAM)
#' n <- length(PAM$Species_name)
#' Species <- PAM$Species_name
#' trait_a <- rnorm(n)
#' trait_b <- trait_a * 0.2 + rnorm(n)  # correlated trait
#' df <- data.frame(Species, trait_a, trait_b)
#'
#' # Build AttrPAM
#' x <- lets.attrpam(df, n_bins = 4)
#' 
#' # Compute descriptors
#' desc <- lets.attrcells(x, PAM)
#'
#' # Plot descriptors
#' lets.plot.attrcells(x, desc)
#' }
#'
#' @import terra graphics
#' @export
lets.plot.attrcells  <- function(x, y, 
                                 ras = FALSE, 
                                 plot_ras = TRUE,
                                 col_func = NULL,
                                 mfrow = c(4, 4)) {
  
  stopifnot(is.list(x),
            !is.null(x$Attr_Richness_Raster),
            is.data.frame(y),
            nrow(y) > 0)
  
  # Drop identifier column; keep descriptors only
  preds <- data.frame(y[, -1, drop = FALSE], check.names = FALSE)
  IDs <- y[, 1]
  
  # Mask rows with zero or NA richness (2nd column in `preds` is 'Richness')
  if (ncol(preds) >= 2L) {
    rich <- values(x$Attr_Richness_Raster)
    preds[rich == 0 | is.na(rich), ] <- NA
  }
  
  # Plotting grid (tweak as needed)
  if (isTRUE(plot_ras)) {
    graphics::par(mfrow = mfrow)
  }
  
  # Raster template from attribute richness
  r_template <- x$Attr_Richness_Raster
  ras_list <- vector("list", length = ncol(preds))
  
  if (is.null(col_func)) {
    # Colour ramp from colorbrewer (T. Lucas suggestion)
    colfunc <- grDevices::colorRampPalette(c("#edf8b1", "#7fcdbb", "#2c7fb8"))
  }
  n_col <- apply(preds, 2, function(x){length(table(x))})
  
  for (i in seq_len(ncol(preds))) {
    r <- r_template
    terra::values(r)[IDs] <- preds[, i]
    
    # Keep aspect ratio consistent with extent
    ext_vals  <- terra::ext(r)
    asp_ratio <- (ext_vals[2] - ext_vals[1]) / (ext_vals[4] - ext_vals[3])
    
    if (isTRUE(plot_ras)) {
      plot(r, main = colnames(preds)[i], asp = asp_ratio,
           col = colfunc(n_col[i]))
    }
    ras_list[[i]] <- r
  }
  
  if (isTRUE(ras)) {
    names(ras_list) <- colnames(preds)
    return(ras_list)
  }
  invisible(NULL)
}

