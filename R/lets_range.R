#' Estimate species geographic ranges from occurrence records
#'
#' Constructs geographic range polygons from species occurrence records using
#' spatial clustering followed by buffered concave hulls. Occurrence records
#' are first grouped into spatial clusters based on pairwise geographic
#' distances. A concave hull is then generated for each cluster and spatially
#' restricted using a user-defined `sf` object.
#'
#' @param occs A data frame containing species occurrence records. It must
#'   include the columns `scientificName`, `decimalLongitude`, and
#'   `decimalLatitude`.
#' @param n_max Integer. Maximum number of occurrence records retained for
#'   each species. Species with more records are randomly subsampled.
#'   Default is `1000`.
#' @param eps_m Numeric. Maximum distance, in meters, used by DBSCAN to define
#'   spatial clusters. Default is `1000000` meters (1000 km).
#' @param min_pts Integer. Minimum number of points required to form a DBSCAN
#'   cluster. Default is `1`.
#' @param ratio Numeric between 0 and 1 controlling the concavity of the hull.
#'   A value of `1` produces a convex hull, whereas values approaching `0`
#'   produce increasingly concave hulls. Default is `0.5`.
#' @param buf Numeric. Buffer distance, in meters, applied before and after
#'   construction of the concave hull. Default is `50000`.
#' @param crop_shp An `sf` object defining the spatial feature used to restrict
#'   the estimated range polygons. Its effect depends on `intersection`.
#'   When `intersection = TRUE`, only the portion of the estimated range
#'   overlapping `crop_shp` is retained. When `intersection = FALSE`, the
#'   portion overlapping `crop_shp` is removed.
#' @param round_par Integer. Number of decimal places used to round geographic
#'   coordinates before removing duplicated records. Default is `3`.
#' @param plot_map Logical. If `TRUE`, plots `crop_shp`, the resulting range
#'   polygons, and the occurrence records for each species. Default is `TRUE`.
#' @param intersection Logical. Determines how `crop_shp` is applied to the
#'   estimated range polygons. If `TRUE`, [sf::st_intersection()] is used and
#'   only areas overlapping `crop_shp` are retained. If `FALSE`,
#'   [sf::st_difference()] is used and areas overlapping `crop_shp` are
#'   removed. Default is `TRUE`.
#'
#' @return An `sf` object containing the estimated geographic range polygons
#'   for all species in EPSG:4326, with `binomial` and integer `cluster`
#'   columns. Each surviving cluster occupies one MULTIPOLYGON row. When no
#'   polygons survive, an empty `sf` with the same columns and CRS is returned.
#'
#' @details
#' For each species, coordinates are rounded according to `round_par` and
#' duplicated records are removed. If the number of unique occurrence records
#' exceeds `n_max`, a random subset of records is retained.
#'
#' Pairwise geographic distances among occurrence records are calculated using
#' [lets.distmat()]. Records are then grouped into spatial clusters using
#' [dbscan::dbscan()]. A buffered concave hull is constructed independently
#' for each cluster using [sf::st_concave_hull()].
#' DBSCAN noise (label 0) is omitted. Buffers before and after the hull are
#' computed in a local azimuthal equidistant projection centered using the
#' circular mean longitude. This is a regional range estimator; metric
#' distortion increases for clusters extending far from their center.
#' With the default `min_pts = 1` and positive `buf`, even one unique
#' occurrence produces a buffered polygon (approximately `2 * buf` radius
#' before masking). Two-point and collinear clusters are also supported.
#' Repeated records at one location count as one occurrence after rounding.
#' Higher `min_pts` still applies: isolated points classified as noise are
#' omitted, and a mask can remove the entire buffered range.
#' With `buf = 0`, clusters with no polygonal area are omitted.
#'
#' Ranges and masks are split at the antimeridian before Cartesian overlays
#' on their longitude/latitude coordinates. These overlays follow the mapped
#' edges of the mask, rather than interpreting them as S2 great-circle arcs.
#' No distance or buffer is calculated in degrees, and the caller's S2 setting
#' is unchanged. Missing species and invalid coordinates are dropped with a
#' warning; `crop_shp` must have a known CRS.
#'
#' The resulting polygons are subsequently combined with `crop_shp`. When
#' `intersection = TRUE`, only the portion overlapping `crop_shp` is retained.
#' This can be used, for example, to restrict terrestrial species ranges to
#' land areas. When `intersection = FALSE`, the portion overlapping
#' `crop_shp` is removed. This can be used to remove land polygons from the
#' ranges of marine species.
#'
#' The choice of `eps_m`, `ratio`, and `buf` can substantially influence the
#' resulting range geometry and should reflect the spatial scale, sampling
#' properties, and biological characteristics of the study system.
#' 
#' Note that the function requires sf >= 1.0-11 and GEOS >= 3.11.0 for
#' concave hull construction.
#'
#' @seealso [lets.distmat()], [dbscan::dbscan()],
#'   [sf::st_concave_hull()], [sf::st_intersection()],
#'   [sf::st_difference()]
#'
#' @examples
#' \dontrun{
#' library(sf)
#' library(rnaturalearth)
#'
#' # Example occurrence records for a marine species
#' occs <- data.frame(
#'   scientificName = "Example_brasiliensis",
#'   decimalLongitude = c(-38.2, -37.8, -36.8, -35.5, -34.8) + 1,
#'   decimalLatitude = c(-23, -22, -10.5, -8.5, -7)
#' )
#'
#' # Land polygons used to remove terrestrial areas
#' land <- ne_countries(
#'   scale = "medium",
#'   returnclass = "sf"
#' )
#'
#' # Estimate a marine range by removing land from the range polygons
#' ranges <- lets.range(
#'   occs,
#'   crop_shp = land,
#'   intersection = FALSE,
#'   buf = 100000,
#'   eps_m = 1000000, 
#'   ratio = 1
#' )
#' }
#'
#' @export
lets.range <- function(occs,
                       n_max = 1000,
                       eps_m = 1000000,
                       min_pts = 1,
                       ratio = 0.5,
                       buf = 50000,
                       crop_shp,
                       round_par = 3,
                       plot_map = TRUE,
                       intersection = TRUE) {
  
  # Check GEOS compatibility
  .check_lets_range_geos()
  # Defensive
  required <- c("scientificName", "decimalLongitude", "decimalLatitude")
  if (!is.data.frame(occs) || !all(required %in% names(occs))) {
    stop("occs must contain scientificName, decimalLongitude and decimalLatitude.")
  }
  scalar <- function(x) is.numeric(x) && length(x) == 1L && is.finite(x)
  if (!scalar(n_max) || n_max < 1 || n_max != floor(n_max) ||
      !scalar(min_pts) || min_pts < 1 || min_pts != floor(min_pts) ||
      !scalar(eps_m) || eps_m <= 0 || !scalar(buf) || buf < 0 ||
      !scalar(ratio) || ratio < 0 || ratio > 1 ||
      !scalar(round_par) || round_par != floor(round_par)) {
    stop("Invalid clustering, buffering, rounding or subsampling parameters.")
  }
  if (!is.logical(intersection) || length(intersection) != 1L ||
      is.na(intersection) || !is.logical(plot_map) ||
      length(plot_map) != 1L || is.na(plot_map)) {
    stop("intersection and plot_map must each be TRUE or FALSE.")
  }
  if (!inherits(crop_shp, c("sf", "sfc")) || is.na(sf::st_crs(crop_shp))) {
    stop("crop_shp must be an sf or sfc object with a known CRS.")
  }
  if (!all(vapply(occs[required[-1]], is.numeric, logical(1)))) {
    stop("Occurrence longitude and latitude must be numeric.")
  }
  good <- !is.na(occs$scientificName) & nzchar(as.character(occs$scientificName)) &
    is.finite(occs$decimalLongitude) & is.finite(occs$decimalLatitude) &
    abs(occs$decimalLongitude) <= 180 & abs(occs$decimalLatitude) <= 90
  if (any(!good)) {
    warning("Removed records with missing species or invalid WGS84 coordinates.")
  }
  occs <- occs[good, required, drop = FALSE]
  occs$scientificName <- as.character(occs$scientificName)
  empty <- sf::st_sf(binomial = character(), cluster = integer(),
                     geometry = sf::st_sfc(crs = 4326))

  # Keep every polygon component, but discard empty and lower-dimensional
  # remnants (e.g. a hull touching a mask along only an edge).
  polygons <- function(x) {
    x <- sf::st_make_valid(x)
    x <- x[!sf::st_is_empty(x)]
    if (!length(x)) return(x)
    types <- as.character(sf::st_geometry_type(x))
    x <- x[types %in% c("POLYGON", "MULTIPOLYGON", "GEOMETRYCOLLECTION")]
    if (any(sf::st_geometry_type(x) == "GEOMETRYCOLLECTION")) {
      x <- sf::st_collection_extract(x, "POLYGON", warn = FALSE)
    }
    x[!sf::st_is_empty(x)]
  }
  wrap <- function(x) {
    sf::st_wrap_dateline(x, options = c("WRAPDATELINE=YES",
                                        "DATELINEOFFSET=180"), quiet = TRUE)
  }

  # Repair the mask in its native Cartesian representation before wrapping.
  # After splitting at +/-180, GEOS overlays on the longitude/latitude plane
  # follow the mask's mapped edges, including global land and coastline holes.
  # No metric distances/buffers are computed in this plane. Using geometry
  # only also avoids duplicated rows and attribute collisions from the mask.
  mask <- sf::st_geometry(crop_shp)
  mask_crs <- sf::st_crs(mask)
  mask <- polygons(sf::st_set_crs(mask, NA))
  mask <- sf::st_transform(sf::st_set_crs(mask, mask_crs), 4326)
  # Already-split global masks need no wrapping. In particular, Antarctica's
  # legitimate world-width edge at the pole must not be treated as a seam
  # crossing by GDAL. Inspect individual rings, not a feature's bounding box.
  mask <- sf::st_cast(sf::st_cast(mask, "MULTIPOLYGON"), "POLYGON")
  needs_wrap <- vapply(mask, function(p) {
    any(vapply(p, function(ring) {
      lon <- ring[, 1]
      lat <- ring[, 2]
      any(lon < -180 - 1e-8 | lon > 180 + 1e-8) ||
        any(abs(diff(lon)) > 180 &
              pmin(abs(head(lat, -1)), abs(tail(lat, -1))) < 89.999999)
    }, logical(1)))
  }, logical(1))
  if (any(needs_wrap)) mask[needs_wrap] <- wrap(mask[needs_wrap])
  mask <- polygons(sf::st_set_crs(mask, NA))
  mask <- sf::st_union(mask)
  if (!nrow(occs)) return(empty)

  shps <- list()
  spp <- unique(occs$scientificName)
  for (i in seq_along(spp)) {
    occ_i <- unique(round(occs[occs$scientificName == spp[i], required[-1],
                              drop = FALSE], round_par))
    # +180 and -180 identify the same meridian, including duplicate records.
    occ_i$decimalLongitude <- (occ_i$decimalLongitude + 180) %% 360 - 180
    occ_i <- unique(occ_i)
    if (nrow(occ_i) > n_max) {
      occ_i <- occ_i[sample.int(nrow(occ_i), n_max), , drop = FALSE]
    }

    # Pass a dist object: a numeric distance matrix would instead be treated
    # as feature coordinates by dbscan. lets.distmat() uses geodesic meters.
    if (nrow(occ_i) == 1L) {
      clusters <- if (min_pts == 1L) 1L else 0L
    } else {
      D <- letsR::lets.distmat(as.matrix(occ_i))
      clusters <- dbscan::dbscan(stats::as.dist(D), eps = eps_m,
                                minPts = min_pts)$cluster
    }
    points_i <- sf::st_as_sf(occ_i, coords = required[-1], crs = 4326)
    species_shps <- list()
    # DBSCAN label 0 denotes noise, never one shared spatial cluster.
    for (cl_i in sort(unique(clusters[clusters > 0L]))) {
      pts <- points_i[clusters == cl_i, ]
      coords <- sf::st_coordinates(pts)
      lon_rad <- coords[, 1] * pi / 180
      lon0 <- atan2(mean(sin(lon_rad)), mean(cos(lon_rad))) * 180 / pi
      lat0 <- mean(coords[, 2])
      local_crs <- paste0("+proj=aeqd +lat_0=", lat0, " +lon_0=", lon0,
                          " +datum=WGS84 +units=m +no_defs")
      pts_proj <- sf::st_transform(sf::st_geometry(pts), local_crs)
      if (any(!is.finite(sf::st_coordinates(pts_proj)))) {
        stop("Cluster cannot be represented in its local metric projection: ",
             spp[i], " (cluster ", cl_i, ").")
      }

      # Preserve buffer -> concave hull -> buffer in meters. The first buffer
      # also gives singleton/two-point/collinear clusters a polygonal footprint.
      hull <- sf::st_union(pts_proj)
      if (buf > 0) hull <- sf::st_buffer(hull, dist = buf)
      hull <- sf::st_concave_hull(hull, ratio = ratio)
      if (buf > 0) hull <- sf::st_buffer(hull, dist = buf)
      hull <- polygons(hull)
      if (!length(hull)) next
      # Densify projected edges before inverse projection, so wrapping does
      # not interpolate a long curved geographic edge from just its endpoints.
      hull <- sf::st_segmentize(hull, dfMaxLength = 10000)
      hull <- wrap(sf::st_transform(hull, 4326))
      # Always wrap: a buffer can cross the seam even when no input point does.
      hull <- polygons(sf::st_set_crs(hull, NA))
      if (length(mask) && !all(sf::st_is_empty(mask))) {
        hull <- if (intersection) sf::st_intersection(hull, mask) else
          sf::st_difference(hull, mask)
      } else if (intersection) {
        next
      }
      hull <- polygons(hull)
      if (!length(hull)) next
      # One MULTIPOLYGON per surviving cluster, retaining all islands/fragments.
      hull <- sf::st_cast(sf::st_union(hull), "MULTIPOLYGON")
      result <- sf::st_sf(binomial = spp[i], cluster = as.integer(cl_i),
                          geometry = sf::st_set_crs(hull, 4326))
      species_shps[[length(species_shps) + 1L]] <- result
      shps[[length(shps) + 1L]] <- result
    }
    if (plot_map) {
      if (length(mask) && !all(sf::st_is_empty(mask))) {
        plot(sf::st_set_crs(mask, 4326), col = "gray90", main = spp[i])
      } else {
        plot(sf::st_geometry(points_i), pch = 20, col = "blue", main = spp[i])
      }
      if (length(species_shps)) {
        plot(sf::st_geometry(do.call(rbind, species_shps)),
             col = "gray", add = TRUE)
      }
      plot(sf::st_geometry(points_i), pch = 20, col = "blue", add = TRUE)
    }
  }
  if (!length(shps)) return(empty)
  do.call(rbind, shps)
}


# Check rgeos version
.check_lets_range_geos <- function(
    version = sf::sf_extSoftVersion()[["GEOS"]]) {
  
  if (length(version) != 1L ||
      is.na(version) ||
      !grepl("^[0-9]+\\.[0-9]+\\.[0-9]+", version)) {
    stop(
      "Cannot determine GEOS version. ",
      "lets.range() requires GEOS >= 3.11.0.",
      call. = FALSE
    )
  }
  
  version_num <- sub(
    "^([0-9]+\\.[0-9]+\\.[0-9]+).*",
    "\\1",
    version
  )
  
  if (utils::compareVersion(version_num, "3.11.0") < 0L) {
    stop(
      "lets.range() requires GEOS >= 3.11.0. ",
      "Current version: ", version,
      call. = FALSE
    )
  }
  
  invisible(TRUE)
}