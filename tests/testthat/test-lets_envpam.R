data("Phyllomedusa")
data("prec")
data("temp")

prec <- terra::unwrap(prec)
temp <- terra::unwrap(temp)

pam <- lets.presab(Phyllomedusa, remove.cells = FALSE)
envs <- lets.addvar(pam, c(temp, prec), onlyvar = TRUE)
colnames(envs) <- c("Temperature", "Preciptation")

wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
pam <- lets.pamcrop(pam, terra::vect(wrld_simpl))



# tests/testthat/test-lets.envpam.R
test_that("lets.envpam creates expected structure and plot", {
  skip_on_cran()
 
  expect_warning(res <- lets.envpam(pam, envs))
  
  expect_type(res, "list")
  expect_named(res, c("Presence_and_Absence_Matrix_env",
                      "Presence_and_Absence_Matrix_geo",
                      "Env_Richness_Raster",
                      "Geo_Richness_Raster"))
  expect_true(is.matrix(res$Presence_and_Absence_Matrix_env))
  expect_true(is.matrix(res$Presence_and_Absence_Matrix_geo))
  # Run plot silently
  expect_silent(
    lets.plot.envpam(res, geo_plot = FALSE)
  )
  
  # Test with species highlight
  expect_silent(
    lets.plot.envpam(res, species = "Phyllomedusa_atlantica", geo_plot = TRUE, world = FALSE)
  )
  # Map trait
  trait <- IUCN$Description_Year
  sp_names <- IUCN$Species
  
  res_map <- lets.maplizer.env(res, y = trait, z = sp_names)
  
  # Expectations
  expect_type(res_map, "list")
  expect_named(res_map, c("Matrix_env", "Matrix_geo", "Env_Raster", "Geo_Raster"))
  
  expect_true(is.matrix(res_map$Matrix_env))
  expect_true(is.matrix(res_map$Matrix_geo))
  
  expect_s4_class(res_map$Env_Raster, "SpatRaster")
  expect_s4_class(res_map$Geo_Raster, "SpatRaster")

})
