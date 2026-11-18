# Changelog

## letsR 6.1.0

### New features

- Added
  [`lets.range()`](https://brunovilela.github.io/letsR/reference/lets.range.md),
  a new function for estimating species geographic ranges from
  occurrence records using DBSCAN spatial clustering and buffered
  concave hulls.
- The new function supports multiple spatial clusters per species,
  isolated occurrence records, flexible buffering distances, and
  geographic masking through intersection or exclusion.
- Added support for handling complex range geometries, including
  multipart polygons and ranges crossing the antimeridian.

### Improvements

- Improved geographic range estimation workflows by integrating
  occurrence-based range reconstruction with existing letsR functions.
- Added compatibility checks for GEOS versions required for concave hull
  construction.
- Improved the documentation of
  [`lets.correl()`](https://brunovilela.github.io/letsR/reference/lets.correl.md),
  clarifying distance classes, statistical inference, and interpretation
  of Moran’s I correlograms.

### Documentation

- Added a vignette demonstrating
  [`lets.range()`](https://brunovilela.github.io/letsR/reference/lets.range.md),
  including spatial clustering, geographic masking, and integration with
  [`lets.presab()`](https://brunovilela.github.io/letsR/reference/lets.presab.md).
- Added a methodological comparison of geographic range estimation using
  [`lets.range()`](https://brunovilela.github.io/letsR/reference/lets.range.md),
  `alphahull`, and `rangeBuilder`.
- Added a vignette demonstrating
  [`lets.correl()`](https://brunovilela.github.io/letsR/reference/lets.correl.md)
  using climatic data and exploring autocorrelation across geographic,
  environmental, and phylogenetic distance matrices.
- Expanded the discussion of the differences between occurrence-based
  range estimates and IUCN geographic range mapping approaches.

### Dependencies and compatibility

- Added `dbscan` to package imports.
- Updated the minimum required version of `sf` to 1.0-11.
- Documented the requirement for GEOS 3.11.0 or later for concave hull
  construction.

### Citation

- Updated the package citation to include Vilela et al. (2026),
  alongside the original letsR publication by Vilela and Villalobos
  (2015).

------------------------------------------------------------------------

## letsR 6.0.0

### New features

- Added functions for mapping biodiversity across geographic,
  environmental, and attribute spaces.
- Added new vignettes describing environmental-space and attribute-space
  analyses.

### Documentation

- Reorganized the package documentation to improve accessibility.
- Added an annotated documentation index to the README.

### Improvements

- Updated functions to use current `terra` and `sf` workflows.
- Improved plotting and summary methods for `PresenceAbsence` objects.
