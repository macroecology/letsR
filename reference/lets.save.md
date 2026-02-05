# Save a PresenceAbsence object

Save an external representation of a PresenceAbsence object to the
specified file. The object can be read back from the file at a later
date by using the function
[`lets.load`](https://brunovilela.github.io/letsR/reference/lets.load.md).

## Usage

``` r
lets.save(pam, ...)
```

## Arguments

- pam:

  A PresenceAbsence object.

- ...:

  other arguments passed to the function
  [`save`](https://rdrr.io/r/base/save.html)

## See also

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
lets.save(PAM, file = "PAM.RData")
PAM <- lets.load(file = "PAM.RData")
} # }
```
