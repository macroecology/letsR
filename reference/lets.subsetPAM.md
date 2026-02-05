# Subset a PresenceAbsence object based on species names

Subset a PresenceAbsence object based on species character vector
provided by the user.

## Usage

``` r
lets.subsetPAM(x, names, remove.cells = TRUE)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object.

- names:

  Character vector with species names to subset the `PresenceAbsence`
  object.

- remove.cells:

  Logical, if `TRUE` the final matrix will not contain cells in the grid
  with a value of zero (i.e. sites with no species present).

## Value

The result is an object of class PresenceAbsence subseted.

## See also

[`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
# PAM before subset
plot(PAM, xlab = "Longitude", ylab = "Latitude",
     main = "Phyllomedusa species richness")

# Subset PAM to the first 20 species
PAMsub <- lets.subsetPAM(PAM, PAM[[3]][1:20])
plot(PAMsub, xlab = "Longitude", ylab = "Latitude",
     main = "Phyllomedusa species richness")
} # }
```
