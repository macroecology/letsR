# Tests for lets.smooth()
# Place this file in tests/testthat/test-lets-smooth.R

# Small deterministic raster with an irregular observation pattern.
# The central cell is unobserved, while the four outer corners are
# outside the convex hull of the observed cells.
make_smooth_test_raster <- function() {
  r <- terra::rast(
    nrows = 9, ncols = 9,
    xmin = -4.5, xmax = 4.5,
    ymin = -4.5, ymax = 4.5,
    crs = ""
  )

  xy <- terra::xyFromCell(r, seq_len(terra::ncell(r)))
  observed <- abs(xy[, 1]) <= 2 & abs(xy[, 2]) <= 2 &
    !(xy[, 1] == 0 & xy[, 2] == 0) &
    !(xy[, 1] == 1 & xy[, 2] == -1)

  z <- rep(NA_real_, terra::ncell(r))
  z[observed] <- 2 + 0.5 * xy[observed, 1] +
    0.25 * xy[observed, 2] + 0.1 * xy[observed, 1]^2

  terra::values(r) <- z
  names(r) <- "richness"
  r
}

test_that("lets.smooth returns a raster with the original geometry", {
  r <- make_smooth_test_raster()

  out <- lets.smooth(r, k_sigma = 1.5, restrict = FALSE)

  expect_true(inherits(out, "SpatRaster"))
  expect_equal(terra::nlyr(out), 1L)
  expect_true(terra::compareGeom(r, out, stopOnError = FALSE))
  expect_identical(names(out), "richness_smoothed")
})

test_that("unrestricted Gaussian smoothing fills all raster cells", {
  r <- make_smooth_test_raster()
  out <- lets.smooth(r, k_sigma = 1.5, restrict = FALSE)

  z_observed <- terra::values(r, mat = FALSE)
  z_predicted <- terra::values(out, mat = FALSE)

  expect_true(anyNA(z_observed))
  expect_false(anyNA(z_predicted))
  expect_true(all(is.finite(z_predicted)))

  # Every Gaussian-weighted mean must lie within the observed range.
  expect_gte(min(z_predicted), min(z_observed, na.rm = TRUE) - 1e-10)
  expect_lte(max(z_predicted), max(z_observed, na.rm = TRUE) + 1e-10)
})

test_that("Gaussian predictions equal an independently calculated weighted mean", {
  r <- make_smooth_test_raster()
  k <- 1.5
  out <- lets.smooth(r, k_sigma = k, restrict = FALSE)

  z <- terra::values(r, mat = FALSE)
  observed <- which(!is.na(z))
  xy <- terra::xyFromCell(r, observed)

  # Predict the missing central cell, at (0, 0).
  cell <- terra::cellFromXY(r, matrix(c(0, 0), ncol = 2))
  sigma <- k * mean(terra::res(r))
  weights <- exp(-rowSums(xy^2) / (2 * sigma^2))
  expected <- sum(weights * z[observed]) / sum(weights)

  expect_true(is.na(z[cell]))
  expect_equal(
    unname(terra::values(out, mat = FALSE)[cell]),
    unname(expected),
    tolerance = 1e-10
  )
})

test_that("a convex hull retains internal estimates and masks outside cells", {
  r <- make_smooth_test_raster()
  out <- lets.smooth(
    r, k_sigma = 1.5,
    restrict = TRUE, type_hull = "convex"
  )

  center <- terra::cellFromXY(r, matrix(c(0, 0), ncol = 2))
  corner <- terra::cellFromXY(r, matrix(c(-4, 4), ncol = 2))
  z_out <- terra::values(out, mat = FALSE)

  expect_true(is.na(terra::values(r, mat = FALSE)[center]))
  expect_true(is.finite(z_out[center]))
  expect_true(is.na(z_out[corner]))
  expect_true(terra::compareGeom(r, out, stopOnError = FALSE))
})

test_that("the default concave hull produces a valid masked raster", {
  r <- make_smooth_test_raster()

  out <- lets.smooth(r, k_sigma = 1, restrict = TRUE)

  expect_true(inherits(out, "SpatRaster"))
  expect_true(terra::compareGeom(r, out, stopOnError = FALSE))
  expect_true(any(is.finite(terra::values(out, mat = FALSE))))
})

test_that("automatic bandwidth selection works with varying observations", {
  r <- make_smooth_test_raster()

  expect_message(
    out <- lets.smooth(r, restrict = FALSE),
    "Selected k_sigma \\(LOOCV\\):"
  )

  z_out <- terra::values(out, mat = FALSE)
  expect_length(z_out, terra::ncell(r))
  expect_true(all(is.finite(z_out)))
})

test_that("automatic bandwidth handles a constant observed raster", {
  r <- make_smooth_test_raster()
  z <- terra::values(r, mat = FALSE)
  z[!is.na(z)] <- 7
  terra::values(r) <- z

  expect_message(
    out <- lets.smooth(r, k_sigma = "auto", restrict = FALSE),
    "Selected k_sigma \\(LOOCV\\): 1\\.0000"
  )
  expect_equal(
    terra::values(out, mat = FALSE),
    rep(7, terra::ncell(r)),
    tolerance = 1e-10
  )
})

test_that("a fixed bandwidth works with one observed cell without a hull", {
  r <- make_smooth_test_raster()
  z <- rep(NA_real_, terra::ncell(r))
  z[41] <- 4.2
  terra::values(r) <- z

  out <- lets.smooth(r, k_sigma = 1, restrict = FALSE)

  expect_equal(
    terra::values(out, mat = FALSE),
    rep(4.2, terra::ncell(r)),
    tolerance = 1e-10
  )
})

test_that("lets.smooth rejects invalid arguments", {
  r <- make_smooth_test_raster()

  expect_error(lets.smooth(matrix(1, 2, 2)), "SpatRaster")
  expect_error(lets.smooth(c(r, r)), "exactly one layer")

  expect_error(lets.smooth(r, plot_raster = NA), "plot_raster")
  expect_error(lets.smooth(r, plot_raster = 1), "plot_raster")
  expect_error(lets.smooth(r, restrict = NA), "restrict")
  expect_error(lets.smooth(r, restrict = "yes"), "restrict")

  expect_error(lets.smooth(r, k_sigma = 0), "k_sigma")
  expect_error(lets.smooth(r, k_sigma = -1), "k_sigma")
  expect_error(lets.smooth(r, k_sigma = Inf), "k_sigma")
  expect_error(lets.smooth(r, k_sigma = NA_real_), "k_sigma")
  expect_error(lets.smooth(r, k_sigma = "wrong"), "k_sigma")

  expect_error(lets.smooth(r, type_hull = "unknown"))
  expect_error(lets.smooth(r, param = NA_real_), "param")
  expect_error(lets.smooth(r, param = -0.1), "between 0 and 1")
  expect_error(lets.smooth(r, param = 1.1), "between 0 and 1")
  expect_error(
    lets.smooth(r, type_hull = "concave_length", param = 0),
    "positive"
  )
})

test_that("lets.smooth rejects missing or insufficient observations", {
  r <- make_smooth_test_raster()

  # No observed cells.
  empty <- terra::rast(r)
  terra::values(empty) <- rep(NA_real_, terra::ncell(empty))
  expect_error(lets.smooth(empty, k_sigma = 1), "at least one observed")

  # One observed cell: insufficient for LOOCV and for a hull.
  one <- terra::rast(r)
  z <- rep(NA_real_, terra::ncell(one))
  z[41] <- 3
  terra::values(one) <- z
  expect_error(
    lets.smooth(one, k_sigma = "auto", restrict = FALSE),
    "automatic bandwidth selection"
  )
  expect_error(
    lets.smooth(one, k_sigma = 1, restrict = TRUE),
    "At least three observed cells"
  )

  # Three observed cells along the same row cannot form a hull.
  line <- terra::rast(r)
  z <- rep(NA_real_, terra::ncell(line))
  ids <- terra::cellFromXY(
    line, matrix(c(-2, 0, 0, 0, 2, 0), ncol = 2, byrow = TRUE)
  )
  z[ids] <- c(2, 3, 4)
  terra::values(line) <- z
  expect_error(
    lets.smooth(line, k_sigma = 1, restrict = TRUE),
    "collinear"
  )

  # Infinite raster values are invalid input.
  infinite <- terra::rast(r)
  z <- terra::values(infinite, mat = FALSE)
  z[which(!is.na(z))[1]] <- Inf
  terra::values(infinite) <- z
  expect_error(
    lets.smooth(infinite, k_sigma = 1, restrict = FALSE),
    "infinite values"
  )
})
