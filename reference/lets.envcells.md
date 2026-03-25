# Environmental descriptors for Presence–Absence in environmental space

Computes a suite of descriptors for each environmental cell in an
*environmental* presence–absence matrix (envPAM), including: (i)
frequency in geographic space, (ii) geographic isolation statistics
(summary of pairwise distances among geographic cells mapped to the same
environmental cell), (iii) distance to environmental midpoints (mean and
frequency-weighted mean), (iv) distance to environmental “border”
(zero-richness frontier via three proxies), and (v) an environmental
isolation metric based on frequency-weighted Euclidean distance in
standardized environmental space.

Distances to midpoints are returned \*\*negated\*\* (i.e., larger values
imply greater centrality in environmental space), following the current
implementation.

## Usage

``` r
lets.envcells(x, perc = 0.2, remove.cells = FALSE)
```

## Arguments

- x:

  A list returned by
  [`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md)
  containing at least:

  - `$Presence_and_Absence_Matrix_env`: data.frame with columns
    `cell_id_env`, the environmental coordinates (e.g., two variables),
    and species presences (one column per species).

  - `$Presence_and_Absence_Matrix_geo`: data.frame with columns
    `cell_id_geo`, geographic coordinates (lon, lat), and species
    presences.

  - `$Env_Richness_Raster`: a terra SpatRaster of richness in
    environmental space.

- perc:

  Numeric in (0,1\], the fraction used in the robust border metric (mean
  of the *n* smallest distances to zero-richness cells). Default = 0.1.

- remove.cells:

  Logical. If 'TRUE', remove empty cells from the results.

## Value

A data frame with one row per environmental cell. The output includes:

- `Cell_env`: Environmental cell identifier.

- `Frequency`: Number of geographic cells mapped to the environmental
  cell.

- `Area`: Summed area of the associated geographic cells.

- `Isolation (Min.)`, `Isolation (1st Qu.)`, `Isolation (Median)`,
  `Isolation (Mean)`, `Isolation (3rd Qu.)`, and `Isolation (Max.)`:
  Summary statistics of pairwise geographic distances among associated
  geographic cells.

- `Weighted Mean Distance to midpoint`: Negated distance from the cell
  to the frequency-weighted midpoint in standardized environmental
  space.

- `Mean Distance to midpoint`: Negated distance from the cell to the
  unweighted midpoint in standardized environmental space.

- `Minimum Zero Distance`: Minimum distance from the cell to any empty
  environmental cell.

- A column named according to `perc` (e.g.,
  `Minimum 10% Zero Distance`): Mean distance from the cell to the
  nearest fraction of empty environmental cells.

- `Distance to MCP border`: Distance from the cell to the
  environmental-space border.

- `Frequency Weighted Distance`: Frequency-weighted mean distance from
  the cell to all other environmental cells.

## Details

Summarize environmental–geographical metrics from an envPAM object

Environmental variables (assumed to be the 2nd and 3rd columns of
`$Presence_and_Absence_Matrix_env`) are z-scored before computing
distances. Geographic isolation is summarized with
[`summary()`](https://rdrr.io/r/base/summary.html) of pairwise distances
among geographic cells that collapse to the same environmental cell.

## Caveats

\(1\) The code assumes the first column of
`$Presence_and_Absence_Matrix_env` indexes environmental cells and
columns 2–3 are the two environmental variables. (2) The geographic
matrix assumes lon/lat at columns 3–4. Adjust indices if needed. (3) If
there are no zero-richness cells or \< 3 occupied env cells, border
metrics are returned as `NA`.

## See also

[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md),
[`lets.plot.envcells`](https://brunovilela.github.io/letsR/reference/lets.plot.envcells.md),
[`lets.plot.envpam`](https://brunovilela.github.io/letsR/reference/lets.plot.envpam.md)

## Examples

``` r
if (FALSE) { # \dontrun{
data("Phyllomedusa"); data("prec"); data("temp")
prec <- unwrap(prec); temp <- unwrap(temp)
PAM  <- lets.presab(Phyllomedusa, remove.cells = FALSE)
envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
colnames(envs) <- c("Temperature", "Precipitation")
wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
PAM <- lets.pamcrop(PAM, terra::vect(wrld_simpl))
res <- lets.envpam(PAM, envs, n_bins = 30)
out <- lets.envcells(res, perc = 0.2)
lets.plot.envcells(res, out)
} # }
```
