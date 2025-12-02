context("Tests for plot.attrpam")

test_that("lets.plot.attrpam works fine", {
  
  Species <- paste0("sp", 1:3)
  trait_vals <- 1:3
  PAM_attr <- data.frame(
    x = 1:3,
    trait1 = c(0.1, 0.5, 0.9),
    trait2 = c(0.2, 0.6, 0.8),
    sp1 = c(1,0,1),
    sp2 = c(0,1,1),
    sp3 = c(1,1,0)
  )
  
  r <- rast(nrows = 3, ncols = 1)
  values(r) <- 1:3
  
  x <- list(
    PAM_attribute = PAM_attr,
    PAM_raster = r
  )
  
  expect_silent(res <- lets.plot.attrpam(x))
  expect_null(res)
  expect_silent(res2 <- lets.plot.attrpam(x, species = "sp1"))
  expect_null(res2)

  custom_pal <- colorRampPalette(c("blue", "yellow"))
  expect_silent(res3 <- lets.plot.attrpam(x, col_rich = custom_pal))
  expect_null(res3)
})

test_that("lets.plot.attrpam handles species not present", {
  
  Species <- paste0("sp", 1:3)
  PAM_attr <- data.frame(
    x = 1:3,
    trait1 = c(0.1, 0.5, 0.9),
    trait2 = c(0.2, 0.6, 0.8),
    sp1 = c(1,0,1),
    sp2 = c(0,1,1),
    sp3 = c(1,1,0)
  )
  
  r <- rast(nrows = 3, ncols = 1)
  values(r) <- 1:3
  
  x <- list(PAM_attribute = PAM_attr, PAM_raster = r)

  expect_silent(res <- lets.plot.attrpam(x, species = "sp_not_exist"))
  expect_null(res)
})

