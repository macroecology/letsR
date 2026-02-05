# Plot an object of class PresenceAbsence

Plots species richness map from an object of class PresenceAbsence or a
particular species' map.

## Usage

``` r
# S3 method for class 'PresenceAbsence'
plot(x, name = NULL, world = TRUE, col_rich = NULL, col_name = "red", ...)
```

## Arguments

- x:

  An object of class
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md).

- name:

  A character specifying a species to be ploted instead of the complete
  species richness map.

- world:

  If `TURE` a map of political divisions (countries) is added to the
  plot.

- col_rich:

  Color function (e.g.
  [`rainbow`](https://rdrr.io/r/grDevices/palettes.html),
  [`heat.colors`](https://rdrr.io/r/grDevices/palettes.html),
  [`colorRampPalette`](https://rdrr.io/r/grDevices/colorRamp.html)) to
  be used in the richness map.

- col_name:

  The color to use when ploting single species.

- ...:

  Other parameters pass to the plot function.

## See also

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
plot(PAM)
plot(PAM, xlab = "Longitude", ylab = "Latitude",
     main = "Phyllomedusa species richness")
plot(PAM, name = "Phyllomedusa atelopoides")
plot(PAM, name = "Phyllomedusa azurea")
} # }
```
