# Aggregate cell-wise metrics across occupied cells per species

Given a presence–absence matrix in either \*\*attribute space\*\* (from
[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md))
or \*\*environmental space\*\* (from
[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md))
and a table of \*\*per-cell descriptors\*\* (from
[`lets.attrcells`](https://brunovilela.github.io/letsR/reference/lets.attrcells.md)
or
[`lets.envcells`](https://brunovilela.github.io/letsR/reference/lets.envcells.md)),
this function aggregates each descriptor across the set of cells
\*\*occupied by each species\*\*, using a user-supplied summary function
(e.g., `mean`, `median`, `sum`).

## Usage

``` r
lets.summaryze.cells(x, y, func = mean)
```

## Arguments

- x:

  A list returned by
  [`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md)
  (attribute space) or
  [`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md)
  (environmental space). The first element `x[[1]]` must be a
  matrix/data.frame whose first three columns are the cell identifier
  and the two coordinate/axis columns; species presence–absence columns
  start at column 4.

- y:

  A `data.frame` of per-cell descriptors with the same row order as
  `x[[1]]`. The first column must be the cell identifier (e.g.,
  `Cell_attr` or `Cell_env`); descriptor columns start at column 2.

- func:

  A summary function to aggregate a descriptor across the cells occupied
  by a species (default `mean`). The function must return a single
  numeric value and should handle `na.rm` internally if needed (note
  that this routine already removes `NA`s per species via `na.omit`).

## Value

A `data.frame` with one row per species and one column per descriptor,
containing the aggregated (e.g., mean) value of each descriptor across
all cells where that species is present. The first column, `Species`,
holds the species names copied from `colnames(x[[1]])[4:ncol(x[[1]])]`.

## Details

Summarize per-cell descriptors to species-level values

Internally, for each species column in `x[[1]]` (starting at column 4),
the function builds a logical mask of \*\*occupied cells\*\* (\> 0). It
then subsets the descriptor table `y` to those rows and applies `func`
column-wise to `y[occupied, -1]` (dropping the ID column). Missing
values are removed with
[`stats::na.omit`](https://rdrr.io/r/stats/na.fail.html) prior to
aggregation.

## See also

[`lets.attrpam`](https://brunovilela.github.io/letsR/reference/lets.attrpam.md),
[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md),
[`lets.attrcells`](https://brunovilela.github.io/letsR/reference/lets.attrcells.md),
[`lets.envcells`](https://brunovilela.github.io/letsR/reference/lets.envcells.md)

## Examples

``` r
if (FALSE) { # \dontrun{
## --------------------------
## ATTRIBUTE SPACE WORKFLOW
## --------------------------
set.seed(1)
n <- 2000
Species <- paste0("sp", 1:n)
trait_a <- rnorm(n)
trait_b <- trait_a * 0.2 + rnorm(n)
df <- data.frame(Species, trait_a, trait_b)

# Build AttrPAM and compute per-cell descriptors
x_attr <- lets.attrpam(df, n_bins = 30)
y_attr <- lets.attrcells(x_attr)

# Summarize descriptors per species (e.g., mean across occupied cells)
head(lets.summaryze.cells(x_attr, y_attr, func = mean))

## ------------------------------
## ENVIRONMENTAL SPACE WORKFLOW
## ------------------------------
data("Phyllomedusa"); data("prec"); data("temp")
prec <- unwrap(prec); temp <- unwrap(temp)
PAM  <- lets.presab(Phyllomedusa, remove.cells = FALSE)
envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
colnames(envs) <- c("Temperature", "Precipitation")
wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
PAM <- lets.pamcrop(PAM, terra::vect(wrld_simpl))

res_env <- lets.envpam(PAM, envs, n_bins = 30)
y_env   <- lets.envcells(res_env, perc = 0.2)

# Summarize environmental-space descriptors per species
head(lets.summaryze.cells(res_env, y_env, func = mean))
} # }
```
