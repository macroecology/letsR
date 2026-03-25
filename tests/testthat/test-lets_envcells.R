context("Test for lets.envcells")

test_that("lets.envcells basic functionality", {
  
  env_cells <- data.frame(
    cell_id_env = 1:3,
    var1 = c(0.1, 0.5, 0.9),
    var2 = c(0.2, 0.6, 0.8),
    sp1 = c(1, 0, 1),
    sp2 = c(0, 1, 1)
  )
  
  # First column must indicate the environmental cell linked to each
  # geographic record; second column is the geographic cell id; third and
  # fourth columns are coordinates used in distance calculations
  geo_cells <- data.frame(
    cell_id_env = c(1, 1, 2, 3, 3),
    cell_id_geo = 1:5,
    lon = c(10, 11, 12, 13, 14),
    lat = c(-5, -4, -3, -2, -1)
  )
  
  r_env <- rast(nrows = 3, ncols = 1)
  values(r_env) <- 1:3
  
  r_geo <- rast(nrows = 5, ncols = 1)
  values(r_geo) <- 1:5
  
  x <- list(
    Presence_and_Absence_Matrix_env = env_cells,
    Presence_and_Absence_Matrix_geo = geo_cells,
    Env_Richness_Raster = r_env,
    Geo_Richness_Raster = r_geo
  )
  
  res <- lets.envcells(x)
  
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), nrow(env_cells))
  
  expect_true(all(c(
    "Cell_env",
    "Frequency",
    "Area",
    "Weighted Mean Distance to midpoint",
    "Mean Distance to midpoint",
    "Minimum Zero Distance",
    "Distance to MCP border",
    "Frequency Weighted Distance"
  ) %in% colnames(res)))
  
  numeric_cols <- setdiff(colnames(res), "Cell_env")
  expect_true(all(vapply(res[, numeric_cols, drop = FALSE], is.numeric, logical(1))))
  
  expect_true(all(res$Frequency >= 0))
  expect_equal(res$Frequency, c(2, 1, 2))
})

test_that("lets.envcells uses dynamic column name according to perc", {
  
  env_cells <- data.frame(
    cell_id_env = 1:3,
    var1 = c(0.1, 0.5, 0.9),
    var2 = c(0.2, 0.6, 0.8),
    sp1 = c(1, 0, 1),
    sp2 = c(0, 1, 1)
  )
  
  geo_cells <- data.frame(
    cell_id_env = c(1, 1, 2, 3, 3),
    cell_id_geo = 1:5,
    lon = c(10, 11, 12, 13, 14),
    lat = c(-5, -4, -3, -2, -1)
  )
  
  r_env <- rast(nrows = 3, ncols = 1)
  values(r_env) <- 1:3
  
  r_geo <- rast(nrows = 5, ncols = 1)
  values(r_geo) <- 1:5
  
  x <- list(
    Presence_and_Absence_Matrix_env = env_cells,
    Presence_and_Absence_Matrix_geo = geo_cells,
    Env_Richness_Raster = r_env,
    Geo_Richness_Raster = r_geo
  )
  
  res <- lets.envcells(x, perc = 0.2)
  
  expect_true("Minimum 20% Zero Distance" %in% colnames(res))
  expect_false("Minimum 10% Zero Distance" %in% colnames(res))
})

test_that("lets.plot.envcells basic plotting and ras output", {
  
  env_cells <- data.frame(
    Cell_env = 1:3,
    Frequency = c(2, 1, 1),
    `Weighted Mean Distance to midpoint` = c(0.5, 0.6, 0.7),
    `Mean Distance to midpoint` = c(0.4, 0.5, 0.6),
    `Frequency Weighted Distance` = c(0.3, 0.2, 0.1)
  )
  
  r <- rast(nrows = 3, ncols = 1)
  values(r) <- 1:3
  x <- list(Env_Richness_Raster = r)
  
  ras_list <- lets.plot.envcells(x, env_cells, ras = TRUE, plot_ras = FALSE)
  
  expect_type(ras_list, "list")
  expect_equal(length(ras_list), ncol(env_cells) - 1)
  expect_true(all(vapply(ras_list, inherits, logical(1), "SpatRaster")))
})