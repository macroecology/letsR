# Fits a grid into a PresenceAbsence object

This function creates a grid in shapefile format and adds its cells' IDs
to the presence-absence matrix. The function was created to facilitate
the use of the PresenceAbsence object for the ones who prefer to work
with a grid in shapefile format.

## Usage

``` r
lets.gridirizer(x)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object.

## Value

The result is a list of two objects. The first is a grid in shapefile
format; the second is a presence-absence matrix with an aditional column
called SP_ID (shapefile cell identifier).

## See also

[`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
PAM.grid <- lets.gridirizer(PAM)
names(PAM.grid)
# Grid in polygon format (can be saved in shapefile)
PAM.grid$Grid
# Presence-absence matrix (beggining only)
head(PAM.grid$Presence[, 1:5])

} # }
```
