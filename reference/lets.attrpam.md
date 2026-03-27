# Attribute-space Presence–Absence Matrix (attrPAM)

Builds a presence–absence matrix (PAM) in a two-dimensional trait space,
by binning species occurrences along two quantitative attributes (e.g.,
body size and mass). Each species can have one or multiple entries in
the trait dataset.

## Usage

``` r
lets.attrpam(
  x,
  n_bins = 10,
  remove.cells = TRUE,
  remove.sp = TRUE,
  count = FALSE
)
```

## Arguments

- x:

  A data frame where the first column contains species (character
  vector), and the next two columns contain numeric trait values (2D
  space).

- n_bins:

  Integer. Number of bins per axis (default = 10).

- remove.cells:

  Logical. Should cells with no species be removed from the final
  matrix?

- remove.sp:

  Logical. Should species with no occurrences in attribute space be
  removed?

- count:

  Logical. If \`TRUE\`, displays a progress bar for species processing.

## Value

A list with two components:

- `PAM_attribute`: a matrix with cell ID, trait coordinates, and species
  presence (0/1).

- `Attr_Richness_Raster`: a raster of richness (number of species) in
  trait space.

## Details

Create a Presence–Absence Matrix in Trait Space

The two trait axes are divided into equal-interval bins, generating a
grid of \`n_bins × n_bins\` cells. Each species occurrence is assigned
to a cell, and the resulting PAM indicates which species are present in
each trait cell.

## Examples

``` r
if (FALSE) { # \dontrun{
n <- 2000
Species <- paste0("sp", 1:n)
trait_a <- rnorm(n)
trait_b <- trait_a * .2 + rnorm(n)
x <- data.frame(Species, trait_a, trait_b)
test <- lets.attrpam(x, n_bins = 30)
lets.plot.attrpam(test)
} # }
```
