context("Tests for lets.attrpam")


set.seed(42)

n <- 10
Species <- paste0("sp", 1:n)
trait_a <- rnorm(n)
trait_b <- trait_a * 0.2 + rnorm(n)
x <- data.frame(Species, trait_a, trait_b)


test_that("lets.attrpam returns correct output structure", {
  res <- lets.attrpam(x, n_bins = 30)
  
  expect_type(res, "list")
  expect_named(res, c("PAM_attribute", "Attr_Richness_Raster"))
  expect_true(is.matrix(res$PAM_attribute))
  expect_s4_class(res$Attr_Richness_Raster, "SpatRaster")
  
  presabs <- as.numeric(res$PAM_attribute[, -(1:3)])
  expect_true(all(presabs %in% c(0, 1, NA)))
})


test_that("lets.attrpam works consistently with different n_bins", {
  for (nb in c(5, 10, 50)) {
    res <- lets.attrpam(x, n_bins = nb, remove.cells = FALSE)

    n_cells_raster <- nrow(res$Attr_Richness_Raster) * 
      ncol(res$Attr_Richness_Raster)
    expect_equal(n_cells_raster, nrow(res$PAM_attribute))
  }
})


test_that("lets.attrpam warns when trait data contain NAs", {
  x_na <- x
  x_na$trait_a[sample(nrow(x_na), 2)] <- NA
  expect_warning(lets.attrpam(x_na, n_bins = 30))
})


test_that("lets.attrpam throws error when first column is not character", {
  x_num <- data.frame(Species = 1:2000,
                      trait_a = rnorm(2000),
                      trait_b = rnorm(2000))
  expect_error(lets.attrpam(x_num, n_bins = 10),
               "first column.*character")
})


test_that("lets.attrpam removes empty cells when remove.cells = TRUE", {

  res_true  <- lets.attrpam(x, n_bins = 5, remove.cells = TRUE)
  res_false <- lets.attrpam(x, n_bins = 5, remove.cells = FALSE)
  
  expect_lt(nrow(res_true$PAM_attribute), nrow(res_false$PAM_attribute))
  expect_true(nrow(res_true$PAM_attribute) > 0)
})


test_that("lets.attrpam removes species with no occurrences (remove.sp = TRUE)", 
          {
            n <- 100
            Species <- rep(paste0("sp", 1:4), each = 25)
            trait_a <- rnorm(n)
            trait_b <- rnorm(n)
            x <- data.frame(Species, trait_a, trait_b)
            res <- lets.attrpam(x, n_bins = 10, remove.sp = FALSE)
            res$PAM_attribute <- cbind(res$PAM_attribute, sp_zero = 0)
            pam_removed <- .removeSp(res$PAM_attribute)
            expect_false("sp_zero" %in% colnames(pam_removed))
            expect_true(all(paste0("sp", 1:4) %in% colnames(pam_removed)))
            })


test_that("lets.attrpam with remove.sp = TRUE actually removes all-zero species 
          internally", {
            n <- 100
            Species <- rep(paste0("sp", 1:4), each = 25)
            trait_a <- rnorm(n)
            trait_b <- rnorm(n)
            x <- data.frame(Species, trait_a, trait_b)
            x_extra <- rbind(x, data.frame(Species = "sp_zero", trait_a = NA, 
                                           trait_b = NA))
            res <- suppressWarnings(lets.attrpam(x_extra, n_bins = 10, 
                                                 remove.sp = TRUE))
            expect_false("sp_zero" %in% colnames(res$PAM_attribute))
            })

