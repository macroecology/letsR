#' Summarize environmental–geographical metrics from an envPAM object
#'
#' @title Environmental descriptors for Presence–Absence in environmental space
#' @description
#' Computes a suite of descriptors for each environmental cell in an
#' \emph{environmental} presence–absence matrix (envPAM), including:
#' (i) frequency in geographic space, (ii) geographic isolation statistics
#' (summary of pairwise distances among geographic cells mapped to the same
#' environmental cell), (iii) distance to environmental midpoints (mean and
#' frequency-weighted mean), (iv) distance to environmental “border” (zero-richness
#' frontier via three proxies), and (v) an environmental isolation metric based on
#' frequency-weighted Euclidean distance in standardized environmental space.
#'
#' Distances to midpoints are returned **negated** (i.e., larger values imply
#' greater centrality in environmental space), following the current implementation.
#'
#' @param x A list returned by \code{\link{lets.envpam}} containing at least:
#' \itemize{
#'   \item \code{$Presence_and_Absence_Matrix_env}: data.frame with columns
#'         \code{cell_id_env}, the environmental coordinates (e.g., two variables),
#'         and species presences (one column per species).
#'   \item \code{$Presence_and_Absence_Matrix_geo}: data.frame with columns
#'         \code{cell_id_geo}, geographic coordinates (lon, lat), and species presences.
#'   \item \code{$Env_Richness_Raster}: a \pkg{terra} SpatRaster of richness in environmental space.
#' }
#' @param perc Numeric in (0,1], the fraction used in the robust border metric
#' (mean of the \emph{n} smallest distances to zero-richness cells). Default = 0.2.
#'
#' @details
#' Environmental variables (assumed to be the 2nd and 3rd columns of
#' \code{$Presence_and_Absence_Matrix_env}) are z-scored before computing distances.
#' Geographic isolation is summarized with \code{summary()} of pairwise distances
#' among geographic cells that collapse to the same environmental cell.
#'
#' @return
#' A data frame with one row per environmental cell and the following columns:
#' \itemize{
#'   \item \code{Cell_env}: Environmental cell identifier.
#'   \item \code{Frequency}: Number of geographic cells mapped to the environmental cell.
#'   \item \code{Isolation (Min.)}, \code{Isolation (1st Qu.)}, \code{Isolation (Median)},
#'         \code{Isolation (Mean)}, \code{Isolation (3rd Qu.)}, \code{Isolation (Max.)}:
#'         Summary of pairwise geographic distances.
#'   \item \code{Weighted Mean Distance to midpoint}, \code{Mean Distance to midpoint}:
#'         Negated distances in standardized environmental space (larger values = more central).
#'   \item \code{Minimum Zero Distance}, \code{Minimum 10\% Zero Distance}, \code{Distance to MCP border}:
#'         Three proxies for border proximity.
#'   \item \code{Frequency Weighted Distance}: Frequency-weighted mean distance to all other env cells.
#' }
#'
#' @section Caveats:
#' (1) The code assumes the first column of \code{$Presence_and_Absence_Matrix_env}
#' indexes environmental cells and columns 2–3 are the two environmental variables.
#' (2) The geographic matrix assumes lon/lat at columns 3–4. Adjust indices if needed.
#' (3) If there are no zero-richness cells or < 3 occupied env cells, border metrics
#' are returned as \code{NA}.
#'
#' @seealso \code{\link{lets.envpam}}, \code{\link{lets.plot.envcells}}, \code{\link{lets.plot.envpam}}
#'
#' @examples
#' \dontrun{
#' data("Phyllomedusa"); data("prec"); data("temp")
#' prec <- unwrap(prec); temp <- unwrap(temp)
#' PAM  <- lets.presab(Phyllomedusa, remove.cells = FALSE)
#' envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
#' colnames(envs) <- c("Temperature", "Precipitation")
#' wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
#' PAM <- lets.pamcrop(PAM, terra::vect(wrld_simpl))
#' res <- lets.envpam(PAM, envs, n_bins = 30)
#' out <- lets.envcells(res, perc = 0.2)
#' lets.plot.envcells(res, out)
#' }
#'
#' @import terra grDevices
#' @export
lets.envcells <- function(x, perc = 0.2) {
  
  # --- IDs and alignment ---
  env_cell  <- x$Presence_and_Absence_Matrix_env[, 1]
  cell_fact <- factor(x$Presence_and_Absence_Matrix_geo[, 1], levels = env_cell)
  n <- length(env_cell)
  
  # --- Metric 1: Frequency (geographic count per environmental cell) ---
  Frequency <- as.numeric(base::table(cell_fact))
  
  # --- Metric 2: Geographic isolation (summary of pairwise distances) ---
  # Initialize with NA; safer if groups with singletons or none exist
  iso_names <- c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max.")
  isolation <- matrix(NA_real_, nrow = n, ncol = length(iso_names))
  colnames(isolation) <- paste0("Isolation (", iso_names, ")")
  
  for (i in seq_len(n)) {
    sub <- !is.na(cell_fact) & (cell_fact == env_cell[i])
    if (sum(sub) > 1) {
      # Pairwise distances using lon/lat (assumed at columns 3:4)
      dist_mat <- lets.distmat(x$Presence_and_Absence_Matrix_geo[sub, 3:4])
      isolation[i, ] <- base::summary(dist_mat)
    }
  }
  
  # --- Metric 3: Distance to environmental midpoints (z-scored env) ---
  envs <- x$Presence_and_Absence_Matrix_env[, 2:3, drop = FALSE]
  envs <- apply(envs, 2, base::scale)
  
  pam_mid <- cbind(envs, Frequency)
  pam_mid <- pam_mid[Frequency > 0, , drop = FALSE]
  
  mid_wm <- matrix(c(
    stats::weighted.mean(pam_mid[, 1], pam_mid[, 3]),
    stats::weighted.mean(pam_mid[, 2], pam_mid[, 3])
  ), ncol = 2)
  
  mid_m  <- matrix(c(mean(pam_mid[, 1]), mean(pam_mid[, 2])), ncol = 2)
  
  # Distances from each env cell to the two midpoints
  dist_all_env <- as.matrix(stats::dist(rbind(mid_wm, mid_m, envs)))
  mid_dist <- dist_all_env[-(1:2), 1:2, drop = FALSE]
  colnames(mid_dist) <- c("Weighted Mean Distance to midpoint",
                          "Mean Distance to midpoint")
  
  # --- Metric 4: Distances to border proxies ---
  dist_env <- dist_all_env[-(1:2), -(1:2), drop = FALSE]
  
  # (4a) Minimum distance to any zero-richness cell
  zero_idx <- which(Frequency == 0)
  if (length(zero_idx) > 0) {
    dist_bord  <- apply(dist_env[zero_idx, , drop = FALSE], 2, min)
  } else {
    dist_bord  <- rep(NA_real_, n)
  }
  
  # Helper: mean of the n smallest distances (default: ~perc)
  n_min <- function(x, n = NULL, perc) {
    if (is.null(n)) n <- ceiling(length(x) * perc)
    mean(sort(x)[seq_len(min(n, length(x)))])
  }
  
  # (4b) Robust border: mean of closest ~perc zero-richness distances
  if (length(zero_idx) > 0) {
    dist_bord2 <- apply(dist_env[zero_idx, , drop = FALSE], 2, n_min, perc = perc)
  } else {
    dist_bord2 <- rep(NA_real_, n)
  }
  
  # (4c) Min distance to the convex hull (MCP) border of occupied env cells
  envs2 <- x$Presence_and_Absence_Matrix_env[Frequency > 0, 2:3, drop = FALSE]
  
  if (nrow(envs2) >= 3) {
    colnames(envs2) <- c("x", "y")
    sf_env <- sf::st_as_sf(data.frame(envs2),
                           coords = colnames(envs2))
    
    p  <- terra::vect(sf::st_concave_hull(sf_env, ratio = .5))
    
    # Extract raster cell ids overlapping the hull polygon
    ext_df <- terra::extract(x$Env_Richness_Raster, p, cells = TRUE)
    # Column 'cell' is typically the 3rd column returned by extract(..., cells=TRUE)
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
  
  # --- Metric 5: Environmental isolation (frequency-weighted mean distance) ---
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
  w_isol <- weighted_mean_distances(envs, Frequency)
  
  # --- Assemble output (note: midpoint distances are NEGATED by design) ---
  preds <- data.frame(
    "Cell_env"                        = x$Presence_and_Absence_Matrix_env[, 1],
    "Frequency"                       = Frequency,
    as.data.frame(isolation),
    as.data.frame(-mid_dist),
    "Minimum Zero Distance"           = dist_bord,
    "Minimum 10% Zero Distance"       = dist_bord2,
    "Distance to MCP border"          = dist_bord3,
    "Frequency Weighted Distance"     = w_isol,
    check.names = FALSE
  )
  preds
}


#' Plot environmental descriptors over the environmental raster grid
#'
#' @title Map envPAM descriptors
#' @description
#' Plots each column of the descriptor table returned by
#' \code{\link{lets.envcells}} back onto the environmental richness raster
#' embedded in the envPAM object. Rows with zero frequency are masked as \code{NA}.
#'
#' @param x The envPAM list returned by \code{\link{lets.envpam}} (must include
#' \code{$Env_Richness_Raster} and \code{$Presence_and_Absence_Matrix_env}).
#' @param y A \code{data.frame} returned by \code{\link{lets.envcells}} with
#' one row per environmental cell (aligned with \code{x}).
#' @param ras Logical; if \code{TRUE}, returns a named list of \pkg{terra} SpatRaster
#' layers corresponding to each column plotted. Default \code{FALSE}.
#' @param plot_ras Logical; if \code{TRUE}, the function plot the graphs.
#' Default \code{TRUE}.
#' @param mfrow A vector of the form c(nr, nc). The figures will be drawn
#'   in an nr-by-nc array on the device by rows as in par documentation.
#' @param which.plot Indicate the number of the columns in y to be ploted.
#' @param col_func A custom color ramp palette function to use for plotting variables (e.g., from \code{colorRampPalette}).
#' @param ... other arguments passed to  \code{terra::plot} function.
#' 
#' @details
#' Each descriptor column is assigned as values of the environmental raster template
#' and plotted sequentially. The plotting grid defaults to \code{par(mfrow = c(4,4))}.
#'
#' @return
#' Invisibly returns \code{NULL}. If \code{ras = TRUE}, returns a named list of
#' \link[terra]{SpatRaster} objects corresponding to each descriptor column.
#'
#' @examples
#' \dontrun{
#' data("Phyllomedusa"); data("prec"); data("temp")
#' prec <- unwrap(prec); temp <- unwrap(temp)
#' PAM  <- lets.presab(Phyllomedusa, remove.cells = FALSE)
#' envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
#' colnames(envs) <- c("Temperature", "Precipitation")
#' wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
#' PAM <- lets.pamcrop(PAM, terra::vect(wrld_simpl))
#' res <- lets.envpam(PAM, envs, n_bins = 30)
#' out <- lets.envcells(res, perc = 0.2)
#' lets.plot.envcells(res, out)
#' }
#'
#' @import terra graphics
#' @export
lets.plot.envcells <- function(x, y, ras = FALSE, plot_ras = TRUE,
                               mfrow = c(4, 4),
                               which.plot = NULL,
                               col_func = NULL,
                               ...) {
  
  # Work only with descriptor columns (drop the 'Cell_env' id)
  preds <- data.frame(y[, -1, drop = FALSE], check.names = FALSE)
  
  # Mask rows with zero frequency (column 2 after dropping id is 'Frequency')
  if (ncol(preds) >= 2) {
    preds[preds[, 1] == 0 | is.na(preds[, 2]), ] <- NA
  }
  
  # 4x4 grid (adjust if needed)
  if (plot_ras) {
  graphics::par(mfrow = mfrow)
  }
  # Raster template 
  r_template <- x$Env_Richness_Raster
  
  ras_list <- vector("list", length = ncol(preds))
  if (is.null(which.plot)) {
    seq_loop <- seq_len(ncol(preds))
  } else {
    seq_loop <- which.plot - 1
  }
  if (is.null(col_func)) {
    # Colour ramp from colorbrewer (T. Lucas suggestion)
    colfunc <- grDevices::colorRampPalette(c("#edf8b1", "#7fcdbb", "#2c7fb8"))
  }
  n_col <- apply(preds, 2, function(x){length(table(x))})
  
  for (i in seq_loop) {
    r <- r_template
    terra::values(r) <- preds[, i]
    
    # Aspect ratio based on extent
    ext_vals <- terra::ext(r)
    asp_ratio <- (ext_vals[2] - ext_vals[1]) / (ext_vals[4] - ext_vals[3])
    if (plot_ras) {
      plot(r, main = colnames(preds)[i], asp = asp_ratio,
           col = colfunc(n_col[i]),
           ...)
    }
    ras_list[[i]] <- r
  }
  if (ras) {
    names(ras_list) <- colnames(preds)
    return(ras_list)
  } else {
  invisible(NULL)
  }
}
