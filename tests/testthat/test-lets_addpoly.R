context("Test for lets.addpoly")

data(wrld_simpl)  # World map
Brazil <- wrld_simpl[wrld_simpl$NAME == "Brazil", ]  # Brazil (polygon)
data(PAM)

test_that("lets.addpoly works fine, onlyvar = FALSE", {
  
  resu_test <- lets.addpoly(PAM, Brazil, "NAME", onlyvar = FALSE)
  expect_true(is.matrix(resu_test))
  expect_true(ncol(resu_test) > 1)
})

test_that("lets.addpoly works fine, onlyvar = TRUE", {
  
  resu_test <- lets.addpoly(PAM, Brazil, "NAME", onlyvar = TRUE)
  expect_true(is.matrix(resu_test))
  expect_true(ncol(resu_test) == 1)
})

