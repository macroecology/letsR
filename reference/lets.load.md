# Load a letsR object

Load a letsR object previously saved using
[`lets.save`](https://brunovilela.github.io/letsR/reference/lets.save.md).
All packed raster components are automatically restored as SpatRaster
objects.

## Usage

``` r
lets.load(file)
```

## Arguments

- file:

  A character string specifying the file to load.

## Value

The restored letsR object, including its matrices, raster components,
and other attributes.

## See also

[`lets.save`](https://brunovilela.github.io/letsR/reference/lets.save.md)

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md)

[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(PAM)
lets.save(PAM, file = "PAM.RData")
PAM <- lets.load("PAM.RData")
} # }
```
