context("Tests for lets.maplizer.env")

data("Phyllomedusa")
data("prec")
data("temp")
data("IUCN")

prec <- unwrap(prec)
temp <- unwrap(temp)


test_that("lets.maplizer.env works with real PresenceAbsence object", {
  
  PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
  expect_warning(
    envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE),
    "Reprojecting y to match the projection in x"
  )
  colnames(envs) <- c("Temperature", "Precipitation")
  
  wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
  PAM <- lets.pamcrop(PAM, vect(wrld_simpl))
  
  expect_warning(
    res <- lets.envpam(PAM, envs, remove.cells = FALSE),
    "Some environmental data have NA values, these data will be excluded."
  )
  
  res_map <- lets.maplizer.env(res, y = IUCN$Description_Year, z = IUCN$Species)
  
  expect_type(res_map, "list")
  expect_named(res_map, c("Matrix_env", "Matrix_geo", "Env_Raster", "Geo_Raster"))
  
  expect_true(is.matrix(res_map$Matrix_env))
  expect_true(is.matrix(res_map$Matrix_geo))
  
  expect_gt(nrow(res_map$Matrix_env), 0)
  expect_gt(nrow(res_map$Matrix_geo), 0)
  
  expect_true(is.numeric(res_map$Matrix_env[,1]))
  expect_true(is.numeric(res_map$Matrix_env[,2]))
  expect_true(is.numeric(res_map$Matrix_geo[,1]))
  expect_true(is.numeric(res_map$Matrix_geo[,2]))
  
  expect_true(inherits(res_map$Env_Raster, "SpatRaster"))
  expect_true(inherits(res_map$Geo_Raster, "SpatRaster"))
})


  
  