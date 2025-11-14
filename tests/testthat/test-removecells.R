context("Test for .removeCells")

test_that(".removeCells behaves correctly under different scenarios", {

  m_test <- rbind(c(0, 0, 0, 0),  
                  c(1, 5, 0, 5))  
  
  result <- .removeCells(m_test)
  expect_true(all(dim(result) == c(1, 4)))

  m_all_zero <- rbind(c(0, 0, 0, 0),
                      c(0, 0, 0, 0))
  expect_error(
    .removeCells(m_all_zero),
    "No cells left after removing cells without occurrences"
  )
  
 
  m_no_zero <- rbind(c(1, 0, 1, 0),
                     c(0, 1, 0, 1))
  expect_true(all(dim(.removeCells(m_no_zero)) == c(2, 4)))
})
