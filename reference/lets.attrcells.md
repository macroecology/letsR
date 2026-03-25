# Descriptors of position and isolation in attribute space

Calculates descriptor variables for each cell of an attribute-space
presence–absence matrix (AttrPAM), as returned by
[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md).
The two attribute axes are treated as a two-dimensional coordinate
system, and descriptors are computed to summarize each cell's position
in attribute space and its relation to other occupied or empty cells.

The function can also incorporate a geographic presence–absence matrix,
allowing attribute cells to be linked to the number and spatial
configuration of geographic cells associated with the taxa occurring in
each attribute cell.

The descriptors include:

- **Frequency**: when `y` is provided, the number of geographic cells
  associated with the taxa present in each attribute cell.

- **Geographic isolation**: when `y` is provided, summaries of pairwise
  distances among the geographic cells associated with each attribute
  cell.

- **Distance to midpoints**: distance from each attribute cell to the
  weighted and unweighted midpoints of occupied attribute space,
  computed in standardized attribute space. These values are returned as
  negative distances so that larger values indicate greater centrality.

- **Border proximity**: minimum distance to any empty attribute cell,
  mean distance to the closest `perc` proportion of empty cells, and
  distance to the convex-hull border of occupied attribute space.

- **Frequency-weighted distance**: weighted mean distance from each
  attribute cell to all other attribute cells in standardized attribute
  space.

## Usage

``` r
lets.attrcells(x, y = NULL, perc = 0.2, remove.cells = FALSE)
```

## Arguments

- x:

  A list produced by
  [`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md),
  containing at least:

  - `$PAM_attribute`: a data frame in which the first column is
    `Cell_attr`, the second and third columns are the two attribute
    coordinates, and the remaining columns correspond to taxa coded as
    presence (1) or absence (0).

  - `$Attr_Richness_Raster`: a
    [SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
    containing the richness of taxa in each attribute cell.

- y:

  A geographic presence–absence object produced by
  [`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md).
  If `NULL`, geographic frequency and geographic isolation metrics are
  not calculated, and attribute-cell richness is used as the weighting
  variable in attribute-space calculations.

- perc:

  Numeric value in the interval \\(0, 1\]\\ indicating the proportion of
  the shortest distances to empty cells to be used in the robust
  border-distance metric. Default is `0.2`.

- remove.cells:

  Logical. If `TRUE`, removes attribute cells that were absent from
  `x$PAM_attribute` and were added internally to complete the raster
  structure.

## Value

A `data.frame` with one row per attribute cell. The output always
includes:

- `Cell_attr`: attribute-cell identifier.

- `Weighted Mean Distance to midpoint`: negative distance to the
  richness- or frequency-weighted midpoint.

- `Mean Distance to midpoint`: negative distance to the unweighted
  midpoint.

- `Minimum Zero Distance`: minimum distance to an empty attribute cell.

- `Minimum 10% Zero Distance`: mean distance to the nearest `perc`
  proportion of empty attribute cells.

- `Distance to MCP border`: distance to the convex-hull border of
  occupied attribute space.

- `Frequency Weighted Distance`: weighted mean distance to all other
  attribute cells.

When `y` is provided, the output additionally includes:

- `Frequency`: number of geographic cells associated with the taxa in
  each attribute cell.

- `Isolation (Min.)`, `Isolation (1st Qu.)`, `Isolation (Median)`,
  `Isolation (Mean)`, `Isolation (3rd Qu.)`, `Isolation (Max.)`: summary
  statistics of pairwise geographic distances among associated
  geographic cells.

## Details

Attribute-cell descriptors for an attribute-space PAM (AttrPAM)

The two attribute variables (columns 2 and 3 of `x$PAM_attribute`) are
standardized to zero mean and unit variance before distance
calculations.

If `y` is provided, the function first links taxa occurring in each
attribute cell to their occupied geographic cells, and then computes:

- the number of geographic cells associated with each attribute cell
  (`Frequency`);

- summary statistics of pairwise geographic distances among those cells.

If `y = NULL`, no geographic summaries are produced. In that case, the
richness of each attribute cell, extracted from
`x$Attr_Richness_Raster`, is used as the weight for midpoint and
isolation calculations in attribute space.

Empty attribute cells are identified as cells with zero frequency (or
zero richness when `y = NULL`). Cells with `NA` values in the richness
raster are treated as empty for these calculations.

Distance to the midpoint is reported as a negative value by design, so
that larger values correspond to cells located closer to the center of
attribute space.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example using a geographic PAM and simulated attributes
data("PAM")

n <- length(PAM$Species_name)
Species <- PAM$Species_name
trait_a <- rnorm(n)
trait_b <- trait_a * 0.2 + rnorm(n)  # correlated trait
df <- data.frame(Species, trait_a, trait_b)

# Build the attribute-space PAM
x <- lets.attrpam(df, n_bins = 4)

# Use the geographic PAM to calculate frequency and geographic isolation
y <- PAM

# Calculate attribute-cell descriptors
cell_desc <- lets.attrcells(x, y)

# Plot descriptors
lets.plot.attrcells(x, cell_desc)
} # }
```
