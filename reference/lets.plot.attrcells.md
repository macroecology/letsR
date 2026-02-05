# Map AttrPAM descriptor layers

Maps each descriptor column returned by
[`lets.attrcells`](https://brunovilela.github.io/letsR/reference/lets.attrcells.md)
back onto the attribute raster template (`x$Attr_Richness_Raster`).
Optionally returns the rasters without plotting.

## Usage

``` r
lets.plot.attrcells(x, y, ras = FALSE, plot_ras = TRUE, col_func = NULL)
```

## Arguments

- x:

  A list returned by
  [`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md)
  (must contain `$Attr_Richness_Raster` and `$PAM_attribute`).

- y:

  A `data.frame` returned by
  [`lets.attrcells`](https://brunovilela.github.io/letsR/reference/lets.attrcells.md),
  with one row per attribute cell (aligned with `x`).

- ras:

  Logical; if `TRUE`, returns a named list of
  [SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  layers for each descriptor column (default `FALSE`).

- plot_ras:

  Logical; if `TRUE`, plots each raster (default `TRUE`).

- col_func:

  A custom color ramp palette function to use for plotting variables
  (e.g., from `colorRampPalette`).

## Value

Invisibly returns `NULL`. If `ras = TRUE`, returns a named `list` of
[SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
layers (one per descriptor column).

## Details

Plot attribute-cell descriptors as rasters

Rows with zero or `NA` richness are masked before plotting, to avoid
edge artifacts from empty attribute cells. The plotting grid defaults to
`par(mfrow = c(4, 2))`; adjust as needed.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example with simulated traits
n <- 2000
Species <- paste0("sp", 1:n)
trait_a <- rnorm(n)
trait_b <- trait_a * 0.2 + rnorm(n)  # correlated trait
df <- data.frame(Species, trait_a, trait_b)

# Build AttrPAM
x <- lets.attrpam(df, n_bins = 30)

# Compute descriptors
y <- lets.attrcells(x)

# Plot descriptors
lets.plot.attrcells(x, y)
} # }
```
