# Create species' values based on the species co-occurrence within focal ranges

Create single species' values based on the attributes of species
co-occurring within individual ranges.

## Usage

``` r
lets.field(x, y, z, weight = TRUE, xy = NULL, count = FALSE)
```

## Arguments

- x:

  A
  [`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
  object or a presence-absence in `matrix` format (see xy argument for
  matrix use) with the species named in the columns.

- y:

  Species attribute to be considered. It must be a numeric attribute.

- z:

  Species names in the same order as the attributes and exactly the same
  as named in the `matrix` or in the `PresenceAbsence` object.

- weight:

  If `TRUE` the value is weighted by species' range size, if `FALSE` the
  value is the mean of all species that co-occur within the focal
  species.

- xy:

  If `TRUE` the presence-absence `matrix` contains the cell coordinates
  in the first two columns.

- count:

  Logical, if `TRUE` a counting window will open.

## Details

If the species do not co-occur with any other species NaN will be
returned.

## References

Villalobos, F. and Arita, H.T. 2010. The diversity field of New World
leaf-nosed bats (Phyllostomidae). Global Ecology and Biogeography. 19,
200-211.

Villalobos, F., Rangel, T.F., and Diniz-Filho, J.A.F. 2013. Phylogenetic
fields of species: cross-species patterns of phylogenetic structure and
geographical coexistence. Proceedings of the Royal Society B. 280,
20122570.

## See also

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

## Author

Bruno Vilela & Fabricio Villalobos

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
range <- lets.rangesize(x = PAM, units = "cell")
field <- lets.field(PAM, range, PAM$S, weight = TRUE)
} # }
```
