#' Smooth and interpolate raster values using a Gaussian kernel
#'
#' @description
#' Applies Gaussian kernel regression to estimate values across a raster
#' containing incomplete observations. It is particularly useful for
#' exploring biodiversity patterns in environmental and attribute spaces,
#' where observations may be sparse or irregularly distributed. Predictions
#' can be restricted to a convex or concave hull around observed cells.
#'
#' @details
#' The function uses the Nadaraya-Watson estimator, which predicts each
#' raster value as a Gaussian-weighted mean of non-missing observations.
#' Missing raster values are not interpreted as zeros. Species richness or
#' any other numerical raster variable can be smoothed.
#'
#' The Gaussian bandwidth is calculated as:
#'
#' \deqn{\sigma = k_\sigma \times \mathrm{mean}(\mathrm{res}(x))}
#'
#' When `k_sigma = "auto"`, the multiplier is selected by minimizing
#' leave-one-out cross-validation mean squared error (LOOCV MSE) among
#' observed cells. The search evaluates 30 logarithmically spaced values
#' between 0.25 and 10, followed by local numerical refinement when the
#' best grid value is not at a boundary. When all observed values are
#' identical, cross-validation does not identify a unique bandwidth and
#' `k_sigma = 1` is used instead. A numerical `k_sigma` bypasses selection.
#'
#' All observed cells contribute to each prediction. Consequently, cells
#' without observations can receive estimates even when no observations
#' fall within a local focal window. With `restrict = TRUE`, the predicted
#' surface is masked to a hull built from observed cell centers. Boundary
#' cells intersected by the hull may be retained.
#'
#' Euclidean distances are measured in raster coordinate units. Axes should
#' be on comparable scales, and the selected bandwidth should not be
#' interpreted as uncertainty. LOOCV evaluates prediction of observed
#' values, not recovery of an unobserved theoretical distribution.
#'
#' @param x A single-layer SpatRaster containing numerical values. Missing
#'   observations must be represented by NA.
#' @param plot_raster Logical. If TRUE, plots the original and smoothed
#'   rasters side by side. Default is FALSE.
#' @param k_sigma Either `"auto"` or a positive finite numeric multiplier
#'   of the mean raster resolution. With `"auto"`, the value is selected
#'   by LOOCV over multipliers from 0.25 to 10. Default is `"auto"`.
#' @param restrict Logical. If TRUE, masks predictions to a hull around
#'   observed cells. If FALSE, predicts across the full raster extent.
#'   Default is TRUE.
#' @param type_hull Character. Hull method passed to [terra::hull()].
#'   One of `"convex"`, `"rectangle"`, `"circle"`, `"concave_ratio"`,
#'   or `"concave_length"`. Default is `"concave_ratio"`.
#' @param param Numeric. For `"concave_ratio"`, a value between 0 and 1,
#'   with higher values giving a more convex hull. For `"concave_length"`,
#'   a positive maximum edge length in raster coordinate units.
#'   Ignored for other hull types. Default is 0.5.
#'
#' @return A single-layer SpatRaster containing the kernel regression
#'   estimates. The input extent and resolution are preserved. When
#'   `restrict = TRUE`, cells outside the hull mask are assigned NA.
#'
#' @seealso [terra::hull()], [terra::mask()], [terra::xyFromCell()]
#'
#' @examples
#' # Simulate two correlated traits for 500 species
#' set.seed(1)
#' n <- 500
#' Species <- paste0("sp", seq_len(n))
#' trait_a <- rnorm(n)
#' trait_b <- 0.2 * trait_a + rnorm(n)
#' df <- data.frame(Species, trait_a, trait_b)
#'
#' # Construct a sparsely occupied attribute space
#' attrpam <- lets.attrpam(df, n_bins = 30)
#' r <- attrpam$Attr_Richness_Raster
#'
#' # Select bandwidth automatically using LOOCV
#' smoothed <- lets.smooth(
#'   r, k_sigma = "auto", type_hull = "convex", plot_raster = TRUE
#' )
#'
#' # Fixed bandwidth and a concave hull
#' smoothed_concave <- lets.smooth(
#'   r, k_sigma = 1.5, type_hull = "concave_ratio", param = 0.5
#' )
#'
#' # Predict across the entire raster, without a hull mask
#' smoothed_full <- lets.smooth(r, k_sigma = 1.5, restrict = FALSE)
#'
#' @export
lets.smooth <- function(x,
                        plot_raster = FALSE,
                        k_sigma = "auto",
                        restrict = TRUE,
                        type_hull = "concave_ratio",
                        param = 0.5) {
  
  # 1. Validate arguments --------------------------------------
  
  if (!inherits(x, "SpatRaster")) {
    stop("'x' must be a SpatRaster.")
  }
  if (terra::nlyr(x) != 1L) {
    stop("'x' must have exactly one layer.")
  }
  if (!is.logical(plot_raster) || length(plot_raster) != 1L ||
      is.na(plot_raster)) {
    stop("'plot_raster' must be TRUE or FALSE.")
  }
  if (!is.logical(restrict) || length(restrict) != 1L ||
      is.na(restrict)) {
    stop("'restrict' must be TRUE or FALSE.")
  }
  
  auto_sigma <- identical(k_sigma, "auto")
  if (!auto_sigma &&
      (!is.numeric(k_sigma) || length(k_sigma) != 1L ||
       !is.finite(k_sigma) || k_sigma <= 0)) {
    stop("'k_sigma' must be 'auto' or a positive finite number.")
  }
  
  type_hull <- match.arg(
    type_hull,
    c("convex", "rectangle", "circle", "concave_ratio", "concave_length")
  )
  if (!is.numeric(param) || length(param) != 1L ||
      !is.finite(param)) {
    stop("'param' must be a finite numeric value.")
  }
  if (type_hull == "concave_ratio" && (param < 0 || param > 1)) {
    stop("'param' must be between 0 and 1 for 'concave_ratio'.")
  }
  if (type_hull == "concave_length" && param <= 0) {
    stop("'param' must be positive for 'concave_length'.")
  }
  
  # 2. Get observed values and their coordinates ---------------
  
  z_all <- terra::values(x, mat = FALSE)
  if (any(is.infinite(z_all))) {
    stop("'x' must not contain infinite values.")
  }
  valid <- which(!is.na(z_all))
  n_obs <- length(valid)
  if (n_obs == 0L) {
    stop("'x' must contain at least one observed value.")
  }
  if (restrict && n_obs < 3L) {
    stop("At least three observed cells are required for a hull.")
  }
  if (auto_sigma && n_obs < 3L) {
    stop("At least three observed cells are required for automatic bandwidth selection.")
  }
  
  xy_obs <- terra::xyFromCell(x, valid)
  z <- z_all[valid]
  if (restrict && qr(cbind(1, xy_obs))$rank < 3L) {
    stop("Observed cell centers must not be collinear.")
  }
  
  # 3. Select Gaussian bandwidth -------------------------------
  
  resolution <- mean(terra::res(x))
  if (!is.finite(resolution) || resolution <= 0) {
    stop("The raster resolution must be positive and finite.")
  }
  
  if (auto_sigma) {
    if (all(z == z[1L])) {
      # Any bandwidth predicts the same constant surface.
      k_sigma <- 1
    } else {
      # Chunking avoids storing an n_obs-by-n_obs distance matrix.
      cv_chunk <- max(1L, min(256L, floor(1e6 / n_obs)))
      
      cv_mse <- function(log_k) {
        sigma_cv <- exp(log_k) * resolution
        if (!is.finite(sigma_cv^2) || sigma_cv^2 <= 0) {
          return(Inf)
        }
        squared_error <- 0
        
        for (start in seq.int(1L, n_obs, by = cv_chunk)) {
          ids <- start:min(start + cv_chunk - 1L, n_obs)
          xy_target <- xy_obs[ids, , drop = FALSE]
          
          d2 <- outer(xy_target[, 1L], xy_obs[, 1L], "-")^2 +
            outer(xy_target[, 2L], xy_obs[, 2L], "-")^2
          log_w <- -d2 / (2 * sigma_cv^2)
          
          # An observation must not contribute to its own prediction.
          log_w[cbind(seq_along(ids), ids)] <- -Inf
          
          # Stable normalization of Gaussian weights by row.
          row_max <- apply(log_w, 1L, max)
          if (any(!is.finite(row_max))) {
            return(Inf)
          }
          w <- exp(sweep(log_w, 1L, row_max, "-"))
          predicted <- drop(w %*% z) / rowSums(w)
          if (any(!is.finite(predicted))) {
            return(Inf)
          }
          squared_error <- squared_error +
            sum((z[ids] - predicted)^2)
        }
        
        squared_error / n_obs
      }
      
      candidates <- exp(seq(log(0.25), log(10), length.out = 30L))
      errors <- vapply(log(candidates), cv_mse, numeric(1L))
      best <- which.min(errors)
      k_sigma <- candidates[best]
      
      # Refine only inside the best grid interval.
      if (best > 1L && best < length(candidates)) {
        refined <- stats::optimize(
          cv_mse,
          interval = log(candidates[c(best - 1L, best + 1L)])
        )
        if (is.finite(refined$objective) &&
            refined$objective < errors[best]) {
          k_sigma <- exp(refined$minimum)
        }
      }
    }
    message(sprintf("Selected k_sigma (LOOCV): %.4f", k_sigma))
  }
  
  sigma <- k_sigma * resolution
  if (!is.finite(sigma^2) || sigma^2 <= 0) {
    stop("The calculated Gaussian bandwidth is numerically invalid.")
  }
  
  # 4. Predict at every raster cell ----------------------------
  
  n_cells <- terra::ncell(x)
  estimated <- numeric(n_cells)
  chunk_size <- max(1L, min(256L, floor(1e6 / n_obs)))
  
  for (start in seq.int(1L, n_cells, by = chunk_size)) {
    ids <- start:min(start + chunk_size - 1L, n_cells)
    xy_target <- terra::xyFromCell(x, ids)
    
    d2 <- outer(xy_target[, 1L], xy_obs[, 1L], "-")^2 +
      outer(xy_target[, 2L], xy_obs[, 2L], "-")^2
    log_w <- -d2 / (2 * sigma^2)
    row_max <- apply(log_w, 1L, max)
    w <- exp(sweep(log_w, 1L, row_max, "-"))
    
    estimated[ids] <- drop(w %*% z) / rowSums(w)
  }
  
  result <- terra::rast(x)
  terra::values(result) <- estimated
  
  # 5. Optionally mask predictions to observed-space hull ------
  
  if (restrict) {
    points <- terra::vect(
      data.frame(x = xy_obs[, 1L], y = xy_obs[, 2L]),
      geom = c("x", "y"),
      crs = terra::crs(x)
    )
    hull <- terra::hull(
      points,
      type = type_hull,
      param = param,
      allowHoles = FALSE
    )
    result <- terra::mask(result, hull, touches = TRUE)
  }
  
  names(result) <- paste0(names(x), "_smoothed")
  
  # 6. Plot ---------------------------------------------------
  
  if (plot_raster) {
    old_par <- graphics::par(mfrow = c(1, 2))
    on.exit(graphics::par(old_par), add = TRUE)
    
    terra::plot(x, main = "Original space")
    if (restrict) terra::lines(hull, col = "red", lwd = 2)
    
    terra::plot(result, main = "Smoothed space")
    if (restrict) terra::lines(hull, col = "red", lwd = 2)
  }
  
  return(result)
}
