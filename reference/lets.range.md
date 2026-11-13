# Estimate species geographic ranges from occurrence records

Constructs geographic range polygons from species occurrence records
using spatial clustering followed by buffered concave hulls. Occurrence
records are first grouped into spatial clusters based on pairwise
geographic distances. A concave hull is then generated for each cluster
and spatially restricted using a user-defined \`sf\` object.

## Usage

``` r
lets.range(
  occs,
  n_max = 1000,
  eps_m = 1e+06,
  min_pts = 1,
  ratio = 0.5,
  buf = 50000,
  crop_shp,
  round_par = 3,
  plot_map = TRUE,
  intersection = TRUE
)
```

## Arguments

- occs:

  A data frame containing species occurrence records. It must include
  the columns \`scientificName\`, \`decimalLongitude\`, and
  \`decimalLatitude\`.

- n_max:

  Integer. Maximum number of occurrence records retained for each
  species. Species with more records are randomly subsampled. Default is
  \`1000\`.

- eps_m:

  Numeric. Maximum distance, in meters, used by DBSCAN to define spatial
  clusters. Default is \`1000000\` meters (1000 km).

- min_pts:

  Integer. Minimum number of points required to form a DBSCAN cluster.
  Default is \`1\`.

- ratio:

  Numeric between 0 and 1 controlling the concavity of the hull. A value
  of \`1\` produces a convex hull, whereas values approaching \`0\`
  produce increasingly concave hulls. Default is \`0.5\`.

- buf:

  Numeric. Buffer distance, in meters, applied before and after
  construction of the concave hull. Default is \`50000\`.

- crop_shp:

  An \`sf\` object defining the spatial feature used to restrict the
  estimated range polygons. Its effect depends on \`intersection\`. When
  \`intersection = TRUE\`, only the portion of the estimated range
  overlapping \`crop_shp\` is retained. When \`intersection = FALSE\`,
  the portion overlapping \`crop_shp\` is removed.

- round_par:

  Integer. Number of decimal places used to round geographic coordinates
  before removing duplicated records. Default is \`3\`.

- plot_map:

  Logical. If \`TRUE\`, plots \`crop_shp\`, the resulting range
  polygons, and the occurrence records for each species. Default is
  \`TRUE\`.

- intersection:

  Logical. Determines how \`crop_shp\` is applied to the estimated range
  polygons. If \`TRUE\`, \[sf::st_intersection()\] is used and only
  areas overlapping \`crop_shp\` are retained. If \`FALSE\`,
  \[sf::st_difference()\] is used and areas overlapping \`crop_shp\` are
  removed. Default is \`TRUE\`.

## Value

An \`sf\` object containing the estimated geographic range polygons for
all species in EPSG:4326, with \`binomial\` and integer \`cluster\`
columns. Each surviving cluster occupies one MULTIPOLYGON row. When no
polygons survive, an empty \`sf\` with the same columns and CRS is
returned.

## Details

For each species, coordinates are rounded according to \`round_par\` and
duplicated records are removed. If the number of unique occurrence
records exceeds \`n_max\`, a random subset of records is retained.

Pairwise geographic distances among occurrence records are calculated
using \[lets.distmat()\]. Records are then grouped into spatial clusters
using \[dbscan::dbscan()\]. A buffered concave hull is constructed
independently for each cluster using \[sf::st_concave_hull()\]. DBSCAN
noise (label 0) is omitted. Buffers before and after the hull are
computed in a local azimuthal equidistant projection centered using the
circular mean longitude. This is a regional range estimator; metric
distortion increases for clusters extending far from their center. With
the default \`min_pts = 1\` and positive \`buf\`, even one unique
occurrence produces a buffered polygon (approximately \`2 \* buf\`
radius before masking). Two-point and collinear clusters are also
supported. Repeated records at one location count as one occurrence
after rounding. Higher \`min_pts\` still applies: isolated points
classified as noise are omitted, and a mask can remove the entire
buffered range. With \`buf = 0\`, clusters with no polygonal area are
omitted.

Ranges and masks are split at the antimeridian before Cartesian overlays
on their longitude/latitude coordinates. These overlays follow the
mapped edges of the mask, rather than interpreting them as S2
great-circle arcs. No distance or buffer is calculated in degrees, and
the caller's S2 setting is unchanged. Missing species and invalid
coordinates are dropped with a warning; \`crop_shp\` must have a known
CRS.

The resulting polygons are subsequently combined with \`crop_shp\`. When
\`intersection = TRUE\`, only the portion overlapping \`crop_shp\` is
retained. This can be used, for example, to restrict terrestrial species
ranges to land areas. When \`intersection = FALSE\`, the portion
overlapping \`crop_shp\` is removed. This can be used to remove land
polygons from the ranges of marine species.

The choice of \`eps_m\`, \`ratio\`, and \`buf\` can substantially
influence the resulting range geometry and should reflect the spatial
scale, sampling properties, and biological characteristics of the study
system.

Note that the function requires sf \>= 1.0-11 and GEOS \>= 3.11.0 for
concave hull construction.

## See also

\[lets.distmat()\], \[dbscan::dbscan()\], \[sf::st_concave_hull()\],
\[sf::st_intersection()\], \[sf::st_difference()\]

## Examples

``` r
if (FALSE) { # \dontrun{
library(sf)
library(rnaturalearth)

# Example occurrence records for a marine species
occs <- data.frame(
  scientificName = "Example_brasiliensis",
  decimalLongitude = c(-38.2, -37.8, -36.8, -35.5, -34.8) + 1,
  decimalLatitude = c(-23, -22, -10.5, -8.5, -7)
)

# Land polygons used to remove terrestrial areas
land <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

# Estimate a marine range by removing land from the range polygons
ranges <- lets.range(
  occs,
  crop_shp = land,
  intersection = FALSE,
  buf = 100000,
  eps_m = 1000000, 
  ratio = 1
)
} # }
```
