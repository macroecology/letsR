context("Tests for lets.summarize.cells")

mock_summary_data <- function() {
  x <- list(
    data.frame(
      cell_id = 1:5,
      axis1 = rnorm(5),
      axis2 = rnorm(5),
      sp1 = c(1,0,1,0,1),
      sp2 = c(0,1,0,1,0),
      sp3 = c(1,1,0,0,1)
    )
  )
  y <- data.frame(
    cell_id = 1:5,
    desc1 = c(10, 20, 30, 40, 50),
    desc2 = c(5, 4, 3, 2, 1)
  )
  
  list(x = x, y = y)
}


test_that("lets.summaryze.cells runs with minimal data", {
  data <- mock_summary_data()
  expect_silent(res <- lets.summaryze.cells(data$x, data$y))
  expect_s3_class(res, "data.frame")
})


test_that("lets.summaryze.cells returns correct dimensions", {
  data <- mock_summary_data()
  res <- lets.summaryze.cells(data$x, data$y)
  expect_equal(nrow(res), 3)            
  expect_equal(ncol(res), 3)            
})


test_that("lets.summaryze.cells aggregates correctly with mean", {
  data <- mock_summary_data()
  res <- lets.summaryze.cells(data$x, data$y, func = mean)
  
  expect_equal(res$desc1[res$Species=="sp1"], 30)
  expect_equal(res$desc2[res$Species=="sp2"], 3)
})


test_that("lets.summaryze.cells aggregates correctly with sum", {
  data <- mock_summary_data()
  res <- lets.summaryze.cells(data$x, data$y, func = sum)
  
  expect_equal(res$desc1[res$Species=="sp3"], 80)
})


