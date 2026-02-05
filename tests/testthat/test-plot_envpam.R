context("Tests for lets.plot.envpam")

n <- 25  # 
env_pam <- list(
  data.frame(
    id = 1:n,
    env1 = rnorm(n),
    env2 = rnorm(n)
  ),
  data.frame(
    id_env = 1:n,
    id_geo = 1:n,
    sp1 = sample(0:1, n, TRUE)
  ),
  terra::rast(nrows = 5, ncols = 5, vals = sample(0:3, n, TRUE)),
  terra::rast(nrows = 5, ncols = 5, vals = sample(0:3, n, TRUE))
)


test_that("lets.plot.envpam runs with default arguments", {
  
  pdf(NULL)
  expect_silent(lets.plot.envpam(env_pam))
  dev.off()
})


test_that("lets.plot.envpam errors if more than one highlight is used", {

  
  expect_error(
    lets.plot.envpam(env_pam,
                     species = "sp1",
                     cell_id_env = 1),
    "More than one highligh"
  )
})


test_that("lets.plot.envpam highlights species correctly", {
  
  pdf(NULL)
  expect_silent(lets.plot.envpam(env_pam, species = "sp1"))
  dev.off()
})


test_that("lets.plot.envpam highlights env cells", {
  
  pdf(NULL)
  expect_silent(lets.plot.envpam(env_pam, cell_id_env = 2))
  dev.off()
})


test_that("lets.plot.envpam highlights geo cells", {

  pdf(NULL)
  expect_silent(lets.plot.envpam(env_pam, cell_id_geo = 3))
  dev.off()
})


test_that("lets.plot.envpam returns raster when rast_return=TRUE", {
  
  out <- lets.plot.envpam(env_pam,
                          rast_return = TRUE,
                          geo_plot = FALSE)
  
  expect_s4_class(out, "SpatRaster")
})

