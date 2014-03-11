letsR
=====

Package letsR

This package is being developed at LETS (Laboratório de Ecologia Teórica e Síntese) in UFG (Universidade Federal de Goiás, Brazil) as part of a larger project looking to integrate recent advances in macroecological data handling and processing. Its purpose is to make some of our commonly used but unavailable R functions available to the larger public. The package provides useful R functions for researchers in ecology and evolution.

The letsR package is in continuous development and suggestions are more than welcome!

We hope you enjoy it and find it useful.

====
Here are a few advices about using the letsR package:
You can download this package using the function install_git from the package devtools.

For this package version to work properly, you should previously install and load the following R packages:
- maps 
- maptools 
- raster 
- XML

The main functions of the letsR package are the following:
- lets.presab: Builts a presence-absence matrix (sites x species) based on species’ range maps from shapefiles.
- lets.presab.birds: Builts a presence-absence matrix (sites x species) based on species’ range maps from shapefiles (specially designed for the BirdLife International database).
- lets.shFilter: Filter species’ shapefiles by origin, presence and seasonal type (following IUCN categorization of species’ distributional ranges).
- lets.addvar: Add variables in raster format to a presence-absence matrix.
- lets.iucn: Get species’ information from the IUCN website.
- lets.iucn.ha: Get species’ habitat information from the IUCN website.
- lets.iucn.his: Get information on the history of species’ conservation status from the IUCN website.

Take a look at the functions' help files for more information.

Try the R functions summary() and plot() with the object of class PresenceAbsence.
