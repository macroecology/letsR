# Frequency distribution of a variable within a species' range

Based on a species Presence-Absence matrix including variables of
interest (see
[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md)),
the function divides a continuous variable into classes and counts the
frequency of each class within each species' range.

## Usage

``` r
lets.classvar(x, groups = "default", pos, xy)
```

## Arguments

- x:

  Presence-absence `matrix` with a single variable added (see
  [`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md)).

- groups:

  The number of classes into which the variable will be divided. Default
  calculates the number of classes as the default for a histogram
  ([`hist`](https://rdrr.io/r/graphics/hist.html)).

- pos:

  Column number containing the variable of interest.

- xy:

  Logical, if `TRUE` the input matrix contains the geographic
  coordinates in the first two columns.

## Value

A `matrix` with species in the rows and the variable's classes in the
columns.

## References

Morales-Castilla et al. 2013. Range size patterns of New World oscine
passerines (Aves): insights from differences among migratory and
sedentary clades. Journal of Biogeography, 40, 2261-2273.

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
data(temp)
pamvar <- lets.addvar(PAM, temp)
resu <- lets.classvar(x = pamvar, pos = ncol(pamvar), xy = TRUE)
} # }
  
```
