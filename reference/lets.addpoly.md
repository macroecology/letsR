# Add polygon coverage to a PresenceAbscence object

Add polygon coverage within cells of a PresenceAbsence object.

## Usage

``` r
lets.addpoly(x, y, z, onlyvar = FALSE, count = FALSE)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object.

- y:

  Polygon of interest.

- z:

  A character indicating the column name of the polygon containing the
  attributes to be used.

- onlyvar:

  If `TRUE` only the matrix object will be returned.

- count:

  Logical, if `TRUE` a progress bar indicating the processing progress
  will be shown.

## Value

The result is a presence-absence matrix of species with the polygons'
attributes used added as columns at the right-end of the matrix. The
Values represent the percentage of the cell covered by the polygon
attribute used.

## See also

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)  # Phyllomedusa presence-absence matrix
data(wrld_simpl)  # World map
Brazil <- wrld_simpl[wrld_simpl$NAME == "Brazil", ]  # Brazil (polygon)

# Check where is the variable name 
# (in this case it is in "NAME" which will be my z value)
names(Brazil)

PAM_pol <- lets.addpoly(PAM, Brazil, "NAME", onlyvar = TRUE)
} # }
```
