# Compute correlogram based on the Moran's I index

Computes the Moran's I correlogram of a single or multiple variables.

## Usage

``` r
lets.correl(x, y, z, equidistant = FALSE, plot = TRUE)
```

## Arguments

- x:

  A single numeric variable in vector format or multiple variables in
  matrix format (as columns).

- y:

  A distance matrix of class `matrix` or `dist`.

- z:

  The number of distance classes to use in the correlogram.

- equidistant:

  Logical, if `TRUE` the classes will be equidistant. If `FALSE` the
  classes will have equal number of observations.

- plot:

  Logical, if `TRUE` the correlogram will be ploted.

## Value

Returns a matrix with the Moran's I Observed value, Confidence Interval
(95 and Expected value. Also the p value of the randomization test, the
mean distance between classes, and the number of observations. quase
tudo

## References

Sokal, R.R. & Oden, N.L. (1978) Spatial autocorrelation in biology. 1.
Methodology. Biological Journal of the Linnean Society, 10, 199-228.

Sokal, R.R. & Oden, N.L. (1978) Spatial autocorrelation in biology. 2.
Some biological implications and four applications of evolutionary and
ecological interest. Biological Journal of the Linnean Society, 10,
229-249.

## Author

Bruno Vilela, Fabricio Villalobos, Lucas Jardim & Jose Alexandre
Diniz-Filho

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
data(IUCN)

# Spatial autocorrelation in description year (species level)
midpoint <- lets.midpoint(PAM)
distan <- lets.distmat(midpoint[, 2:3])
moran <- lets.correl(IUCN$Description, distan, 12,
                     equidistant = FALSE, 
                     plot = TRUE)
                     
} # }
```
