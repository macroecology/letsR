context("Test for general methods")

# Path
data(PAM)

test_that("Summary and print PresenceAbsence object", {
  expect_output(print(PAM))
  expect_output(print(summary(PAM)))

})


test_that("plot object", {
  
  expect_no_error(plot(PAM))
  expect_no_error(plot(PAM, name = "Phyllomedusa atelopoides"))
  expect_no_error(plot(PAM, world = FALSE))
  expect_no_error(plot(PAM, col_rich = rainbow))
  
})
