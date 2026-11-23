# Changelog

## letsR 6.1.0

### New features

- Added
  [`lets.range()`](https://brunovilela.github.io/letsR/reference/lets.range.md),
  a new function for estimating species geographic ranges from
  occurrence records using DBSCAN spatial clustering and buffered
  concave hulls. The new function supports multiple spatial clusters per
  species, isolated occurrence records, flexible buffering distances,
  and geographic masking through intersection or exclusion.
- Added
  [`lets.smooth()`](https://brunovilela.github.io/letsR/reference/lets.smooth.md),
  a new function for estimating continuous patterns from incomplete
  observations in environmental, attribute, and other raster-based
  spaces using Gaussian kernel regression (Nadaraya-Watson estimator).

### Improvements

- Improved geographic range estimation workflows by integrating
  occurrence-based range reconstruction with existing letsR functions.
- Improved the documentation of
  [`lets.correl()`](https://brunovilela.github.io/letsR/reference/lets.correl.md),
  clarifying distance classes, statistical inference, and interpretation
  of Moran’s I correlograms.
- Introduced kernel-based interpolation to explore continuous
  biodiversity patterns in incompletely sampled environmental and
  attribute spaces, including applications to species richness and other
  numerical raster variables.
- Implemented automatic bandwidth selection in
  [`lets.smooth()`](https://brunovilela.github.io/letsR/reference/lets.smooth.md)
  by minimizing leave-one-out prediction errors, while retaining
  user-defined smoothing parameters.
- Improved the handling of missing raster values during smoothing by
  using normalized Gaussian weights rather than treating missing
  observations as zeros.
- Added support for restricting interpolated surfaces to geometric
  boundaries defined by observed cells, reducing extrapolation beyond
  the selected domain.
- Added unit tests for
  [`lets.smooth()`](https://brunovilela.github.io/letsR/reference/lets.smooth.md),
  covering kernel interpolation, bandwidth optimization, raster
  geometry, hull restrictions, and input validation.

### Documentation

- Added a vignette demonstrating
  [`lets.range()`](https://brunovilela.github.io/letsR/reference/lets.range.md),
  including spatial clustering, geographic masking, and integration with
  [`lets.presab()`](https://brunovilela.github.io/letsR/reference/lets.presab.md).
- Added a vignette demonstrating
  [`lets.correl()`](https://brunovilela.github.io/letsR/reference/lets.correl.md)
  using climatic data and exploring autocorrelation across geographic,
  environmental, and phylogenetic distance matrices.
- Added a vignette exploring theoretical and observed ecological spaces
  and demonstrating how
  [`lets.smooth()`](https://brunovilela.github.io/letsR/reference/lets.smooth.md)
  can be used to estimate continuous patterns from incomplete sampling
  in environmental and attribute spaces.
- Included examples comparing different sampling intensities, automatic
  bandwidth selection, and geometric constraints on kernel-based
  interpolation.
- Expanded the discussion of the differences between occurrence-based
  range estimates and IUCN geographic range mapping approaches.
- Documented the assumptions and limitations of kernel-based
  interpolation, particularly regarding sampling coverage,
  extrapolation, and the interpretation of unobserved environmental and
  attribute combinations.

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
