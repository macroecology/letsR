# Create a presence-absence matrix based on species' point occurrences

Convert species' occurrences points into a presence-absence matrix based
on a user-defined grid.

## Usage

``` r
lets.presab.points(
  xy,
  species,
  xmn = NULL,
  xmx = NULL,
  ymn = NULL,
  ymx = NULL,
  resol = NULL,
  remove.cells = TRUE,
  remove.sp = TRUE,
  show.matrix = FALSE,
  crs = "+proj=longlat +datum=WGS84",
  count = FALSE
)
```

## Arguments

- xy:

  A matrix with geographic coordinates of species occurrences, first
  column is the longitude (or x), and the second latitude (or y).

- species:

  Character vector with species names, in the same order as the
  coordinates.

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

The function creates the presence-absence matrix based on a raster file.
Depending on the cell size, extension used and number of species it may
require a lot of memory, and may take some time to process it. Thus,
during the process, if `count` argument is set `TRUE`, a counting window
will open so you can see the progress (i.e. in what polygon the function
is working). Note that the number of polygons is not the same as the
number of species that you have (i.e. a species may have more than one
polygon/shapefiles).

## See also

[`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.shFilter`](https://brunovilela.github.io/letsR/reference/lets.shFilter.md)

## Author

Bruno Vilela & Fabricio Villalobos

## Examples

``` r
if (FALSE) { # \dontrun{
species <- c(rep("sp1", 100), rep("sp2", 100),
             rep("sp3", 100), rep("sp4", 100))
x <- runif(400, min = -69, max = -51)
y <- runif(400, min = -23, max = -4)
xy <- cbind(x, y)
PAM <- lets.presab.points(xy, species, xmn = -93, xmx = -29,
                          ymn = -57, ymx = 15)
summary(PAM)
# Species richness map
plot(PAM, xlab = "Longitude", ylab = "Latitude",
     main = "Species richness map (simulated)")

# Map of the specific species
plot(PAM, name = "sp1")
} # }

```
