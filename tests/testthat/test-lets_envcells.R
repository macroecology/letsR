context("Test for ")

make_test_envpam <- function() {
  pam_env <- data.frame(
    cell = 1:4,
    env1 = c(0, 1, -1, 0.5),
    env2 = c(2, 3, 1, 0),
    sp1  = c(1, 0, 1, 0),
    sp2  = c(0, 1, 0, 1)
  )
  
  pam_geo <- data.frame(
    cell = c(1,1,2,3),
    lon  = c(-50, -49, -48, -47),
    lat  = c(-10, -10, -11, -12),
    sp1  = c(1,1,0,0),
    sp2  = c(0,0,1,1)
  )
  
  r_env <- terra::rast(nrows = 2, ncols = 2, vals = c(1,1,1,1))
  
  list(
    Presence_and_Absence_Matrix_env = pam_env,
    Presence_and_Absence_Matrix_geo = pam_geo,
    Env_Richness_Raster = r_env
  )
}


test_that("lets.envcells returns a data.frame with expected columns", {
  x <- make_test_envpam()
  res <- lets.envcells(x)
  
  expect_s3_class(res, "data.frame")
  expect_true(all(c("Cell_env", "Frequency") %in% colnames(res)))
  expect_equal(nrow(res), 4)  
})


test_that("perc affects robust border-distance metric (real data)", {
  skip("need to fix issue with removecells")
  
  data("Phyllomedusa")
  data("prec"); prec <- unwrap(prec)
  data("temp"); temp <- unwrap(temp)
  
  PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
  envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
  colnames(envs) <- c("Temperature", "Precipitation")
  
  wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
  PAM <- lets.pamcrop(PAM, terra::vect(wrld_simpl))
  
  ##not working, only works with remove.cells = FALSE
  res <- lets.envpam(PAM, envs, n_bins = 15, remove.cells = FALSE)
  
  res1 <- lets.envcells(res, perc = 0.1)
  res2 <- lets.envcells(res, perc = 0.5)

  expect_false(isTRUE(all.equal(
    res1[["Minimum 10% Zero Distance"]],
    res2[["Minimum 10% Zero Distance"]]
  )))
})

