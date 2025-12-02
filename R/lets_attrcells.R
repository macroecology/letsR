#' Attribute-cell descriptors for an attribute-space PAM (AttrPAM)
#'
#' @title Descriptors of centrality, border proximity, and isolation in attribute space
#' @description
#' Computes per-cell descriptors for an attribute-space presence–absence matrix
#' (as returned by \code{\link{lets.attrpam}}), using the two numeric attributes
#' as a 2D coordinate system. The descriptors include:
#' \itemize{
#'   \item \strong{Richness}: number of taxa in each attribute cell (from the richness raster).
#'   \item \strong{Distances to attribute midpoints}: distance to the weighted midpoint
#'         (weights = richness) and to the unweighted midpoint, both computed in standardized
#'         attribute space; returned as \emph{negated} values so that larger numbers indicate
#'         greater centrality.
#'   \item \strong{Border proximity}: three proxies — minimum distance to any zero-richness cell;
#'         robust mean of the closest \code{perc} fraction of zero-richness distances; and
#'         minimum distance to the convex-hull (MCP) border of occupied attribute cells.
#'   \item \strong{Attribute isolation}: richness-weighted mean distance from each cell
#'         to all other cells in standardized attribute space.
#' }
#'
#' @param x A list produced by \code{\link{lets.attrpam}} containing:
#'   \itemize{
#'     \item \code{$PAM_attribute}: data.frame with columns \code{Cell_attr} (first),
#'           the two attribute coordinates (second and third), followed by taxa columns (0/1).
#'     \item \code{$Attr_Richness_Raster}: \link[terra]{SpatRaster} with richness per attribute cell.
#'   }
#' @param perc Numeric in (0, 1]; fraction used in the robust border metric
#'   (mean of the \emph{n} smallest zero-richness distances). Default \code{0.2}.
#'
#' @details
#' Attributes (columns 2–3 of \code{$PAM_attribute}) are standardized (z-scores)
#' prior to distance calculations. Cells with \code{NA} richness are treated as zero
#' when identifying zero-richness neighbors, and later masked in plotting.
#'
#' @return A \code{data.frame} with one row per attribute cell and the columns:
#' \itemize{
#'   \item \code{Cell_attr}: attribute cell identifier (1..n).
#'   \item \code{Richness}: taxa count for the cell (from \code{$Attr_Richness_Raster}).
#'   \item \code{Weighted Mean Distance to midpoint}, \code{Mean Distance to midpoint}:
#'         negated distances (larger = more central) in standardized attribute space.
#'   \item \code{Minimum Zero Distance}, \code{Minimum 10\% Zero Distance},
#'         \code{Distance to MCP border}: border proximity proxies.
#'   \item \code{Frequency Weighted Distance}: richness-weighted mean distance to all other cells.
#' }
#'
#' @examples
#' \dontrun{
#' # Example with simulated traits
#' n <- 2000
#' Species <- paste0("sp", 1:n)
#' trait_a <- rnorm(n)
#' trait_b <- trait_a * 0.2 + rnorm(n)  # correlated trait
#' df <- data.frame(Species, trait_a, trait_b)
#'
#' # Build AttrPAM
#' x <- lets.attrpam(df, n_bins = 30)
#' 
#' # Compute descriptors
#' y <- lets.attrcells(x)
#'
#' # Plot descriptors
#' lets.plot.attrcells(x, y)
#' }
#'
#' @import terra grDevices graphics  
#' @export
lets.attrcells <- function(x, perc = 0.2) {
  
  # Attribute-cell IDs from raster (first layer)
  attr_cell  <- x$Attr_Richness_Raster[, 1]
  n <- length(attr_cell)
  
  # Richness per attribute cell (NA -> 0)
  Frequency_full <- values(x$Attr_Richness_Raster)[, 1]
  Frequency_full <- ifelse(is.na(Frequency_full), 0, Frequency_full)
  
  cells_pam <- x$PAM_attribute[, 1]
  Frequency <- Frequency_full[cells_pam]
  
  
  # --- Distances to midpoints (attributes standardized) ---
  attr <- x$PAM_attribute[, 2:3, drop = FALSE]
  attr <- apply(attr, 2, base::scale)
  
  # Weighted and unweighted midpoints based on occupied cells
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
  
  # --- Distances to border proxies ---
  dist_env <- dist_all_env[-(1:2), -(1:2), drop = FALSE]
  
  # (4a) Min distance to any zero-richness cell
  zero_idx <- which(Frequency == 0)
  if (length(zero_idx) > 0) {
    dist_bord  <- apply(dist_env[zero_idx, , drop = FALSE], 2, min)
  } else {
    dist_bord  <- rep(NA_real_, n)
  }
  
  # (4b) Robust border distance (mean of closest perc% zero distances)
  n_min <- function(x, n = NULL, perc) {
    if (is.null(n)) n <- ceiling(length(x) * perc)
    mean(sort(x)[seq_len(min(n, length(x)))])
  }
  if (length(zero_idx) > 0) {
    dist_bord2 <- apply(dist_env[zero_idx, , drop = FALSE], 2, n_min, perc = perc)
  } else {
    dist_bord2 <- rep(NA_real_, n)
  }
  
  # (4c) Min distance to convex hull border (MCP) of occupied cells
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
  
  # --- Attribute isolation (weighted mean distance to others) ---
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
  
  # --- Assemble results (midpoint distances are negated by design) ---
  preds <- data.frame(
    "Cell_attr"                    = x$PAM_attribute[, 1],
    "Richness"                     = Frequency,
    as.data.frame(-mid_dist),
    "Minimum Zero Distance"        = dist_bord,
    "Minimum 10% Zero Distance"    = dist_bord2,
    "Distance to MCP border"       = dist_bord3,
    "Frequency Weighted Distance"  = w_isol,
    check.names = FALSE
  )
  preds
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
#' n <- 2000
#' Species <- paste0("sp", 1:n)
#' trait_a <- rnorm(n)
#' trait_b <- trait_a * 0.2 + rnorm(n)  # correlated trait
#' df <- data.frame(Species, trait_a, trait_b)
#'
#' # Build AttrPAM
#' x <- lets.attrpam(df, n_bins = 30)
#' 
#' # Compute descriptors
#' y <- lets.attrcells(x)
#'
#' # Plot descriptors
#' lets.plot.attrcells(x, y)
#' }
#'
#' @import terra graphics
#' @export
lets.plot.attrcells <- function(x, y, 
                                ras = FALSE, 
                                plot_ras = TRUE,
                                col_func = NULL) {
  
  stopifnot(is.list(x),
            !is.null(x$Attr_Richness_Raster),
            is.data.frame(y),
            nrow(y) > 0)
  
  # Drop identifier column; keep descriptors only
  preds <- data.frame(y[, -1, drop = FALSE], check.names = FALSE)
  
  # Mask rows with zero or NA richness (2nd column in `preds` is 'Richness')
  if (ncol(preds) >= 2L) {
    preds[preds[, 1L] == 0 | is.na(preds[, 1L]), ] <- NA
  }
  
  # Plotting grid (tweak as needed)
  if (isTRUE(plot_ras)) {
    graphics::par(mfrow = c(3, 2))
  }
  
  # Raster template from attribute richness
  r_template <- x$Attr_Richness_Raster
  preds <- preds[, -1]
  ras_list <- vector("list", length = ncol(preds))
  
  if (is.null(col_func)) {
    # Colour ramp from colorbrewer (T. Lucas suggestion)
    colfunc <- grDevices::colorRampPalette(c("#edf8b1", "#7fcdbb", "#2c7fb8"))
  }
  n_col <- apply(preds, 2, function(x){length(table(x))})
  
  for (i in seq_len(ncol(preds))) {
    r <- r_template
    terra::values(r) <- preds[, i]
    
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
