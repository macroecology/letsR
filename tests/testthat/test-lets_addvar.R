context("Test for lets.addvar")
data(PAM)
data(temp)
temp <- unwrap(temp)

tempstack <- c(temp, temp)

test_that("lets.addvar works fine", {
  
  
  expect_warning(
    PAM_temp_mean <- lets.addvar(PAM, temp))
  
  expect_true(is.matrix(PAM_temp_mean))
  expect_true(ncol(as.matrix(PAM_temp_mean)) == (ncol(PAM[[1]]) + 1))
  
})

test_that("lets.addvar works fine, different fun", {
  
  
  expect_warning(
    PAM_temp_mean <- lets.addvar(PAM, temp, fun = sd))
  expect_true(is.matrix(PAM_temp_mean))
  expect_true(ncol(as.matrix(PAM_temp_mean)) == (ncol(PAM[[1]]) + 1))

})

test_that("lets.addvar works fine, onlyvar = TRUE", {
  
  
  expect_warning(
    PAM_temp_mean <- lets.addvar(PAM, temp, onlyvar = TRUE))
  expect_true(is.matrix(PAM_temp_mean))
  expect_true(ncol(as.matrix(PAM_temp_mean)) == 1)

})

test_that("lets.addvar works fine, multiple rasters", {
  
  
  expect_warning(
    PAM_temp_mean <- lets.addvar(PAM, tempstack))
  expect_true(is.matrix(PAM_temp_mean))
  expect_true(ncol(as.matrix(PAM_temp_mean)) == (ncol(PAM[[1]]) + 2))
  
})
