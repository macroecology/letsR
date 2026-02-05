# Summarize variable(s) values in a presence-absence matrix within species' ranges

Based on a Presence-Absence matrix with added variables (see
[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md)),
this function summarizes the values of such variable(s) per species
(across the species' occupied cells. i.e. within their ranges).

## Usage

``` r
lets.summarizer(x, pos, xy = TRUE, fun = mean, ...)
```

## Arguments

- x:

  Presence-absence matrix with variables added.

- pos:

  Column position of the variables of interest.

- xy:

  Logical, if `TRUE` the input matrix contains geographic coordinates in
  the first two columns.

- fun:

  Function to be used to summarize the variable per species. Default is
  `mean`.

- ...:

  Other parameters passed to the function defined in `fun`.

## References

Villalobos, F. and Arita, H.T. 2010. The diversity field of New World
leaf-nosed bats (Phyllostomidae). Global Ecology and Biogeography. 19,
200-211.

## See also

[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md)

[`lets.addpoly`](https://brunovilela.github.io/letsR/reference/lets.addpoly.md)

[`lets.field`](https://brunovilela.github.io/letsR/reference/lets.field.md)

## Author

Bruno Vilela & Fabricio Villalobos

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
data(temp)
temp <- terra::unwrap(temp)
pamvar <- lets.addvar(PAM, temp)
resu <- lets.summarizer(x = pamvar, pos = ncol(pamvar),
                        xy = TRUE)
} # }
```
