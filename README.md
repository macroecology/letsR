letsR
=====

## Package letsR

This package provides different functions for data handling and analysis in macroecology. It is being developed at LETS (Laboratório de Ecologia Teórica e Síntese) in UFG (Universidade Federal de Goiás, Brazil) as part of a larger project looking to integrate recent advances in macroecological data handling and processing. Its purpose is to make some of our commonly used but unavailable R functions available to the larger public. The package provides useful R functions for researchers in ecology and evolution.

The letsR package is in continuous development and suggestions are more than welcome!

We hope you enjoy it and find it useful.

====
## Install

Install `letsR` from CRAN

```coffee
install.packages("letsR")
library("letsR")
```
Install `letsR` developing version from github


```coffee
install.packages("devtools")
library(devtools)
install_github("macroecology/letsR")
library(letsR)
```

OBS.: To download the developers version you will need to have the git software installed (http://git-scm.com/).
If you are a windows user you will also need to download the Rtools (http://cran.r-project.org/bin/windows/Rtools/).


## Key functions

The `letsR` package includes many different functions. Below we highlight some them:

- `lets.presab`: Builts a presence-absence matrix (sites x species) based on species’ range maps from shapefiles.
- `lets.presab.birds`: Builts a presence-absence matrix (sites x species) based on species’ range maps from shapefiles (specially designed for the BirdLife International database).
- `lets.shFilter`: Filter species’ shapefiles by origin, presence and seasonal type (following IUCN categorization of species’ distributional ranges).
- `lets.addvar`: Add variables in raster format to a presence-absence matrix.
- `lets.addpoly`: Add variables in polygon format to a presence-absence matrix.
- `lets.iucn`: Get species’ information from the IUCN website (different from `taxize` version).
- `lets.iucn.ha`: Get species’ habitat information from the IUCN website.
- `lets.iucn.his`: Get information on the history of species’ conservation status from the IUCN website.

Take a look at the functions' help files for more information.



