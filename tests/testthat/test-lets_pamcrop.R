context("Test for lets.pamcrop")
data(Brazil)
data(PAM)

test_that(".letspamcrop works fine, remove.sp = TRUE", {
  skip_on_cran()
  
  resu_test <- lets.pamcrop(PAM, Brazil, remove.sp = TRUE)
  
  expect_equal(class(resu_test), "PresenceAbsence")
  expect_equal(class(resu_test[[1]]), "matrix")
  expect_true(inherits(resu_test[[2]], "RasterLayer"))
  expect_equal(class(resu_test[[3]]), "character")
  
  response <- summary(resu_test)
  expect_true(response$Specieswithoutanypresence == 0)
  
})


test_that(".letspamcrop works fine, remove.sp = FALSE", {
  skip_on_cran()
  
  resu_test <- lets.pamcrop(PAM, Brazil, remove.sp = FALSE)
  
  expect_equal(class(resu_test), "PresenceAbsence")
  expect_equal(class(resu_test[[1]]), "matrix")
  expect_true(inherits(resu_test[[2]], "RasterLayer"))
  expect_equal(class(resu_test[[3]]), "character")
  
  response <- summary(resu_test)
  expect_true(response$Specieswithoutanypresence > 0)
  
})
