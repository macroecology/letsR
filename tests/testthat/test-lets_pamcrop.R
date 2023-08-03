context("Test for lets.pamcrop")

data(wrld_simpl)  # World map
Brazil <- wrld_simpl[wrld_simpl$NAME == "Brazil", ]  # Brazil (polygon)
data(PAM)

test_that("lets.pamcrop works fine, remove.sp = TRUE", {
  
  
  resu_test <- lets.pamcrop(PAM, Brazil, remove.sp = TRUE)
  
  expect_equal(class(resu_test)[1], "PresenceAbsence")
  expect_equal(class(resu_test[[1]])[1], "matrix")
  expect_true(inherits(resu_test[[2]], "RasterLayer"))
  expect_equal(class(resu_test[[3]])[1], "character")
  
  response <- summary(resu_test)
  expect_true(response$Specieswithoutanypresence == 0)
  
})


test_that("lets.pamcrop works fine, remove.sp = FALSE", {
  
  
  resu_test <- lets.pamcrop(PAM, Brazil, remove.sp = FALSE)
  
  expect_equal(class(resu_test)[1], "PresenceAbsence")
  expect_equal(class(resu_test[[1]])[1], "matrix")
  expect_true(inherits(resu_test[[2]], "RasterLayer"))
  expect_equal(class(resu_test[[3]])[1], "character")
  
  response <- summary(resu_test)
  expect_true(response$Specieswithoutanypresence > 0)
  
})
