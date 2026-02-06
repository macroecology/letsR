context("Test for lets.classvar")

setup({
  data(PAM)
  data(temp)
  temp <- terra::unwrap(temp)
  
  pamvar <<- suppressWarnings(
    lets.addvar(PAM, temp)
  )
})
 

test_that("lets.addpoly lets.classvar fine", {
  
 
  resu_test <- lets.classvar(x = pamvar, pos = ncol(pamvar), xy = TRUE)
  
  expect_true(is.matrix(resu_test))
  expect_true(nrow(resu_test) == length(PAM[[3]]))
})

test_that("lets.addpoly lets.classvar fine, xy = FALSE", {
  
  
  resu_test <- lets.classvar(x = pamvar[, -(1:2)], 
                             pos = (ncol(pamvar) - 2), 
                             xy = FALSE)
  
  expect_true(is.matrix(resu_test))
  expect_true(nrow(resu_test) == length(PAM[[3]]))
})


test_that("lets.addpoly lets.classvar fine, set groups", {
  
  gr <- 15
  resu_test <- lets.classvar(x = pamvar, pos = ncol(pamvar), 
                             xy = TRUE, groups = gr)
  
  expect_true(is.matrix(resu_test))
  expect_true(nrow(resu_test) == length(PAM[[3]]))
  expect_true(ncol(resu_test) == gr)
})
