[![Travis-CI Build Status](https://travis-ci.org/BrunoVilela/letsR.png?branch=master)](https://travis-ci.org/BrunoVilela/letsR)
[![Coverage Status](https://coveralls.io/repos/BrunoVilela/letsR/badge.svg)](https://coveralls.io/r/BrunoVilela/letsR)

letsR
=====

## Package letsR

The letsR package is being developed to help researchers in the handling, processing, and analysis of macroecological data. Its purpose is to integrate these methodological processes into a single software platform for macroecological analyses. The package's main functions allow users to build presence-absence matrices, the basic analytical tool in macroecology, from species' geographical distributions and merge them with species' traits, conservation information(downloadable using functions from this package) and spatial environmental layers. In addition, other package's functions enable users to summarize and visualize information from presence-absence matrices.

All functions in this package use a prefix and a suffix separated by a dot. 
The prefix refers to the package's name and the suffix to the actual function. 
This is done to avoid confusion with potentially similarly-named functions from other R packages. 
For instance, the letsR function used to create presence-absence matrices is called `lets.presab` (but see also `lets.presab.birds` and `lets.presab.points`) whereas the one used to add variables to a presence-absence matrix is called `lets.addvar`.  
The package's basic functions create and work on a particular S3 object class called `PresenceAbsence`. 
Such `PresenceAbsence` object class allows storing information beyond presence-absence data (e.g. user-defined grid-cell system) and using the generic `plot`, `summary` and `print` functions of R. 
Also, some package's functions allow the user to input customary R objects (e.g. `vector`, `matrix`, `data.frame`. 

Another set of functions in this package allow the user to download species' information related to their description and conservation status as provided by the IUCN's REdList database (`lets.iucn`,
`lets.iucn.ha`, `lets.iucn.his`). For this, such functions use the IUCN's RedList API to retrieve information from its webpage.

The letsR package is in continuous development and suggestions are more than welcome!

We hope you enjoy it and find it useful.

====
## Install

Install `letsR` from CRAN

```coffee
install.packages("letsR")
library("letsR")
```
Install `letsR` developers version from github


```coffee
install.packages("devtools")
library(devtools)
install_github("macroecology/letsR")
library(letsR)
```

OBS.: To download the developers version you will need to have the git software installed (http://git-scm.com/).
If you are a windows user you will also need to download the Rtools (http://cran.r-project.org/bin/windows/Rtools/).


## Key functions

The `letsR` package includes many different functions. Below we highlight some of them:

- `lets.presab`: Builts a presence-absence matrix (sites x species) based on species’ range maps from shapefiles.
- `lets.presab.birds`: Builts a presence-absence matrix (sites x species) based on species’ range maps from shapefiles (specially designed for the BirdLife International database).
- `lets.addvar`: Add variables in raster format to a presence-absence matrix.
- `lets.addpoly`: Add variables in polygon format to a presence-absence matrix.
- `lets.iucn`: Get species’ information from the IUCN website.
- `lets.iucn.ha`: Get species’ habitat information from the IUCN website.
- `lets.iucn.his`: Get information on the history of species’ conservation status from the IUCN website.

Take a look at the functions' help files for more information.



