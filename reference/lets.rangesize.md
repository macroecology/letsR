# Compute species' geographic range sizes

This function calculates species' range sizes from a PresenceAbsence
object or directly from the species' shapefiles.

## Usage

``` r
lets.rangesize(
  x,
  species_name = NULL,
  coordinates = "geographic",
  units = "cell"
)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  or an `SpatVector` object.

- species_name:

  Species names in the same order as in the `SpatVector` (only needed if
  x is a `SpatVector`).

- coordinates:

  "geographical" or "planar". Indicate whether the shapefile has
  geographical or planar coordinates(only needed if x is a
  `SpatVector`).

- units:

  "cell" or "squaremeter". Indicate if the size units wanted are in
  number of cells occupied or in square meters(only needed if x is a
  `PresenceAbsence` object).

## Value

The result is a matrix with the range size of each species. If the range
size accounts for the earth curvature (Yes or No) or its size unit may
differ for each argument combination:

1\) SpatVector & geographical = Square meters. Yes.

2\) SpatVector & planar = Square meters. No.

3\) PresenceAbsence & cell = number of cells. No.

4\) PresenceAbsence & squaremeter = Square meters. Yes.

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
# SpatialPolygonsDataFrame & geographical
data(Phyllomedusa)
rangesize <- lets.rangesize(x = Phyllomedusa,
                            coordinates = "geographic")

# SpatialPolygonsDataFrame & planar
rangesize2 <- lets.rangesize(x = Phyllomedusa,
                             coordinates = "planar")

# PresenceAbsence & cell
data(PAM)
rangesize3 <- lets.rangesize(x = PAM,
                             units = "cell")

# PresenceAbsence & squaremeter
rangesize4 <- lets.rangesize(x = PAM,
                             units = "squaremeter")
} # }

```
