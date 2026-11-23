context("Test for lets.gridirizer")
data(PAM)

test_that("lets.gridirizer works fine", {
  
  
  resu_test <- lets.gridirizer(PAM)
  
  expect_equal(class(resu_test)[1], "list")
  expect_true(inherits(resu_test[[1]], "SpatVector"))
  expect_equal(class(resu_test[[2]])[1], "data.frame")
    
})
