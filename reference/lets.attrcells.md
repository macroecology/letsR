# Descriptors of position, centrality, and isolation in attribute space

Computes a suite of descriptor variables for each cell of an
*attribute-space* presence–absence matrix, as returned by
[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md).
Attribute variables are treated as a two-dimensional space, and the
function derives metrics that characterize: (i) the position of each
attribute cell relative to the attribute-space centroid (mean and
frequency-weighted distances), (ii) its proximity to attribute-space
borders (zero-richness frontier, quantified via multiple distance-based
proxies), and (iii) its isolation within attribute space
(frequency-weighted Euclidean distance to other cells).

When a geographic presence–absence matrix is supplied, the function also
links each attribute cell to the geographic cells occupied by the taxa
occurring in that cell, allowing the calculation of: (iv) frequency in
geographic space, (v) total geographic area, and (vi) geographic
isolation statistics (summaries of pairwise distances among associated
geographic cells).

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

  Numeric value in the interval 0 to 1 indicating the proportion of the
  shortest distances to empty attribute cells to be averaged in the
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

Summarize metrics of the attribute-space PAM

The two attribute variables are standardized to zero mean and unit
variance before distance-based calculations.

If `y` is provided, the function first identifies the taxa present in
each attribute cell, then retrieves the geographic cells occupied by
those taxa in the geographic PAM. Based on these linked geographic
cells, the function computes:

- `Frequency`: number of associated geographic cells;

- `Area`: total area of the associated geographic cells;

- summary statistics of pairwise geographic distances among those cells.

If `y = NULL`, geographic descriptors are not computed. In this case,
attribute-cell richness is used as the weighting variable in the
midpoint and frequency-weighted distance calculations.

Empty attribute cells are defined as cells with zero frequency when `y`
is provided, or zero richness when `y = NULL`. Cells with `NA` values in
the richness raster are treated as empty.

Distances to the weighted and unweighted midpoints are returned as
negative values so that larger values indicate greater centrality in
attribute space.

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
