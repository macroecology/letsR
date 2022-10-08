[![R-CMD-check](https://github.com/BrunoVilela/letsR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/BrunoVilela/letsR/actions/workflows/R-CMD-check.yaml)
[![Coverage Status](https://coveralls.io/repos/BrunoVilela/letsR/badge.svg)](https://coveralls.io/github/BrunoVilela/letsR)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/letsR)](https://CRAN.R-project.org/package=letsR)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/letsR)]( https://github.com/r-hub/cranlogs.app)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/grand-total/letsR)]( https://github.com/r-hub/cranlogs.app)
[![Research software impact](http://depsy.org/api/package/cran/letsR/badge.svg)](http://depsy.org/package/r/letsR)

=====
## IMPORTANT
Due to changes in the IUCN API and to limitations in data distribution stabilished IUCN terms of use, we are no longer mataining the functions lets.iucn, lets.iucn.hist and lets.iucn.ha. These functions will be removed from the package in the next version. We apologize for any incovinience this may cause.  

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

## Package publication
http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12401/abstract

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

