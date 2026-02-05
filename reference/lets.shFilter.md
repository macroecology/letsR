# Filter species' shapefiles based on its presence, origin, and season

Filter species shapefiles by origin, presence, and seasonal type
(following IUCN types:
<https://www.iucnredlist.org/resources/spatial-data-download>, see
metadata).

## Usage

``` r
lets.shFilter(shapes, presence = NULL, origin = NULL, seasonal = NULL)
```

## Arguments

- shapes:

  Object of class `SpatVect` or `Spatial` (see packages terra and sf to
  read these files) containing the distribution of one or more species.
  Species names should be stored in the object as BINOMIAL/binomial or
  SCINAME/sciname.

- presence:

  A vector with the code numbers for the presence type to be considered
  in the process (for IUCN spatial data
  <https://www.iucnredlist.org/resources/spatial-data-download>, see
  metadata).

- origin:

  A vector with the code numbers for the origin type to be considered in
  the process (for IUCN spatial data).

- seasonal:

  A vector with the code numbers for the seasonal type to be considered
  in the process (for IUCN spatial data).

## Value

The result is the shapefile(s) filtered according to the selected types.
If the filters remove all polygons, the result will be NULL.

## Details

Presence codes: (1) Extant, (2) Probably Extant, (3) Possibly Extant,
(4) Possibly Extinct, (5) Extinct (post 1500) & (6) Presence Uncertain.

Origin codes: (1) Native, (2) Reintroduced, (3) Introduced, (4) Vagrant
& (5) Origin Uncertain.

Seasonal codes: (1) Resident, (2) Breeding Season, (3) Non-breeding
Season, (4) Passage & (5) Seasonal Occurrence Uncertain.

More info in the shapefiles' metadata.

## See also

[`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md)

[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)

[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)

## Author

Bruno Vilela

## Examples

``` r
if (FALSE) { # \dontrun{
data(Phyllomedusa)

filtered_shape <- lets.shFilter(
  shape = Phyllomedusa,
  presence = 1,
  origin = 1,
  seasonal = 1)
  
if (!is.null(filtered_shape)) {
   plot(filtered_shape, col = "lightgreen", border = "darkgreen")
}
} # } 
```
