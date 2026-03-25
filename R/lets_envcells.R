#' Environmental-cell descriptors for an environmental PAM (envPAM)
#'
#' @title Descriptors of position, centrality, area, and isolation in environmental space
#'
#' @description
#' Calculates descriptor variables for each cell of an environmental
#' presence–absence matrix (envPAM), as returned by
#' \code{\link{lets.envpam}}. The two environmental axes are treated as a
#' two-dimensional coordinate system, and the function derives metrics that
#' summarize the position of each environmental cell in this space, its
#' proximity to empty regions and borders, and its average isolation from
#' other cells.
#'
#' The function also links each environmental cell to the geographic cells
#' assigned to it, allowing the calculation of frequency, area, and
#' geographic isolation summaries.
#'
#' @param x A list produced by \code{\link{lets.envpam}} containing, at
#'   minimum:
#'   \itemize{
#'     \item \code{$Presence_and_Absence_Matrix_env}: a data frame in which
#'     the first column is the environmental-cell identifier
#'     (\code{cell_id_env}), the second and third columns are the
#'     coordinates of the two environmental axes, and the remaining columns
#'     are taxa coded as presence (1) or absence (0).
#'     \item \code{$Presence_and_Absence_Matrix_geo}: a data frame linking
#'     geographic cells to environmental cells. The first column is assumed
#'     to contain the environmental-cell identifier, the second column the
#'     geographic cell identifier, and columns 3 and 4 the geographic
#'     coordinates used in distance calculations.
#'     \item \code{$Env_Richness_Raster}: a \link[terra]{SpatRaster}
#'     containing richness in environmental space.
#'     \item \code{$Geo_Richness_Raster}: a \link[terra]{SpatRaster}
#'     containing richness in geographic space and used to compute the area
#'     associated with each environmental cell.
#'   }
#' @param perc Numeric value in the interval \eqn{(0, 1]} indicating the
#'   proportion of the shortest distances to empty environmental cells to
#'   be averaged in the robust border-distance metric. Default is
#'   \code{0.1}.
#'
#' @details
#' The two environmental variables (columns 2 and 3 of
#' \code{x$Presence_and_Absence_Matrix_env}) are standardized to zero mean
#' and unit variance before distance-based calculations.
#'
#' The function first determines how many geographic cells are associated
#' with each environmental cell and computes:
#' \itemize{
#'   \item \code{Frequency}: number of geographic cells assigned to the
#'   environmental cell;
#'   \item \code{Area}: total area of those geographic cells;
#'   \item summary statistics of pairwise geographic distances among those
#'   geographic cells.
#' }
#'
#' Distances to the weighted and unweighted midpoints are returned as
#' negative values so that larger values indicate greater centrality in
#' environmental space.
#'
#' Empty environmental cells are defined as cells with zero frequency, that
#' is, cells to which no geographic cells are assigned.
#'
#' The function also calculates three border-related descriptors:
#' \itemize{
#'   \item the minimum distance to any empty environmental cell;
#'   \item the mean distance to the nearest \code{perc} proportion of empty
#'   environmental cells;
#'   \item the distance to the border of the hull enclosing occupied
#'   environmental cells.
#' }
#'
#' Geographic isolation is summarized using \code{summary()} applied to the
#' pairwise distance matrix among geographic cells associated with each
#' environmental cell. For cells represented by a single geographic cell,
#' isolation statistics remain \code{NA}.
#'
#' @return
#' A \code{data.frame} with one row per environmental cell. The output
#' contains:
#' \itemize{
#'   \item \code{Cell_env}: environmental-cell identifier.
#'   \item \code{Frequency}: number of geographic cells mapped to the
#'   environmental cell.
#'   \item \code{Area}: summed area of the geographic cells mapped to the
#'   environmental cell.
#'   \item \code{Isolation (Min.)}, \code{Isolation (1st Qu.)},
#'   \code{Isolation (Median)}, \code{Isolation (Mean)},
#'   \code{Isolation (3rd Qu.)}, and \code{Isolation (Max.)}: summary
#'   statistics of pairwise geographic distances among mapped geographic
#'   cells.
#'   \item \code{Weighted Mean Distance to midpoint}: negative Euclidean
#'   distance from the cell to the frequency-weighted midpoint of occupied
#'   environmental space.
#'   \item \code{Mean Distance to midpoint}: negative Euclidean distance
#'   from the cell to the unweighted midpoint of occupied environmental
#'   space.
#'   \item \code{Minimum Zero Distance}: minimum distance from the cell to
#'   any empty environmental cell.
#'   \item a column named according to the percentage defined by
#'   \code{perc} (for example, \code{Minimum 10\% Zero Distance}),
#'   containing the mean distance from the cell to the nearest fraction of
#'   empty environmental cells defined by \code{perc}.
#'   \item \code{Distance to MCP border}: distance from the cell to the
#'   border of the hull enclosing occupied environmental cells.
#'   \item \code{Frequency Weighted Distance}: weighted mean distance from
#'   the cell to all other environmental cells.
#' }
#'
#' @section Assumptions:
#' \itemize{
#'   \item The first column of \code{x$Presence_and_Absence_Matrix_env}
#'   contains environmental-cell identifiers.
#'   \item Columns 2 and 3 of \code{x$Presence_and_Absence_Matrix_env}
#'   contain the two environmental variables used to define environmental
#'   space.
#'   \item The first column of \code{x$Presence_and_Absence_Matrix_geo}
#'   links geographic records to environmental cells.
#'   \item Columns 3 and 4 of \code{x$Presence_and_Absence_Matrix_geo}
#'   contain the geographic coordinates used in distance calculations.
#' }
#'
#' @section Caveats:
#' \itemize{
#'   \item If there are no empty environmental cells, the zero-distance
#'   border metrics are returned as \code{NA}.
#'   \item If fewer than three occupied environmental cells are available,
#'   the hull-based border metric is returned as \code{NA}.
#'   \item Cells represented by only one geographic cell do not have
#'   pairwise geographic distances, so isolation statistics remain
#'   \code{NA}.
#' }
#'
#' @seealso \code{\link{lets.envpam}}, \code{\link{lets.plot.envcells}},
#'   \code{\link{lets.plot.envpam}}
#'
#' @examples
#' \dontrun{
#' data("Phyllomedusa")
#' data("prec")
#' data("temp")
#'
#' prec <- unwrap(prec)
#' temp <- unwrap(temp)
#'
#' PAM  <- lets.presab(Phyllomedusa, remove.cells = FALSE)
#' envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
#' colnames(envs) <- c("Temperature", "Precipitation")
#'
#' wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
#' PAM <- lets.pamcrop(PAM, terra::vect(wrld_simpl))
#'
#' x <- lets.envpam(PAM, envs, n_bins = 30)
#' env_desc <- lets.envcells(x, perc = 0.1)
#'
#' lets.plot.envcells(x, env_desc)
#' }
#'
#' @import terra grDevices
#' @export
lets.envcells <- function(x, perc = 0.1) {
  
  # Environmental-cell identifiers and mapping of geographic records to
  # environmental cells
  env_cell  <- unique(x$Presence_and_Absence_Matrix_env[, 1])
  cell_fact <- factor(x$Presence_and_Absence_Matrix_geo[, 1], levels = env_cell)
  n <- length(env_cell)
  
  # Number and total area of geographic cells associated with each
  # environmental cell
  Frequency <- as.numeric(base::table(cell_fact))
  
  vs <- terra::values(terra::cellSize(terra::unwrap(x$Geo_Richness_Raster)))[, 1]
  
  Area <- tapply(vs[x$Presence_and_Absence_Matrix_geo[, 2]],
                 x$Presence_and_Absence_Matrix_geo[, 1], 
                 sum, na.rm = TRUE)[as.character(env_cell)]
  
  
  # Summary statistics of pairwise geographic distances among geographic
  # cells mapped to each environmental cell
  iso_names <- c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max.")
  isolation <- matrix(NA_real_, nrow = n, ncol = length(iso_names))
  colnames(isolation) <- paste0("Isolation (", iso_names, ")")
  
  for (i in seq_len(n)) {
    sub <- cell_fact == env_cell[i]
    if (sum(sub) > 1) {
      # Pairwise distances computed from geographic coordinates
      dist_mat <- lets.distmat(x$Presence_and_Absence_Matrix_geo[sub, 3:4])
      isolation[i, ] <- base::summary(dist_mat)
    }
  }
  
  # Standardize environmental coordinates before computing distances
  envs <- x$Presence_and_Absence_Matrix_env[, 2:3, drop = FALSE]
  envs <- apply(envs, 2, base::scale)
  
  # Weighted and unweighted midpoints calculated from occupied cells only
  pam_mid <- cbind(envs, Frequency)
  pam_mid <- pam_mid[Frequency > 0, , drop = FALSE]
  
  mid_wm <- matrix(c(
    stats::weighted.mean(pam_mid[, 1], pam_mid[, 3]),
    stats::weighted.mean(pam_mid[, 2], pam_mid[, 3])
  ), ncol = 2)
  
  mid_m  <- matrix(c(mean(pam_mid[, 1]), mean(pam_mid[, 2])), ncol = 2)
  
  # Distances from each environmental cell to the two midpoints
  dist_all_env <- as.matrix(stats::dist(rbind(mid_wm, mid_m, envs)))
  mid_dist <- dist_all_env[-(1:2), 1:2, drop = FALSE]
  colnames(mid_dist) <- c("Weighted Mean Distance to midpoint",
                          "Mean Distance to midpoint")
  
  # Pairwise distances among all environmental cells
  dist_env <- dist_all_env[-(1:2), -(1:2), drop = FALSE]
  
  # Minimum distance from each cell to any empty environmental cell
  zero_idx <- which(Frequency == 0)
  if (length(zero_idx) > 0) {
    dist_bord  <- apply(dist_env[zero_idx, , drop = FALSE], 2, min)
  } else {
    dist_bord  <- rep(NA_real_, n)
  }
  
  # Robust border metric: mean distance to the nearest perc fraction of
  # empty environmental cells
  n_min <- function(x, n = NULL, perc) {
    if (is.null(n)) n <- ceiling(length(x) * perc)
    mean(sort(x)[seq_len(min(n, length(x)))])
  }
  
  if (length(zero_idx) > 0) {
    dist_bord2 <- apply(dist_env[zero_idx, , drop = FALSE], 2, n_min, perc = perc)
  } else {
    dist_bord2 <- rep(NA_real_, n)
  }
  
  # Distance from each cell to the border of the hull enclosing occupied
  # environmental cells
  envs2 <- x$Presence_and_Absence_Matrix_env[Frequency > 0, 2:3, drop = FALSE]
  
  if (nrow(envs2) >= 3) {
    colnames(envs2) <- c("x", "y")
    sf_env <- sf::st_as_sf(data.frame(envs2),
                           coords = colnames(envs2))
    
    p  <- terra::vect(sf::st_concave_hull(sf_env, ratio = .5))
    
    # Raster cell identifiers overlapping the hull polygon
    ext_df <- terra::extract(x$Env_Richness_Raster, p, cells = TRUE)
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
  
  # Weighted mean distance from each environmental cell to all other
  # environmental cells
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
  
  perc_label <- paste0("Minimum ", round(perc * 100), "% Zero Distance")
  
  # Assemble output; midpoint distances are multiplied by -1 so that
  # larger values indicate greater centrality
  preds <- data.frame(
    "Cell_env"                        = x$Presence_and_Absence_Matrix_env[, 1],
    "Frequency"                       = Frequency,
    "Area"                            = Area,
    as.data.frame(isolation),
    as.data.frame(-mid_dist),
    "Minimum Zero Distance"           = dist_bord,
    setNames(list(dist_bord2), perc_label),
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
