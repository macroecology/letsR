context("Test for lets.midpoint")

data(PAM)

test_that("lets.midpoint works fine", {
  
  
  resu_test <- lets.midpoint(PAM)
  
  expect_equal(class(resu_test), "data.frame")
  expect_true(ncol(resu_test) == 3)
  expect_true(!any(is.na(resu_test)))
})

test_that("lets.midpoint works fine, method = GM and planar = TRUE", {
  
  
  resu_test <- lets.midpoint(PAM, method = "GM", planar = TRUE)
  
  expect_equal(class(resu_test), "data.frame")
  expect_true(ncol(resu_test) == 3)
  expect_true(!any(is.na(resu_test)))
})


test_that("lets.midpoint works fine, method = GM", {
  
  
  resu_test <- lets.midpoint(PAM, method = "GM")
  
  expect_equal(class(resu_test), "data.frame")
  expect_true(ncol(resu_test) == 3)
  expect_true(!any(is.na(resu_test)))
})


test_that("lets.midpoint works fine, method = CMD", {
  
  
  resu_test <- lets.midpoint(PAM, method = "CMD")
  
  expect_equal(class(resu_test), "data.frame")
  expect_true(ncol(resu_test) == 3)
  expect_true(!any(is.na(resu_test)))
})
