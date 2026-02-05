# Create a presence–absence matrix in environmental space

Transform a presence–absence matrix (PAM) based on geographic
coordinates into a new PAM structured in environmental space. The
function rasterizes the environmental variable space (based on two
continuous environmental predictors), and assigns species presences to
binned environmental conditions, producing a species richness raster in
environmental space.

## Usage

``` r
lets.envpam(
  pam,
  envs,
  n_bins = 30,
  remove.cells = TRUE,
  remove.sp = TRUE,
  count = FALSE
)
```

## Arguments

- pam:

  A \`PresenceAbsence\` object, typically created using
  [`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md).

- envs:

  A two-column matrix or data frame with continuous environmental
  variables corresponding to the coordinates in the PAM. The first
  column will be used as the x-axis and the second as the y-axis in the
  environmental space.

- n_bins:

  Number of bins used to discretize each environmental variable. Default
  is 30.

- remove.cells:

  Logical. Should cells with no species be removed from the final
  matrix?

- remove.sp:

  Logical. Should species with no occurrences in environmental space be
  removed?

- count:

  Logical. If TRUE, displays a progress bar for species processing.

## Value

A list with the following elements:

- `Presence_and_Absence_Matrix_env`: A matrix of species presences
  across environmental bins.

- `Presence_and_Absence_Matrix_geo`: The original PAM coordinates
  associated with environmental cells.

- `Env_Richness_Raster`: A raster layer of species richness in
  environmental space.

- `Geo_Richness_Raster`: The original species richness raster in
  geographic space.

## Details

This function projects species occurrences into a two-dimensional
environmental space, facilitating ecological analyses that depend on
environmental gradients. The environmental space is discretized into a
regular grid (determined by `n_bins`), and each cell is assigned the
number of species occurring under those environmental conditions.

## See also

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md),
[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md),
[`lets.plot.envpam`](https://brunovilela.github.io/letsR/reference/lets.plot.envpam.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
# Load data
data("Phyllomedusa")
data("prec")
data("temp")

prec <- unwrap(prec)
temp <- unwrap(temp)
PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
colnames(envs) <- c("Temperature", "Preciptation")
wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
PAM <- lets.pamcrop(PAM, vect(wrld_simpl))

# Run function
res <- lets.envpam(PAM, envs)

# Plot results
lets.plot.envpam(x = res,
            species = NULL,
            cell_id_env = NULL,
            cell_id_geo = NULL,
            T,
            world = TRUE,
            mar = c(4, 4, 4, 4))
} # }
```
