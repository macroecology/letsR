# Plot species richness in environmental and geographical space

This function plots species richness in both environmental and
geographical space based on the output of
[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md).
It can optionally highlight species distributions, individual cells, or
regions in both spaces.

## Usage

``` r
lets.plot.envpam(
  x,
  species = NULL,
  cell_id_env = NULL,
  cell_id_geo = NULL,
  geo_plot = TRUE,
  env_plot = TRUE,
  world = TRUE,
  rast_return = FALSE,
  col_rich = NULL,
  ...
)
```

## Arguments

- x:

  The output object from
  [`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md)).

- species:

  A character string indicating the species name to be highlighted in
  both plots.

- cell_id_env:

  An integer or vector of integers indicating environmental space
  cell(s) to be highlighted.

- cell_id_geo:

  An integer or vector of integers indicating geographic cell(s) to be
  highlighted.

- geo_plot:

  Logical. Should the geographic richness map also be plotted? Default
  is TRUE.

- env_plot:

  Logical. Should the environmental space richness map also be plotted?
  Default is TRUE.

- world:

  Logical. If TRUE, plots a base map using the \`wrld_simpl\` object
  from the \`letsR\` package over the geographic raster.

- rast_return:

  Logical. If TRUE, returns the modified raster objects instead of
  plotting.

- col_rich:

  A custom color ramp palette function to use for plotting richness
  (e.g., from `colorRampPalette`).

- ...:

  Additional arguments passed to the
  [`plot`](https://rdrr.io/r/graphics/plot.default.html) function for
  rasters.

## Details

This function provides a visual summary of species richness across both
geographic and environmental dimensions. Users can highlight specific
species or environmental/geographical cells. When a highlight is
selected, both rasters are modified to display only presences related to
the selected species or cells, and all other cells are greyed out.

## See also

[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md),
[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md),
[`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md)

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

# Create environmental PAM
res <- lets.envpam(PAM, envs)

# Plot both spaces
lets.plot.envpam(x = res,
            species = NULL,
            cell_id_env = NULL,
            cell_id_geo = NULL,
            geo_plot = TRUE,
            world = TRUE,
            mar = c(4, 4, 4, 4))

# Highlight a single species
lets.plot.envpam(res, species = "Phyllomedusa_atlantica")
} # }
```
