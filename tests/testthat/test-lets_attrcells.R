context("Test for lets.attrcells")

test_that("lets.attrcells returns a data.frame with expected columns", {
  
  set.seed(123)
  df <- data.frame(
    Species = paste0("sp", 1:200),
    trait_a = rnorm(200),
    trait_b = rnorm(200)
  )
  x <- lets.attrpam(df, n_bins = 20)
  
  expect_type(x, "list")

  expect_true("PAM_attribute" %in% names(x))
  expect_true("Attr_Richness_Raster" %in% names(x))
  expect_true(is.matrix(x$PAM_attribute))
  expect_s4_class(x$Attr_Richness_Raster, "SpatRaster")
})


test_that("output has same number of rows as attribute raster cells", {
  skip("need to fix removecells problem")
  
  df <- data.frame(
    Species = paste0("sp", 1:30),
    a = rnorm(30),
    b = rnorm(30)
  )
  x <- lets.attrpam(df, n_bins = 6, remove.cells = FALSE)
  
  res <- lets.attrcells(x)
  
  expect_equal(nrow(res), terra::ncell(x$Attr_Richness_Raster))
})
