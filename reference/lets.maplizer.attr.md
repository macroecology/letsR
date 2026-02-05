# Map species-level attributes over the attribute-space grid

Summarizes species attributes (e.g., trait values, description year)
within each \*\*attribute-space\*\* cell of a presence–absence matrix
produced by
[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md).
A summary function (`func`) is applied across the attributes of species
present in each cell, producing a per-cell attribute surface and an
optional raster for visualization.

## Usage

``` r
lets.maplizer.attr(x, y, z, func = mean, ras = TRUE, weighted = FALSE)
```

## Arguments

- x:

  An object returned by
  [`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md),
  containing the attribute-space PAM (matrix) and its raster.

- y:

  A numeric vector with species attributes to summarize (one value per
  species in `z`). If `y` is a factor, it is coerced to numeric by level
  codes.

- z:

  A character vector of species names corresponding to `y`. These names
  must match the species columns in the attribute-space PAM within `x`.

- func:

  A function to summarize attributes across species within each cell
  (e.g., `mean`, `median`, `sum`). Must return a single numeric value.

- ras:

  Logical; if `TRUE`, include the attribute map as a
  [SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  in the output.

- weighted:

  If TRUE, argument func is ignored, and weighted mean is calculated.
  Weights are attributed to each species according to 1/N cells that the
  species occur.

## Value

A `list` with:

- `Matrix_attr`: matrix/data.frame with summarized attribute values per
  attribute cell (first columns are the cell ID and the two attribute
  axes).

- `Attr_Raster`:
  [SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  with the summarized attribute mapped in attribute space.

## Details

Map species attributes in attribute space (based on AttrPAM)

Internally, the function multiplies each species presence column by its
attribute value in `y` (matched by name via `z`), sets zeros to `NA` so
that summary functions ignore absences, applies `func` across species
for each cell, and rasterizes the resulting per-cell summaries onto the
attribute raster template. Cells with no species remain as `NA`.

## See also

[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md),
[`lets.plot.attrpam`](https://brunovilela.github.io/letsR/reference/lets.plot.attrpam.md),
[`lets.attrcells`](https://brunovilela.github.io/letsR/reference/lets.attrcells.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
# Simulate a dataset of 2000 species with two traits
n <- 2000
Species <- paste0("sp", 1:n)
trait_a <- rnorm(n)
trait_b <- trait_a * 0.2 + rnorm(n)
df <- data.frame(Species, trait_a, trait_b)

# Build attribute-space PAM
x <- lets.attrpam(df, n_bins = 30)

# Map species-level attribute (here, trait_b) by cell using the mean
res <- lets.maplizer.attr(x, y = trait_b, z = Species)

# Plot attribute raster
lets.plot.attrpam(res)
} # }
```
