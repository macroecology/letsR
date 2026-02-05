# Compute a geographic distance matrix

Calculates a geographic distance matrix based on a `PresenceAbsence` or
a two column `matrix` of x(longitude) and y(latitude).

## Usage

``` r
lets.distmat(xy, asdist = TRUE)
```

## Arguments

- xy:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object or a `matrix` with two columns (longitude, latitude).

- asdist:

  Logical, if `TRUE` the result will be an object of class `dist`, if
  `FALSE` the result will be an object of class `matrix`.

## Value

The user can choose between `dist` and `matrix` class object to be
returned. The resulting values are in kilometres (but see the argument
'unit' in `rdist.earth`).

## Details

This function basically facilitates the use of
[`terra::distance`](https://rspatial.github.io/terra/reference/distance.html)
on a `PresenceAbsence` object, allowing also the user to have directly a
`dist` object. The distance is always expressed in meter if the
coordinate reference system is longitude/latitude, and in map units
otherwise. Map units are typically meter, but inspect crs(x) if in
doubt.

## Author

Bruno Vilela & Fabricio Villalobos

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
distPAM <- lets.distmat(PAM)
} # }
```
