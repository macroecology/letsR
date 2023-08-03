# Defensive codes for letsR functions
.check_shape <- function(shape) {
  sf_check <-  inherits(shape, "sf")
  spatial_check <- inherits(shape, "Spatial")
  sp_check <-  inherits(shape, "SpatialPolygonsDataFrame")
  if (sp_check | spatial_check | sf_check) {
    shape <- terra::vect(shape)
  }
  terra_check <- inherits(shape, "SpatVector") & 
    terra::geomtype(shape) == "polygons"
  if (!terra_check) {
    stop("all shapefiles provided should be a SpatVector object.")
  }
  return(shape)
}

# Check PAM
.check_pam <- function(x) {
  x[[2]] <- terra::unwrap(x[[2]])
  if (inherits(x[[2]], "RasterLayer")) {
    x[[2]] <- terra::rast(x[[2]])
  }
  return(x)
}
