context("Test for lets.presab.grid")

# Species polygons
data(Phyllomedusa)

# Grid
sp.r <- terra::as.polygons(terra::rast(
  resol = 5,
  crs = terra::crs(Phyllomedusa),
  xmin = -93,
  xmax = -29,
  ymin = -57,
  ymax = 15
))
sp.r$ID <- 1:length(sp.r)


test_that("lets.presab.grid works fine", {
  resu <- lets.presab.grid(Phyllomedusa, sp.r, "ID")
  expect_equal(class(resu)[1], "list")
  expect_equal(class(resu[[1]])[1], "matrix")
})

