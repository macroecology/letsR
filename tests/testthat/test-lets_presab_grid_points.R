context("Test for lets.presab.grid.points")




# Species polygons
data("wrld_simpl")

# Grid
crs = "+proj=longlat +datum=WGS84 +no_defs"
sp.r <- terra::as.polygons(terra::rast(
  resol = 5,
  crs = crs,
  xmin = -93,
  xmax = -29,
  ymin = -57,
  ymax = 15
))
sp.r$ID <- 1:length(sp.r)

# Occurrence Points
N = 20
species <- c(rep("sp1", N), rep("sp2", N),
             rep("sp3", N), rep("sp4", N))
x <- runif(N * 4, min = -69, max = -51)
y <- runif(N * 4, min = -23, max = -4)
xy <- cbind(x, y)

test_that("lets.presab.grid.points works fine", {
  # PAM
  resu <- lets.presab.grid.points(xy, species, sp.r, "ID")
  expect_equal(class(resu)[1], "list")
  expect_equal(class(resu[[1]])[1], "matrix")
})

