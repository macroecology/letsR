# Map envPAM descriptors

Plots each column of the descriptor table returned by
[`lets.envcells`](https://brunovilela.github.io/letsR/reference/lets.envcells.md)
back onto the environmental richness raster embedded in the envPAM
object. Rows with zero frequency are masked as `NA`.

## Usage

``` r
lets.plot.envcells(
  x,
  y,
  ras = FALSE,
  plot_ras = TRUE,
  mfrow = c(4, 4),
  which.plot = NULL,
  col_func = NULL,
  ...
)
```

## Arguments

- x:

  The envPAM list returned by
  [`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md)
  (must include `$Env_Richness_Raster` and
  `$Presence_and_Absence_Matrix_env`).

- y:

  A `data.frame` returned by
  [`lets.envcells`](https://brunovilela.github.io/letsR/reference/lets.envcells.md)
  with one row per environmental cell (aligned with `x`).

- ras:

  Logical; if `TRUE`, returns a named list of terra SpatRaster layers
  corresponding to each column plotted. Default `FALSE`.

- plot_ras:

  Logical; if `TRUE`, the function plot the graphs. Default `TRUE`.

- mfrow:

  A vector of the form c(nr, nc). The figures will be drawn in an
  nr-by-nc array on the device by rows as in par documentation.

- which.plot:

  Indicate the number of the columns in y to be ploted.

- col_func:

  A custom color ramp palette function to use for plotting variables
  (e.g., from `colorRampPalette`).

- ...:

  other arguments passed to
  [`terra::plot`](https://rspatial.github.io/terra/reference/plot.html)
  function.

## Value

Invisibly returns `NULL`. If `ras = TRUE`, returns a named list of
[SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
objects corresponding to each descriptor column.

## Details

Plot environmental descriptors over the environmental raster grid

Each descriptor column is assigned as values of the environmental raster
template and plotted sequentially. The plotting grid defaults to
`par(mfrow = c(4,4))`.

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
