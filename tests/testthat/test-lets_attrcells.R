context("Tests for lets.attrcells")

test_that("lets.attrcells returns a data.frame with expected columns", {
  set.seed(1)
  df <- data.frame(
    Species = paste0("sp", 1:50),
    trait_a = rnorm(50),
    trait_b = rnorm(50)
  )
  
  x <- lets.attrpam(df, n_bins = 10)
  y <- lets.attrcells(x)
  
  expect_s3_class(y, "data.frame")
  expect_gt(nrow(y), 0)
  
  expected_cols <- c(
    "Cell_attr", "Richness",
    "Weighted Mean Distance to midpoint",
    "Mean Distance to midpoint",
    "Minimum Zero Distance",
    "Minimum 10% Zero Distance",
    "Distance to MCP border",
    "Frequency Weighted Distance"
  )
  
  expect_true(all(expected_cols %in% colnames(y)))
})



test_that("lets.attrcells output has same number of rows as PAM_attribute", {
  set.seed(2)
  df <- data.frame(
    Species = paste0("sp", 1:40),
    trait_a = rnorm(40),
    trait_b = rnorm(40)
  )
  
  x <- lets.attrpam(df, n_bins = 8)
  y <- lets.attrcells(x)
  
  expect_equal(nrow(y), nrow(x$PAM_attribute))
})


test_that("lets.attrcells handles case with no zero-richness cells", {
  set.seed(4)
  df <- data.frame(
    Species = paste0("sp", 1:20),
    trait_a = rnorm(20),
    trait_b = rnorm(20)
  )
  
  x <- lets.attrpam(df, n_bins = 5)
  terra::values(x$Attr_Richness_Raster) <- 1
  
  y <- lets.attrcells(x)
  
  expect_true(all(!is.na(y$`Weighted Mean Distance to midpoint`)))
  expect_true(all(!is.na(y$`Mean Distance to midpoint`)))
  expect_true(all(is.na(y$`Minimum Zero Distance`)))
  expect_true(all(is.na(y$`Minimum 10% Zero Distance`)))
  
  expect_true(all(!is.na(y$`Distance to MCP border`)))
})


test_that("MCP distance requires at least 3 occupied cells", {
  set.seed(5)
  df <- data.frame(
    Species = paste0("sp", 1:5),
    trait_a = rnorm(5),
    trait_b = rnorm(5)
  )
  
  x <- lets.attrpam(df, n_bins = 3)
  
  rich <- terra::values(x$Attr_Richness_Raster)[,1]
  idx <- which(!is.na(rich))
  rich[idx] <- c(1, 1, rep(0, length(idx) - 2))
  terra::values(x$Attr_Richness_Raster) <- rich
  
  y <- lets.attrcells(x)
  
  expect_true(all(is.na(y$`Distance to MCP border`)))
})



test_that("lets.attrcells respects perc argument", {
  set.seed(6)
  df <- data.frame(
    Species = paste0("sp", 1:60),
    trait_a = rnorm(60),
    trait_b = rnorm(60)
  )
  
  x <- lets.attrpam(df, n_bins = 10)
  
  rich <- terra::values(x$Attr_Richness_Raster)[,1]
  zero_idx <- sample(seq_along(rich), size = 10)
  rich[zero_idx] <- 0
  terra::values(x$Attr_Richness_Raster) <- rich
  
  y1 <- lets.attrcells(x, perc = 0.1)
  y2 <- lets.attrcells(x, perc = 0.5)
  
  expect_false(isTRUE(all.equal(
    y1$`Minimum 10% Zero Distance`,
    y2$`Minimum 10% Zero Distance`
  )))
})



test_that("midpoint distances are negated (centrality direction)", {
  set.seed(7)
  df <- data.frame(
    Species = paste0("sp", 1:30),
    trait_a = rnorm(30),
    trait_b = rnorm(30)
  )
  
  x <- lets.attrpam(df, n_bins = 8)
  y <- lets.attrcells(x)
  
  expect_true(all(y$`Weighted Mean Distance to midpoint` <= 0, na.rm = TRUE))
  expect_true(all(y$`Mean Distance to midpoint` <= 0, na.rm = TRUE))
})


test_that("lets.plot.attrcells works without plotting (plot_ras = FALSE)", {
  skip("Ainda precisa arrumar isso")
  set.seed(1)
  df <- data.frame(
    Species = paste0("sp", 1:50),
    trait_a = rnorm(50),
    trait_b = rnorm(50)
  )
  
  x <- lets.attrpam(df, n_bins = 10)
  y <- lets.attrcells(x)
  
  expect_silent(
    lets.plot.attrcells(x, y, plot_ras = FALSE)
  )
})


test_that("lets.plot.attrcells returns rasters when ras = TRUE", {
  skip("Ainda precisa arrumar isso")
  set.seed(2)
  df <- data.frame(
    Species = paste0("sp", 1:40),
    trait_a = rnorm(40),
    trait_b = rnorm(40)
  )
  
  x <- lets.attrpam(df, n_bins = 8)
  y <- lets.attrcells(x)
  
  ras_list <- lets.plot.attrcells(x, y, ras = TRUE, plot_ras = FALSE)
  
  expect_type(ras_list, "list")
  expect_gt(length(ras_list), 0)
  expect_true(all(vapply(ras_list, terra::is.raster, FUN.VALUE = logical(1))))
})


