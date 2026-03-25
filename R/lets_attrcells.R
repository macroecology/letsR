#' Attribute-cell descriptors for an attribute-space PAM (AttrPAM)
#'
#' @title Descriptors of position and isolation in attribute space
#'
#' @description
#' Calculates descriptor variables for each cell of an attribute-space
#' presence–absence matrix (AttrPAM), as returned by
#' \code{\link{lets.attrpam}}. The two attribute axes are treated as a
#' two-dimensional coordinate system, and descriptors are computed to
#' summarize each cell's position in attribute space and its relation to
#' other occupied or empty cells.
#'
#' The function can also incorporate a geographic presence–absence matrix,
#' allowing attribute cells to be linked to the number and spatial
#' configuration of geographic cells associated with the taxa occurring in
#' each attribute cell.
#'
#' The descriptors include:
#' \itemize{
#'   \item \strong{Frequency}: when \code{y} is provided, the number of
#'   geographic cells associated with the taxa present in each attribute
#'   cell.
#'   \item \strong{Geographic isolation}: when \code{y} is provided,
#'   summaries of pairwise distances among the geographic cells associated
#'   with each attribute cell.
#'   \item \strong{Distance to midpoints}: distance from each attribute cell
#'   to the weighted and unweighted midpoints of occupied attribute space,
#'   computed in standardized attribute space. These values are returned as
#'   negative distances so that larger values indicate greater centrality.
#'   \item \strong{Border proximity}: minimum distance to any empty
#'   attribute cell, mean distance to the closest \code{perc} proportion of
#'   empty cells, and distance to the convex-hull border of occupied
#'   attribute space.
#'   \item \strong{Frequency-weighted distance}: weighted mean distance from
#'   each attribute cell to all other attribute cells in standardized
#'   attribute space.
#' }
#'
#' @param x A list produced by \code{\link{lets.attrpam}}, containing at
#' least:
#' \itemize{
#'   \item \code{$PAM_attribute}: a data frame in which the first column is
#'   \code{Cell_attr}, the second and third columns are the two attribute
#'   coordinates, and the remaining columns correspond to taxa coded as
#'   presence (1) or absence (0).
#'   \item \code{$Attr_Richness_Raster}: a \link[terra]{SpatRaster}
#'   containing the richness of taxa in each attribute cell.
#' }
#' @param y A geographic presence–absence object produced by
#'   \code{\link{lets.presab}}. If \code{NULL}, geographic frequency and
#'   geographic isolation metrics are not calculated, and attribute-cell
#'   richness is used as the weighting variable in attribute-space
#'   calculations.
#' @param perc Numeric value in the interval \eqn{(0, 1]} indicating the
#'   proportion of the shortest distances to empty cells to be used in the
#'   robust border-distance metric. Default is \code{0.2}.
#' @param remove.cells Logical. If \code{TRUE}, removes attribute cells that
#'   were absent from \code{x$PAM_attribute} and were added internally to
#'   complete the raster structure.
#'
#' @details
#' The two attribute variables (columns 2 and 3 of \code{x$PAM_attribute})
#' are standardized to zero mean and unit variance before distance
#' calculations.
#'
#' If \code{y} is provided, the function first links taxa occurring in each
#' attribute cell to their occupied geographic cells, and then computes:
#' \itemize{
#'   \item the number of geographic cells associated with each attribute
#'   cell (\code{Frequency});
#'   \item summary statistics of pairwise geographic distances among those
#'   cells.
#' }
#'
#' If \code{y = NULL}, no geographic summaries are produced. In that case,
#' the richness of each attribute cell, extracted from
#' \code{x$Attr_Richness_Raster}, is used as the weight for midpoint and
#' isolation calculations in attribute space.
#'
#' Empty attribute cells are identified as cells with zero frequency
#' (or zero richness when \code{y = NULL}). Cells with \code{NA} values in
#' the richness raster are treated as empty for these calculations.
#'
#' Distance to the midpoint is reported as a negative value by design, so
#' that larger values correspond to cells located closer to the center of
#' attribute space.
#'
#' @return
#' A \code{data.frame} with one row per attribute cell. The output always
#' includes:
#' \itemize{
#'   \item \code{Cell_attr}: attribute-cell identifier.
#'   \item \code{Weighted Mean Distance to midpoint}: negative distance to
#'   the richness- or frequency-weighted midpoint.
#'   \item \code{Mean Distance to midpoint}: negative distance to the
#'   unweighted midpoint.
#'   \item \code{Minimum Zero Distance}: minimum distance to an empty
#'   attribute cell.
#'   \item \code{Minimum 10\% Zero Distance}: mean distance to the nearest
#'   \code{perc} proportion of empty attribute cells.
#'   \item \code{Distance to MCP border}: distance to the convex-hull border
#'   of occupied attribute space.
#'   \item \code{Frequency Weighted Distance}: weighted mean distance to all
#'   other attribute cells.
#' }
#'
#' When \code{y} is provided, the output additionally includes:
#' \itemize{
#'   \item \code{Frequency}: number of geographic cells associated with the
#'   taxa in each attribute cell.
#'   \item \code{Isolation (Min.)}, \code{Isolation (1st Qu.)},
#'   \code{Isolation (Median)}, \code{Isolation (Mean)},
#'   \code{Isolation (3rd Qu.)}, \code{Isolation (Max.)}: summary
#'   statistics of pairwise geographic distances among associated
#'   geographic cells.
#' }
#'
#' @examples
#' \dontrun{
#' # Example using a geographic PAM and simulated attributes
#' data("PAM")
#'
#' n <- length(PAM$Species_name)
#' Species <- PAM$Species_name
#' trait_a <- rnorm(n)
#' trait_b <- trait_a * 0.2 + rnorm(n)  # correlated trait
#' df <- data.frame(Species, trait_a, trait_b)
#'
#' # Build the attribute-space PAM
#' x <- lets.attrpam(df, n_bins = 4)
#'
#' # Use the geographic PAM to calculate frequency and geographic isolation
#' y <- PAM
#'
#' # Calculate attribute-cell descriptors
#' cell_desc <- lets.attrcells(x, y)
#'
#' # Plot descriptors
#' lets.plot.attrcells(x, cell_desc)
#' }
#'
#' @import terra grDevices graphics
#' @export
lets.attrcells <- function(x, y = NULL, perc = 0.2, 
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
    
    # Number of geographic cells associated with each attribute cell
    Frequency <- sapply(geo_cells, length)
    
    # Summaries of pairwise geographic distances among cells associated
    # with each attribute cell
    n <- nrow(x$PAM_attribute)
    dists <- lapply(geo_xy, function(x) lets.distmat(matrix(x, ncol = 2)))
    sum_dists <- t(sapply(dists, summary))
    isolation <- ifelse(is.na(sum_dists), 0, sum_dists)
    iso_names <- c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max.")
    colnames(isolation) <- paste0("Isolation (", iso_names, ")")
    freq_iso <- as.data.frame(cbind(Frequency, isolation))
    
    # Add attribute cells with no associated geographic cells and fill
    # missing values with zero
    freq_iso$ID <- as.numeric(rownames(freq_iso))
    all_freq <- data.frame(ID = 1:terra::ncell(x$Attr_Richness_Raster))
    df_complete <- merge(all_freq, freq_iso, by = "ID", all.x = TRUE)[, -1]
    df_complete[is.na(df_complete)] <- 0
    Frequency <- df_complete$Frequency 
  } else {
    # If no geographic PAM is supplied, use attribute-cell richness as the
    # weighting variable for attribute-space calculations
    Frequency_full <- values(x$Attr_Richness_Raster)[, 1]
    Frequency  <- ifelse(is.na(Frequency_full), 0, Frequency_full)
  }
  
  
  # Attribute-cell identifiers from the raster support
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
  
  # Weighted and unweighted midpoints, calculated using occupied cells only
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
  
  # Pairwise distances among attribute cells
  dist_env <- dist_all_env[-(1:2), -(1:2), drop = FALSE]
  
  # Minimum distance from each cell to any empty attribute cell
  zero_idx <- which(Frequency == 0)
  if (length(zero_idx) > 0) {
    dist_bord  <- apply(dist_env[zero_idx, , drop = FALSE], 2, min)
  } else {
    dist_bord  <- rep(NA_real_, n)
  }
  
  # Robust border metric: mean distance to the closest perc fraction of
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
  
  # Distance from each cell to the convex-hull border of occupied
  # attribute space
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
  
  # Assemble output; midpoint distances are multiplied by -1 so that
  # larger values indicate greater centrality
  if (!is.null(y)) {
    preds <- data.frame(
      "Cell_attr"                    = x$PAM_attribute[, 1],
      df_complete,
      as.data.frame(-mid_dist),
      "Minimum Zero Distance"        = dist_bord,
      "Minimum 10% Zero Distance"    = dist_bord2,
      "Distance to MCP border"       = dist_bord3,
      "Frequency Weighted Distance"  = w_isol,
      check.names = FALSE
    )
    
  } else {
    preds <- data.frame(
      "Cell_attr"                    = x$PAM_attribute[, 1],
      as.data.frame(-mid_dist),
      "Minimum Zero Distance"        = dist_bord,
      "Minimum 10% Zero Distance"    = dist_bord2,
      "Distance to MCP border"       = dist_bord3,
      "Frequency Weighted Distance"  = w_isol,
      check.names = FALSE
    )
    
  }
  
  # Optionally keep only the original non-empty cells from PAM_attribute
  if (remove.cells) {
    preds <- preds[attr_ids, ]
  }
  
  return(preds)
}

#' Plot attribute-cell descriptors as rasters
#'
#' @title Map AttrPAM descriptor layers
#' @description
#' Maps each descriptor column returned by \code{\link{lets.attrcells}}
#' back onto the attribute raster template (\code{x$Attr_Richness_Raster}).
#' Optionally returns the rasters without plotting.
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
#' \code{par(mfrow = c(4, 2))}; adjust as needed.
#'
#' @return
#' Invisibly returns \code{NULL}. If \code{ras = TRUE}, returns a named \code{list}
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

