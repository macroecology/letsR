# Create a presence-absence matrix of species' geographic ranges within a user's grid shapefile (beta version)

Convert species' ranges (in shapefile format) into a presence-absence
matrix based on a grid in shapefile format.

## Usage

``` r
lets.presab.grid(
  shapes,
  grid,
  sample.unit,
  remove.sp = TRUE,
  presence = NULL,
  origin = NULL,
  seasonal = NULL
)
```

## Arguments

- shapes:

  Object of class `SpatVect` or `Spatial` (see packages terra and sf to
  read these files) containing the distribution of one or more species.
  Species names should be stored in the object as BINOMIAL/binomial or
  SCINAME/sciname.

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

## Value

The result is a `list` containing two objects:

\(I\) A matrix the species presence (1) and absence (0) values per
sample unity.

\(II\) The original grid.

## Details

This function is an alternative way to create a presence absence matrix
when users already have their own grid.

## See also

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.presab.grid.points`](https://brunovilela.github.io/letsR/reference/lets.presab.grid.points.md)

[`lets.shFilter`](https://brunovilela.github.io/letsR/reference/lets.shFilter.md)

## Author

Bruno Vilela & Fabricio Villalobos

## Examples

``` r
if (FALSE) { # \dontrun{
# Species polygons
data("Phyllomedusa")
data("wrld_simpl")
# Grid 
sp.r <- terra::as.polygons(terra::rast(resol = 5, 
crs = terra::crs(Phyllomedusa),
xmin = -93, xmax = -29, ymin = -57, ymax = 15))
sp.r$ID <- 1:length(sp.r)
                         

# PAM
resu <- lets.presab.grid(Phyllomedusa, sp.r, "ID")

# Plot
rich_plus1 <- rowSums(resu$PAM[, -1]) + 1
colfunc <- colorRampPalette(c("#fff5f0", "#fb6a4a", "#67000d"))
colors <- c("white", colfunc(max(rich_plus1)))
plot(resu$grid, border = "gray40",
     col = colors[rich_plus1])
plot(sf::st_geometry(wrld_simpl), add = TRUE)
} # }


```
