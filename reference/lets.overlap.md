# Compute pairwise species' geographic overlaps

Creates a species geographic overlap matrix from a Presence-absence
matrix.

## Usage

``` r
lets.overlap(pam, method = "Chesser&Zink", xy = NULL)
```

## Arguments

- pam:

  A presence-absence matrix (sites in rows and species in columns, with
  the first two columns containing the longitudinal and latitudinal
  coordinates, respectively), or an object of class
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md).

- method:

  The method used to calculate the overlap matrix. "Chesser&Zink"
  calculates the degree of overlap as the proportion of the smaller
  range that overlaps within the larger range (Chesser & Zink 1994).
  "Proportional" calculates the proportion of a range that overlaps
  another range, the resultant matrix is not symmetric. "Cells" will
  show the number of overlapping grid cells between a pair of species'
  ranges (same for both species in a pair), here the resultant matrix is
  symmetric.

- xy:

  Logical, if `TRUE` the input matrix contains geographic coordinates in
  the first two columns.

## References

Chesser, R. Terry, and Robert M. Zink. "Modes of speciation in birds: a
test of Lynch's method." Evolution (1994): 490-497.

Barraclough, Timothy G., and Alfried P. Vogler. "Detecting the
geographical pattern of speciation from species-level phylogenies." The
American Naturalist 155.4 (2000): 419-434.

## See also

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Fabricio Villalobos & Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
CZ <- lets.overlap(PAM, method = "Chesser&Zink")
prop <- lets.overlap(PAM, method = "Proportional")
cells <- lets.overlap(PAM, method = "Cells")
} # }
```
