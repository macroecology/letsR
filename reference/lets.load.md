# Load a PresenceAbsence object

Reload PresenceAbsence objects written with the function
[`lets.save`](https://brunovilela.github.io/letsR/reference/lets.save.md).

## Usage

``` r
lets.load(file)
```

## Arguments

- file:

  a character string giving the name of the file to load.

## See also

[`lets.save`](https://brunovilela.github.io/letsR/reference/lets.save.md)

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

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
