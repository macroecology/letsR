# Descriptors of centrality, border proximity, and isolation in attribute space

Computes per-cell descriptors for an attribute-space presence–absence
matrix (as returned by
[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md)),
using the two numeric attributes as a 2D coordinate system. The
descriptors include:

- **Richness**: number of taxa in each attribute cell (from the richness
  raster).

- **Distances to attribute midpoints**: distance to the weighted
  midpoint (weights = richness) and to the unweighted midpoint, both
  computed in standardized attribute space; returned as *negated* values
  so that larger numbers indicate greater centrality.

- **Border proximity**: three proxies — minimum distance to any
  zero-richness cell; robust mean of the closest `perc` fraction of
  zero-richness distances; and minimum distance to the convex-hull (MCP)
  border of occupied attribute cells.

- **Attribute isolation**: richness-weighted mean distance from each
  cell to all other cells in standardized attribute space.

## Usage

``` r
lets.attrcells(x, perc = 0.2, remove.cells = FALSE)
```

## Arguments

- x:

  A list produced by
  [`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md)
  containing:

  - `$PAM_attribute`: data.frame with columns `Cell_attr` (first), the
    two attribute coordinates (second and third), followed by taxa
    columns (0/1).

  - `$Attr_Richness_Raster`:
    [SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
    with richness per attribute cell.

- perc:

  Numeric in (0, 1\]; fraction used in the robust border metric (mean of
  the *n* smallest zero-richness distances). Default `0.2`.

- remove.cells:

  Logical. If 'TRUE', remove empty cells from the results.

## Value

A `data.frame` with one row per attribute cell and the columns:

- `Cell_attr`: attribute cell identifier (1..n).

- `Richness`: taxa count for the cell (from `$Attr_Richness_Raster`).

- `Weighted Mean Distance to midpoint`, `Mean Distance to midpoint`:
  negated distances (larger = more central) in standardized attribute
  space.

- `Minimum Zero Distance`, `Minimum 10% Zero Distance`,
  `Distance to MCP border`: border proximity proxies.

- `Frequency Weighted Distance`: richness-weighted mean distance to all
  other cells.

## Details

Attribute-cell descriptors for an attribute-space PAM (AttrPAM)

Attributes (columns 2–3 of `$PAM_attribute`) are standardized (z-scores)
prior to distance calculations. Cells with `NA` richness are treated as
zero when identifying zero-richness neighbors, and later masked in
plotting.

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
