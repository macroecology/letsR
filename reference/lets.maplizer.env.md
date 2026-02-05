# Map species attributes in both environmental and geographic spaces

Summarize species-level attributes (e.g., traits or conservation data)
within each cell of environmental and geographic presence–absence
matrices, enabling trait-based mapping across environmental gradients
and geographic space.

## Usage

``` r
lets.maplizer.env(x, y, z, func = mean, ras = TRUE, weighted = FALSE)
```

## Arguments

- x:

  An object produced by
  [`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md).

- y:

  A numeric vector containing the species attributes to be summarized
  (e.g., description year, body size).

- z:

  A character vector with species names corresponding to the values in
  `y`. These names must match the species columns in the
  presence-absence matrices in \`x\`.

- func:

  A function used to summarize the attribute across species in each cell
  (e.g., `mean`, `median`, `sum`). Must return a single numeric value.

- ras:

  Logical. If `TRUE`, the result includes the attribute maps as
  `SpatRaster` objects.

- weighted:

  If TRUE, argument func is ignored, and weighted mean is calculated.
  Weights are attributed to each species according to 1/N cells that the
  species occur.

## Value

A list with the following elements:

- `Matrix_env`: A matrix with summarized attribute values in
  environmental space.

- `Matrix_geo`: A matrix with summarized attribute values in geographic
  space.

- `Env_Raster`: A `SpatRaster` with the attribute values mapped in
  environmental space.

- `Geo_Raster`: A `SpatRaster` with the attribute values mapped in
  geographic space.

## Details

This function is useful for trait-based macroecological analyses that
aim to understand how species attributes vary across environments or
space. It uses the output of
[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md),
applies a summary function to the trait values of all species present in
each cell, and returns raster layers for visualization.

## See also

[`lets.envpam`](https://brunovilela.github.io/letsR/reference/lets.envpam.md),
[`lets.maplizer`](https://brunovilela.github.io/letsR/reference/lets.maplizer.md),
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
data("IUCN")

prec <- unwrap(prec)
temp <- unwrap(temp)
PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
colnames(envs) <- c("Temperature", "Preciptation")
wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
PAM <- lets.pamcrop(PAM, vect(wrld_simpl))

# Create environmental PAM
res <- lets.envpam(PAM, envs, remove.cells = FALSE)

# Map mean description year
res_map <- lets.maplizer.env(res, 
                             y = IUCN$Description_Year,
                             z = IUCN$Species)

# Plotting trait maps
lets.plot.envpam(res_map)
} # }
```
