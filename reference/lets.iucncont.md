# Transform IUCN RedList conservation status to continuous values

Transform IUCN RedList conservation status to continuous values ranging
from 0 to 5.

## Usage

``` r
lets.iucncont(x, dd = NA, ne = NA)
```

## Arguments

- x:

  A vector or a matrix containing IUCN codes to be transformed.

- dd:

  The value to be attributed to DD (data-deficient) species, the default
  option is NA.

- ne:

  The value to be attributed to NE (not-evaluated) species, the default
  option is NA.

## Value

Returns a vector/matrix with continuos values from 0 to 5.

EX and EW = 5

CR = 4

EN = 3

VU = 2

NT = 1

LC = 0

DD = NA

NE = NA

## References

Purvis A et al., 2000. Predicting extinction risk in declining species.
Proceedings of the Royal Society of London. Series B: Biological
Sciences, 267.1456: 1947-1952.

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
#Vector transformation
status <- sample(c("EN","VU", "NT", "CR", "DD", "LC", "EX"), 
                 30, replace = TRUE) 
transV <- lets.iucncont(status)

#matrix transformation
data(IUCN)
transM <- lets.iucncont(IUCN)

} # }
```
