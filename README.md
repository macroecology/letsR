letsR
=====

Package letsR

This is a package developed in UFG (Universidade Federal de Goiás), 
specifically in LETS (Laboratório de Ecologia Teórica e Síntese).

It has some usefull functions for researchers in ecology and evolution.

The package is in continuos development. Suggestions are welcome!!

We hope you enjoy it.


=====
Here are some advices:

You can download this package using the function install_git from the package devtools. 

For properly work of this version you may install and load the following packages:
- maps
- maptools
- raster
- XML

The main functions of the letsR package are:

- lets.presab: Transform species shapefiles into a matrix of presence/absence. 
- lets.presab.birds: Transform species shapefiles into a matrix of presence/absence (specially desinged for bird life output).
- lets.addvar: Add variables in raster format to a presence/absence matrix.
- lets.iucn: Get species information from IUCN website for one or more species.
- lets.iucn.ha: Get species habitat information from IUCN website for one or more species.
- lets.iucn.his: Get species conservation status history information from IUCN website for one or more species.
- lets.shFilter: Filter species shapefiles by origin, presence and seasonal type (following IUCN types).

Look functions' help files for more informations.

Try the functions summary and plot with the object of class PresenceAbsence.
