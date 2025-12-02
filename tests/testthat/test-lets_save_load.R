context("Tests for lets.save and lets.load")

test_that("lets.save and lets.load work correctly", {
  
  Species <- paste0("sp", 1:3)
  PAM_matrix <- data.frame(
    x = 1:3,
    y = 4:6,
    sp1 = c(1,0,1),
    sp2 = c(0,1,1),
    sp3 = c(1,1,0)
  )
  class(PAM_matrix) <- c("PresenceAbsence", "data.frame")
  
  r <- rast(nrows=3, ncols=1)
  values(r) <- 1:3
  
  PAM <- list(
    PAM_attribute = PAM_matrix,
    PAM_geo = PAM_matrix,
    PAM_env = PAM_matrix,
    Richness_Raster = r
  )
  class(PAM) <- "PresenceAbsence"
  
  tmp_file <- tempfile(fileext = ".RData")
  lets.save(PAM, file = tmp_file)
  
  PAM_loaded <- lets.load(tmp_file)

  expect_s3_class(PAM_loaded, "PresenceAbsence")
  expect_type(PAM_loaded, "list")
  expect_true(all(c("PAM_attribute", "PAM_geo", "PAM_env", "Richness_Raster") %in% names(PAM_loaded)))
  expect_true(inherits(PAM_loaded$Richness_Raster, "SpatRaster"))
  expect_equal(values(PAM_loaded$Richness_Raster), values(r))
  expect_equal(PAM_loaded$PAM_attribute, PAM_matrix)
})
