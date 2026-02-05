# PresenceAbsence Class

The `PresenceAbsence` is a new S3 object class created and used inside
the
[`letsR`](https://brunovilela.github.io/letsR/reference/letsR-package.md)
package. This object class is used to store information on species
distribution within a geographic domain in the form of a
presence-absence matrix. In addition, the `PresenceAbsence` object also
contains other essential information (e.g. user-defined grid cell
system, including resolution, projection, datum, and extent) necessary
for other analysis performed with the package's functions.

## Details

**Creating a PresenceAbsence object**  
A `PresenceAbsence` object can be generated using the following
functions:  
-
[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)  
-
[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)  
-
[`lets.presab.points`](https://brunovilela.github.io/letsR/reference/lets.presab.points.md)  
  

**The PresenceAbsence information**  
The result is a `list` object of class `PresenceAbsence` that includes
the following objects:  
- Presence_and_Absence_Matrix: A matrix of species' presence(1) and
absence(0) information. The first two columns contain the longitude (x)
and latitude (y) of the cells' centroid (from the gridded domain
used);  
- Richness_Raster: A raster containing species richness information
across the geographic domain, which can be used to map the observed
geographic gradient in species richness;  
- Species_name: A character vector with species' names contained in the
matrix.  
  
Each of the objects can be obtained usign the standard subsetting
operators that are commonly applied to a `list` object (i.e. '\[\[' and
'\$').  
  

**letsR functions applied to a PresenceAbsence object**  
The following functions from the letsR package can be directly applied
to a `PresenceAbsence`:  
-
[`lets.addpoly`](https://brunovilela.github.io/letsR/reference/lets.addpoly.md)  
-
[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md)  
-
[`lets.distmat`](https://brunovilela.github.io/letsR/reference/lets.distmat.md)  
-
[`lets.field`](https://brunovilela.github.io/letsR/reference/lets.field.md)  
-
[`lets.gridirizer`](https://brunovilela.github.io/letsR/reference/lets.gridirizer.md)  
-
[`lets.maplizer`](https://brunovilela.github.io/letsR/reference/lets.maplizer.md)  
-
[`lets.midpoint`](https://brunovilela.github.io/letsR/reference/lets.midpoint.md)  
-
[`lets.overlap`](https://brunovilela.github.io/letsR/reference/lets.overlap.md)  
-
[`lets.pamcrop`](https://brunovilela.github.io/letsR/reference/lets.PAMcrop.md)  
-
[`lets.rangesize`](https://brunovilela.github.io/letsR/reference/lets.rangesize.md)  

**Generic functions applied to a PresenceAbsence object**  
The following generic functions can be directly applied to the
`PresenceAbsence` object.  
- `print`
([`print.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/print.PresenceAbsence.md))  
- `summary`
([`summary.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/summary.PresenceAbsence.md))  
- `plot`
([`plot.PresenceAbsence`](https://brunovilela.github.io/letsR/reference/plot.PresenceAbsence.md))  
  
