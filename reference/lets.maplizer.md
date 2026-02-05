# Create a matrix summarizing species' attributes within cells of a PresenceAbsence object

Summarize species atributes per cell in a presence-absence matrix.

## Usage

``` r
lets.maplizer(x, y, z, func = mean, ras = FALSE, weighted = FALSE)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object.

- y:

  Species attribute to be considered. It must be a numeric attribute.

- z:

  Species names in the same order as the attributes and exactly the same
  as named in the `PresenceAbsence` object.

- func:

  A function to summarize the species' atribute in each cell (the
  function must return only one value).

- ras:

  If `TRUE` the raster object will be returned together with the matrix.

- weighted:

  If TRUE, argument func is ignored, and weighted mean is calculated.
  Weights are attributed to each species according to 1/N cells that the
  species occur.

## Value

The result can be both a `matrix` or a `list` cointaining the follow
objects:

**Matrix**: a `matrix` object with the cells' geographic coordinates and
the summarized species' attributes within them.

**Raster**: The summarized species'attributed maped in a `SpatRaster`
object.

## See also

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
data(IUCN)
trait <- IUCN$Description_Year
resu <- lets.maplizer(PAM, trait, PAM$S, ras = TRUE)
head(resu$Matrix)
plot(resu$Raster, xlab = "Longitude", ylab = "Latitude", 
main = "Mean description year per site")

} # }
```
