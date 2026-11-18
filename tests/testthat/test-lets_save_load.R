
context("Tests for lets.save and lets.load")

test_that("lets.save and lets.load preserve different letsR objects", {
  
  # Create example matrices
  PAM_matrix <- cbind(
    Cell = 1:3,
    sp1 = c(1, 0, 1),
    sp2 = c(0, 1, 1),
    sp3 = c(1, 1, 0)
  )
  
  env_matrix <- cbind(
    Cell_env = 1:3,
    Temperature = c(20, 25, 30),
    Precipitation = c(100, 200, 300),
    PAM_matrix[, -1]
  )
  
  geo_matrix <- cbind(
    Cell_env = 1:3,
    Cell_geo = 1:3,
    `Longitude(x)` = c(-40, -41, -42),
    `Latitude(y)` = c(-10, -11, -12),
    PAM_matrix[, -1]
  )
  
  attr_matrix <- cbind(
    Cell_attr = 1:3,
    trait_a = c(0.2, 0.5, 0.8),
    PAM_matrix[, -1]
  )
  
  # Create example rasters
  r <- terra::rast(nrows = 3, ncols = 1)
  terra::values(r) <- 1:3
  
  r_env <- terra::rast(r)
  terra::values(r_env) <- 4:6
  
  r_attr <- terra::rast(r)
  terra::values(r_attr) <- 7:9
  
  # Create objects matching letsR output structures
  PAM <- list(
    Presence_and_Absence_Matrix = PAM_matrix,
    Richness_Raster = r
  )
  class(PAM) <- "PresenceAbsence"
  
  envpam <- list(
    Presence_and_Absence_Matrix_env = env_matrix,
    Presence_and_Absence_Matrix_geo = geo_matrix,
    Env_Richness_Raster = r_env,
    Geo_Richness_Raster = r
  )
  
  attpam <- list(
    PAM_attribute = attr_matrix,
    Attr_Richness_Raster = r_attr
  )
  
  # Test all object types
  objects <- list(
    PAM = PAM,
    envpam = envpam,
    attpam = attpam
  )
  
  for (obj_name in names(objects)) {
    
    original <- objects[[obj_name]]
    tmp_file <- tempfile(fileext = ".RData")
    
    # Save and load
    lets.save(original, file = tmp_file)
    loaded <- lets.load(tmp_file)
    
    # Check general structure
    expect_identical(class(loaded), class(original))
    expect_identical(names(loaded), names(original))
    expect_type(loaded, "list")
    
    # Check individual components
    for (component in names(original)) {
      
      x <- original[[component]]
      y <- loaded[[component]]
      
      if (inherits(x, "SpatRaster")) {
        
        expect_true(inherits(y, "SpatRaster"))
        expect_equal(terra::values(y), terra::values(x))
        expect_equal(terra::ext(y), terra::ext(x))
        expect_equal(terra::res(y), terra::res(x))
        expect_equal(terra::crs(y), terra::crs(x))
        
      } else {
        
        expect_equal(y, x)
        
      }
    }
    
    # Check that the original object was not modified
    raster_names <- names(original)[vapply(
      original, inherits, logical(1), "SpatRaster"
    )]
    
    for (nm in raster_names) {
      expect_true(inherits(original[[nm]], "SpatRaster"))
    }
    
    unlink(tmp_file)
  }
})
