# Subset an environmental PAM by species names

Subsets an environmental-space presence-absence matrix (PAM) generated
by
[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md)
by retaining only a selected set of species. Species not included in
`species` are removed from both tabular components of the object, and
species richness is recalculated and written back to the corresponding
raster layers.

## Usage

``` r
lets.subsetPAMenv(x, species, remove.cells = TRUE)
```

## Arguments

- x:

  An environmental PAM produced by
  [`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md).

- species:

  A character vector with species names to retain in the PAM.

- remove.cells:

  Logical. If `TRUE`, rows with zero richness after subsetting are
  removed from matrices. Default is `TRUE`.

## Value

A list with the same structure as the input object:

- `x[[1]]`: the subsetted env PAM table.

- `x[[2]]`: the subsetted geo PAM table.

- `x[[3]]`: the raster associated with env PAM, updated with
  recalculated richness values.

- `x[[4]]`: the raster associated with geo PAM, updated with
  recalculated richness values.

## Details

Optionally, cells with zero richness after subsetting can be removed
from the tabular components.

If none of the supplied species names match the species present in the
PAM, the function stops with an error before modifying the object.

## See also

[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md),
[`lets.plot.envpam`](https://brunovilela.github.io/letsR/reference/lets.plot.envpam.md),
[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md),
[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md)

## Examples

``` r
if (FALSE) { # \dontrun{
data("Phyllomedusa")
data("prec")
data("temp")

prec <- unwrap(prec)
temp <- unwrap(temp)

PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
colnames(envs) <- c("Temperature", "Precipitation")
wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
PAM <- lets.pamcrop(PAM, vect(wrld_simpl))

res <- lets.envpam(PAM, envs)

lets.plot.envpam(
  x = res,
  species = NULL,
  cell_id_env = NULL,
  cell_id_geo = NULL,
  plot.grid = TRUE,
  world = TRUE,
  mar = c(4, 4, 4, 4)
)

sub <- sample(PAM$Species_name, 10)
pam_sub <- lets.subsetPAMenv(res, sub)
lets.plot.envpam(pam_sub)
} # }
```
