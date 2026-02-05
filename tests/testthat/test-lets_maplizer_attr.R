context("Tests for lets.maplizer.attr")

pam_mat <- data.frame(
  cell = 1:4,
  x = c(0,1,0,1),
  y = c(0,0,1,1),

  sp1 = c(1,1,0,1),
  sp2 = c(0,1,1,1),
  sp3 = c(1,0,1,1)
)

r <- terra::rast(nrows = 2, ncols = 2, vals = NA)
values(r) <- 1:4
x <- list(Presence_and_Absence_Matrix = pam_mat, raster = r)



test_that("correct structure", {
  y <- c(1, 2, 3)
  res <- lets.maplizer.attr(x = x, y = y, z = colnames(pam_mat)[4:6])
  
  expect_type(res, "list")
  expect_named(res, c("Matrix_attr", "Attr_Raster"))
})


test_that("summary functions behave correctly", {
  y <- c(1,2,3)
  z <- colnames(pam_mat)[-(1:3)]
  
  res_mean   <- lets.maplizer.attr(x = x, y = y, z = z, func = mean)
  res_median <- lets.maplizer.attr(x = x, y = y, z = z, func = median)
  res_sum    <- lets.maplizer.attr(x = x, y = y, z = z, func = sum)
  
  expect_false(identical(res_mean$Matrix_attr$Variable_func,
                         res_sum$Matrix_attr$Variable_func))
})


test_that("weighted option overrides func", {
  y <- c(1,2,3)
  z <- colnames(pam_mat)[-(1:3)]
  
  res1 <- lets.maplizer.attr(x = x, y = y, z = z, func = sum, weighted = TRUE)
  res2 <- lets.maplizer.attr(x = x, y = y, z = z, func = mean, weighted = TRUE)
  
  expect_equal(res1, res2)
})



pam_mat$sp1[1] <- 0
pam_mat$sp3[1] <- 0

test_that("empty cells return NA", {
  x2 <- x
  x2$Presence_and_Absence_Matrix <- pam_mat
  
  res <- lets.maplizer.attr(x = x2, y = x2$Presence_and_Absence_Matrix$cell,
                            z = colnames(pam_mat)[4:6])
  expect_true(is.na(res$Matrix_attr$Variable_func[1]))
})

