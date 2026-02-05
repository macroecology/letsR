# Create a presence-absence matrix of species' geographic ranges within a grid

Convert species' ranges (in shapefile format) into a presence-absence
matrix based on a user-defined grid system

## Usage

``` r
lets.presab(
  shapes,
  xmn = NULL,
  xmx = NULL,
  ymn = NULL,
  ymx = NULL,
  resol = NULL,
  remove.cells = TRUE,
  remove.sp = TRUE,
  show.matrix = FALSE,
  crs = "+proj=longlat +datum=WGS84",
  crs.grid = crs,
  cover = 0,
  presence = NULL,
  origin = NULL,
  seasonal = NULL,
  count = FALSE
)
```

## Arguments

- shapes:

  Object of class `SpatVect` or `Spatial` (see packages terra and sf to
  read these files) containing the distribution of one or more species.
  Species names should be stored in the object as BINOMIAL/binomial or
  SCINAME/sciname.

- xmn:

  Minimum longitude used to construct the grid in which the matrix will
  be based (i.e. the \[gridded\] geographic domain of interest). If
  NULL, limits will be calculated based on the limits of the shapes
  object.

- xmx:

  Maximum longitude used to construct the grid in which the matrix will
  be based (i.e. the \[gridded\] geographic domain of interest). If
  NULL, limits will be calculated based on the limits of the shapes
  object.

- ymn:

  Minimum latitude used to construct the grid in which the matrix will
  be based (i.e. the \[gridded\] geographic domain of interest). If
  NULL, limits will be calculated based on the limits of the shapes
  object.

- ymx:

  Maximum latitude used to construct the grid in which the matrix will
  be based (i.e. the \[gridded\] geographic domain of interest). If
  NULL, limits will be calculated based on the limits of the shapes
  object.

- resol:

  Numeric vector of length 1 or 2 to set the grid resolution. If NULL,
  resolution will be equivalent to 1 degree of latitude and longitude.

- remove.cells:

  Logical, if `TRUE` the final matrix will not contain cells in the grid
  with a value of zero (i.e. sites with no species present).

- remove.sp:

  Logical, if `TRUE` the final matrix will not contain species that do
  not match any cell in the grid.

- show.matrix:

  Logical, if `TRUE` only the presence-absence matrix will be returned.

- crs:

  Character representing the PROJ.4 type description of a Coordinate
  Reference System (map projection) of the polygons.

- crs.grid:

  Character representing the PROJ.4 type description of a Coordinate
  Reference System (map projection) for the grid. Note that when you
  change this options you may probably change the extent coordinates and
  the resolution.

- cover:

  Percentage of the cell covered by the shapefile that will be
  considered for presence (values between 0 and 1).

- presence:

  A vector with the code numbers for the presence type to be considered
  in the process (for IUCN spatial data
  <https://www.iucnredlist.org/resources/spatial-data-download>, see
  metadata).

- origin:

  A vector with the code numbers for the origin type to be considered in
  the process (for IUCN spatial data).

- seasonal:

  A vector with the code numbers for the seasonal type to be considered
  in the process (for IUCN spatial data).

- count:

  Logical, if `TRUE` a progress bar indicating the processing progress
  will be shown.

## Value

The result is a list object of class
[`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
with the following objects: **Presence-Absence Matrix**: A matrix of
species' presence(1) and absence(0) information. The first two columns
contain the longitude (x) and latitude (y) of the cells' centroid (from
the gridded domain used); **Richness Raster**: A raster containing
species richness data; **Species name**: A character vector with
species' names contained in the matrix. \*But see the optional argument
`show.matrix`.

## Details

This function creates the presence-absence matrix based on a raster
object. Depending on the cell size, extension used and number of species
it may require a lot of memory, and may take some time to process it.
Thus, during the process, if `count` argument is set `TRUE`, a counting
window will open to display the progress (i.e. the polygon/shapefile
that the function is working on). Note that the number of polygons is
not the same as the number of species (i.e. a species may have more than
one polygon/shapefiles).

## See also

[`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

[`lets.shFilter`](https://brunovilela.github.io/letsR/reference/lets.shFilter.md)

## Author

Bruno Vilela & Fabricio Villalobos

## Examples

``` r
if (FALSE) { # \dontrun{
# Spatial distribution polygons of South American frogs
# of genus Phyllomedusa.
data(Phyllomedusa)
PAM <- lets.presab(Phyllomedusa)
summary(PAM)
# Species richness map
plot(PAM, xlab = "Longitude", ylab = "Latitude",
     main = "Phyllomedusa species richness")
# Map of individual species
plot(PAM, name = "Phyllomedusa nordestina")
} # }

```
