# Transform values of a vector

Transform each element of a vector.

## Usage

``` r
lets.transf(x, y, z, NUMERIC = TRUE)
```

## Arguments

- x:

  A vector to be transformed.

- y:

  levels to be transformed.

- z:

  The value to be atributed to each level (same order as y).

- NUMERIC:

  logical, if `TRUE` z will be considered numbers.

## Value

Return a vector with changed values.

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
status <- sample(c("EN","VU", "NT", "CR", "DD", "LC"), 30, replace=TRUE) 
TE <- "Threatened"
NT <- "Non-Threatened"
new <- c(TE, TE, NT, TE, "Data Deficient", NT)
old <- c("EN","VU", "NT", "CR", "DD", "LC")
statustrans <- lets.transf(status, old, new, NUMERIC=FALSE)

} # }
```
