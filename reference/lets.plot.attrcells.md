# Map AttrPAM descriptor layers

Maps each descriptor column returned by
[`lets.attrcells`](https://brunovilela.github.io/letsR/reference/lets.attrcells.md)
back onto the attribute raster. Optionally returns the rasters without
plotting.

## Usage

``` r
lets.plot.attrcells(
  x,
  y,
  ras = FALSE,
  plot_ras = TRUE,
  col_func = NULL,
  mfrow = c(4, 4)
)
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

- mfrow:

  A vector of the form c(nr, nc). The figures will be drawn in an
  nr-by-nc array on the device by rows as in par documentation.

## Value

If `ras = TRUE`, returns a named `list` of
[SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
layers (one per descriptor column).

## Details

Plot attribute-cell descriptors as rasters

Rows with zero or `NA` richness are masked before plotting, to avoid
edge artifacts from empty attribute cells. The plotting grid defaults to
`par(mfrow = c(4, 4))`; adjust as needed.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example with simulated traits
data(PAM)
n <- length(PAM$Species_name)
Species <- PAM$Species_name
trait_a <- rnorm(n)
trait_b <- trait_a * 0.2 + rnorm(n)  # correlated trait
df <- data.frame(Species, trait_a, trait_b)

# Build AttrPAM
x <- lets.attrpam(df, n_bins = 4)

# Compute descriptors
desc <- lets.attrcells(x, PAM)

# Plot descriptors
lets.plot.attrcells(x, desc)
} # }
```
