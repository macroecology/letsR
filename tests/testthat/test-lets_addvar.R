context("Test for lets.addvar")
data(PAM)
data(temp)

tempstack <- stack(temp, temp)

test_that("lets.addvar works fine", {
  skip_on_cran()
  
  PAM_temp_mean <- lets.addvar(PAM, temp)
  expect_true(class(PAM_temp_mean) == "matrix")
  expect_true(ncol(as.matrix(PAM_temp_mean)) == (ncol(PAM[[1]]) + 1))
  
})

test_that("lets.addvar works fine, different fun", {
  skip_on_cran()
  
  PAM_temp_mean <- lets.addvar(PAM, temp, fun = sd)
  expect_true(class(PAM_temp_mean) == "matrix")
  expect_true(ncol(as.matrix(PAM_temp_mean)) == (ncol(PAM[[1]]) + 1))

})

test_that("lets.addvar works fine, onlyvar = TRUE", {
  skip_on_cran()
  
  PAM_temp_mean <- lets.addvar(PAM, temp, onlyvar = TRUE)
  expect_true(class(PAM_temp_mean) == "matrix")
  expect_true(ncol(as.matrix(PAM_temp_mean)) == 1)

})

test_that("lets.addvar works fine, multiple rasters", {
  skip_on_cran()
  
  PAM_temp_mean <- lets.addvar(PAM, tempstack)
  expect_true(class(PAM_temp_mean) == "matrix")
  expect_true(ncol(as.matrix(PAM_temp_mean)) == (ncol(PAM[[1]]) + 2))
  
})