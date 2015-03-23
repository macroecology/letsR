context("Test for lets.field")

data(PAM)
range <- lets.rangesize(x = PAM, units = "cell")

test_that("lets.field works fine", {
  skip_on_cran()
  
  field <- lets.field(PAM, range, PAM$S)
  
  expect_equal(class(field), "data.frame")
  expect_true(ncol(field) == 2)
  expect_true(nrow(field) == length(PAM$S))
})

test_that("lets.field works fine, weigth = FALSE", {
  skip_on_cran()
  
  field <- lets.field(PAM, range, PAM$S, weight = FALSE)
  
  expect_equal(class(field), "data.frame")
  expect_true(ncol(field) == 2)
  expect_true(nrow(field) == length(PAM$S))
})

test_that("lets.field works fine, count = TRUE", {
  skip_on_cran()
  
  field <- lets.field(PAM, range, PAM$S, count = TRUE)
  
  expect_equal(class(field), "data.frame")
  expect_true(ncol(field) == 2)
  expect_true(nrow(field) == length(PAM$S))
})

test_that("lets.field works fine, matrix and xy = TRUE", {
  skip_on_cran()
  
  field <- lets.field(PAM[[1]], range, PAM$S, xy = TRUE)
  
  expect_equal(class(field), "data.frame")
  expect_true(ncol(field) == 2)
  expect_true(nrow(field) == length(PAM$S))
})


test_that("lets.field works fine, matrix and xy = FALSE", {
  skip_on_cran()
  
  field <- lets.field(PAM[[1]][, -(1:2)], range, PAM$S, xy = FALSE)
  
  expect_equal(class(field), "data.frame")
  expect_true(ncol(field) == 2)
  expect_true(nrow(field) == length(PAM$S))
})

test_that("lets.field error expected, matrix without xy", {
  skip_on_cran()
  
  expect_error(lets.field(PAM[[1]], range, PAM$S))
})

