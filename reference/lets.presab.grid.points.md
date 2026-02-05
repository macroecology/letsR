# Create a presence-absence matrix based on species' point occurrences within a user's grid shapefile (beta version)

Convert species' occurrences points into a presence-absence matrix based
on a grid in shapefile format.

## Usage

``` r
lets.presab.grid.points(
  xy,
  species,
  grid,
  sample.unit,
  remove.sp = TRUE,
  abundance = TRUE
)
```

## Arguments

- xy:

  A matrix with geographic coordinates of species occurrences, first
  column is the longitude (or x), and the second latitude (or y).

- species:

  Character vector with species names, in the same order as the
  coordinates.

- grid:

  Object of class SpatVector (see function
  [`terra::vect`](https://rspatial.github.io/terra/reference/vect.html))
  representing the spatial grid (e.g. regular/irregular cells, political
  divisions, hexagonal grids, etc). The grid and the shapefiles must be
  in the same projection.

- sample.unit:

  Object of class `character` with the name of the column (in the grid)
  representing the sample units of the presence absence matrix.

- remove.sp:

  Logical, if `TRUE` the final matrix will not contain species that do
  not match any cell in the grid.

- abundance:

  Logical. If TRUE, the resulting matrix will display number of
  occurrences per species in each cell. If FALSE, the resulting matrix
  will show presence-absence values.

## Value

The result is a `list` containing two objects:

\(I\) A matrix the species presence (1) and absence (0) values per
sample unity.

\(II\) The original grid.

## Details

This function is an alternative way to create a presence absence matrix
when users already have their own grid.

## See also

[`lets.presab.points`](https://brunovilela.github.io/letsR/reference/lets.presab.points.md)

[`lets.presab.grid`](https://brunovilela.github.io/letsR/reference/lets.presab.grid.md)

## Author

Bruno Vilela & Fabricio Villalobos

## Examples

``` r
if (FALSE) { # \dontrun{
# Species polygons
data("wrld_simpl")

# Grid
crs = "+proj=longlat +datum=WGS84 +no_defs"
sp.r <- terra::as.polygons(terra::rast(
  resol = 5,
  crs = crs,
  xmin = -93,
  xmax = -29,
  ymin = -57,
  ymax = 15
))
sp.r$ID <- 1:length(sp.r)

# Occurrence Points
N = 20
species <- c(rep("sp1", N), rep("sp2", N),
             rep("sp3", N), rep("sp4", N))
x <- runif(N * 4, min = -69, max = -51)
y <- runif(N * 4, min = -23, max = -4)
xy <- cbind(x, y)

# PAM
resu <- lets.presab.grid.points(xy, species, sp.r, "ID", abundance = FALSE)

# Plot
rich_plus1 <- rowSums(resu$PAM[, -1, drop = FALSE]) + 1
colfunc <- colorRampPalette(c("#fff5f0", "#fb6a4a", "#67000d"))
colors <- c("white", colfunc(max(rich_plus1)))
occs <- terra::vect(xy, crs = crs)
plot(resu$grid, border = "gray40",
     col = colors[rich_plus1])
plot(sf::st_geometry(wrld_simpl), add = TRUE)
plot(occs, cex = 0.5, col = rep(1:4, each = N), add = T)
} # }


```
