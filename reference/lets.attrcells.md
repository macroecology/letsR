# Descriptors of position, centrality, and isolation in attribute space

Calculates descriptor variables for each cell of an attribute-space
presence–absence matrix (AttrPAM), as returned by
[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md).
The two attribute axes are treated as a two-dimensional coordinate
system, and the function derives metrics that summarize the position of
each attribute cell in this space, its proximity to empty regions and
borders, and its average isolation from other cells.

When a geographic presence–absence matrix is supplied, the function also
links each attribute cell to the geographic cells occupied by the taxa
occurring in that attribute cell, allowing the calculation of frequency,
area, and geographic isolation summaries.

## Usage

``` r
lets.attrcells(x, y = NULL, perc = 0.1, remove.cells = FALSE)
```

## Arguments

- x:

  A list produced by
  [`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md)
  containing, at minimum:

  - `$PAM_attribute`: a data frame in which the first column is the
    attribute-cell identifier (`Cell_attr`), the second and third
    columns are the coordinates of the two attribute axes, and the
    remaining columns are taxa coded as presence (1) or absence (0).

  - `$Attr_Richness_Raster`: a
    [SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
    containing the richness of taxa in each attribute cell.

- y:

  A geographic presence–absence object produced by
  [`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md).
  If supplied, the function calculates the number of geographic cells
  associated with each attribute cell, the total area of those cells,
  and summary statistics of pairwise geographic distances among them. If
  `NULL`, these geographic descriptors are not calculated, and
  attribute-cell richness is used as the weighting variable for the
  attribute-space metrics.

- perc:

  Numeric value in the interval \\(0, 1\]\\ indicating the proportion of
  the shortest distances to empty attribute cells to be averaged in the
  robust border-distance metric. Default is `0.1`.

- remove.cells:

  Logical. If `TRUE`, removes attribute cells that were not originally
  present in `x$PAM_attribute` and that were added internally to
  complete the raster support.

## Value

A `data.frame` with one row per attribute cell. The output always
contains:

- `Cell_attr`: attribute-cell identifier.

- `Weighted Mean Distance to midpoint`: negative Euclidean distance from
  the cell to the weighted midpoint of occupied attribute space.

- `Mean Distance to midpoint`: negative Euclidean distance from the cell
  to the unweighted midpoint of occupied attribute space.

- `Minimum Zero Distance`: minimum distance from the cell to any empty
  attribute cell.

- `Minimum X% Zero Distance`: mean distance from the cell to the nearest
  fraction of empty attribute cells defined by `perc`, where
  `X = perc * 100`.

- `Distance to MCP border`: distance from the cell to the border of the
  minimum convex polygon enclosing occupied attribute cells.

- `Frequency Weighted Distance`: weighted mean distance from the cell to
  all other attribute cells.

When `y` is provided, the output additionally includes:

- `Frequency`: number of geographic cells associated with the taxa
  present in the attribute cell.

- `Area`: summed area of those associated geographic cells.

- `Isolation (Min.)`, `Isolation (1st Qu.)`, `Isolation (Median)`,
  `Isolation (Mean)`, `Isolation (3rd Qu.)`, and `Isolation (Max.)`:
  summary statistics of pairwise geographic distances among associated
  geographic cells.

## Details

Attribute-cell descriptors for an attribute-space PAM (AttrPAM)

The two attribute variables (columns 2 and 3 of `x$PAM_attribute`) are
standardized to zero mean and unit variance before distance-based
calculations.

If `y` is provided, the function first identifies the taxa present in
each attribute cell, then retrieves the geographic cells occupied by
those taxa in the geographic PAM. Based on these linked geographic
cells, the function computes:

- `Frequency`: number of associated geographic cells;

- `Area`: total area of the associated geographic cells;

- summary statistics of pairwise geographic distances among those cells.

If `y = NULL`, geographic descriptors are not computed. In this case,
attribute-cell richness extracted from `x$Attr_Richness_Raster` is used
as the weighting variable in the midpoint and frequency-weighted
distance calculations.

Empty attribute cells are defined as cells with zero frequency when `y`
is provided, or zero richness when `y = NULL`. Cells with `NA` values in
the richness raster are treated as empty.

Distances to the weighted and unweighted midpoints are returned as
negative values so that larger values indicate greater centrality in
attribute space.

The function also calculates three border-related descriptors:

- the minimum distance to any empty attribute cell;

- the mean distance to the nearest `perc` proportion of empty attribute
  cells;

- the distance to the border of the minimum convex polygon enclosing
  occupied attribute cells.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example using a geographic PAM and simulated attribute data
data("PAM")

n <- length(PAM$Species_name)
Species <- PAM$Species_name
trait_a <- rnorm(n)
trait_b <- trait_a * 0.2 + rnorm(n)
df <- data.frame(Species, trait_a, trait_b)

# Build the attribute-space PAM
x <- lets.attrpam(df, n_bins = 4)

# Calculate attribute-cell descriptors using the geographic PAM
cell_desc <- lets.attrcells(x, y = PAM)

# Plot the resulting descriptors
lets.plot.attrcells(x, cell_desc)
} # }
```
