# Crop a PresenceAbsence object based on an input shapefile

Crop a PresenceAbsence object based on a shapefile provided by the user.

## Usage

``` r
lets.pamcrop(x, shp, remove.sp = TRUE, remove.cells = FALSE)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object.

- shp:

  Object of class SpatVector (see function
  [`terra::vect`](https://rspatial.github.io/terra/reference/vect.html))
  to crop the PresenceAbsence object.

- remove.sp:

  Logical, if `TRUE` the final matrix will not contain species that do
  not match any cell in the grid.

- remove.cells:

  Logical, if `FALSE` the final matrix will not contain cells in the
  grid with a value of zero (i.e. sites with no species present).

## Value

The result is an object of class PresenceAbsence croped.

## See also

[`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
data("wrld_simpl")

# PAM before crop
plot(PAM, xlab = "Longitude", ylab = "Latitude",
     main = "Phyllomedusa species richness")

# Crop PAM to Brazil
data(wrld_simpl)  # World map
Brazil <- wrld_simpl[wrld_simpl$NAME == "Brazil", ]  # Brazil (polygon)
PAM_crop <- lets.pamcrop(PAM, Brazil, remove.sp = TRUE)
plot(PAM_crop, xlab = "Longitude", ylab = "Latitude",
     main = "Phyllomedusa species richness (Brazil crop)")
plot(sf::st_geometry(wrld_simpl), add = TRUE)
} # }
```
