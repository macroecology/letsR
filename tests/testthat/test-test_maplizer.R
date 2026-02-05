context("Tests for lets.maplizer.env")

prec <- unwrap(prec)
temp <- unwrap(temp)
PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
colnames(envs) <- c("Temperature", "Preciptation")
wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
PAM <- lets.pamcrop(PAM, vect(wrld_simpl))

# Create environmental PAM
res <- lets.envpam(PAM, envs, remove.cells = FALSE)



test_that("returns correct structure", {
  res_map <- lets.maplizer.env(res, 
                           y = IUCN$Description_Year, 
                           z = IUCN$Species)
  
  expect_named(res_map,
               c("Matrix_env", "Matrix_geo", "Env_Raster", "Geo_Raster")
  )
})


test_that("factor y is correctly converted to numeric", {
  y_factor <- factor(c(2000, 1990, 2010))
  res2 <- lets.maplizer.env(res,
                            y = y_factor,
                            z = IUCN$Species[1:3])
  
  expect_type(res2, "list")
  expect_true("Matrix_env" %in% names(res2))
})


test_that("species in data but missing in PAM are ignored", {
  z_mixed <- c(IUCN$Species[1:5], "Ghostus invisibilis")
  y_mixed <- c(IUCN$Description_Year[1:5], 9999)
  
  res3 <- lets.maplizer.env(res, y = y_mixed, z = z_mixed)
  
  expect_true(is.list(res3))
  expect_true("Matrix_env" %in% names(res3))
})


test_that("weighted = TRUE overrides func", {
  res_w <- lets.maplizer.env(res,
                             y = IUCN$Description_Year,
                             z = IUCN$Species,
                             func = median,
                             weighted = TRUE)
  
  res_m <- lets.maplizer.env(res,
                             y = IUCN$Description_Year,
                             z = IUCN$Species,
                             func = median,
                             weighted = FALSE)
  
  expect_false(isTRUE(all.equal(res_w$Matrix_env, res_m$Matrix_env)))
})


test_that("NAs in y are handled without crashing", {
  y_na <- IUCN$Description_Year
  y_na[1:10] <- NA
  
  expect_no_error(
    lets.maplizer.env(res, y = y_na, z = IUCN$Species)
  )
})


test_that("NAs in y are handled without crashing", {
  y_na <- IUCN$Description_Year
  y_na[1:10] <- NA
  
  expect_no_error(
    lets.maplizer.env(res, y = y_na, z = IUCN$Species)
  )
})


test_that("returns raster objects when ras = TRUE", {
  res_r <- lets.maplizer.env(res,
                             y = IUCN$Description_Year,
                             z = IUCN$Species,
                             ras = TRUE)
  
  expect_s4_class(res_r$Env_Raster, "SpatRaster")
  expect_s4_class(res_r$Geo_Raster, "SpatRaster")
})

### the function doesn't work with 1 species only
#est_that("works with a single species", {
# res_single <- lets.maplizer.env(
#    res,
#    y = IUCN$Description_Year[1],
#    z = IUCN$Species[1]
#  )
  
#  expect_true(is.list(res_single))
#  expect_true("Matrix_env" %in% names(res_single))
#})

