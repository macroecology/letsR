# Add variables (in raster format) to a PresenceAbscence object

Add variables (in raster format), usually environmental, to a
PresenceAbsence object. Variables are included as additional columns
containing the aggregate/summarize value of the variable(s) in each cell
of the presence-absence matrix.

## Usage

``` r
lets.addvar(x, y, onlyvar = FALSE, fun = mean)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object.

- y:

  Variables to be added in `SpatRaster` format.

- onlyvar:

  If `TRUE` only the `matrix` object will be returned.

- fun:

  Function used to aggregate the variables(s) values over each cell.
  Note that this will only work for variables with a resolution value
  smaller (i.e. higher resolution) than the PAM.

## Value

The result is a presence-absence matrix of species with the variables
added as columns at the right-end of the matrix (but see the 'onlyvar'
argument).

## Note

The `PresenceAbsence` and the `Raster` variable must be in the same
projection.

## See also

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.addpoly`](https://brunovilela.github.io/letsR/reference/lets.addpoly.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(temp)  # Global mean temperature
temp <- terra::unwrap(temp)
data(PAM)  # Phyllomedusa presence-absence matrix
# Mean temperature
PAM_temp_mean <- lets.addvar(PAM, temp)
# Standard deviation of temperature
PAM_temp_sd <- lets.addvar(PAM, temp, fun = sd, onlyvar = TRUE)
# Mean and SD in the PAM
PAM_temp_mean_sd <- cbind(PAM_temp_mean, PAM_temp_sd)
} # }
```
