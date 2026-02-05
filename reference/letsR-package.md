# Tools for Data Handling and Analysis in Macroecology.

The letsR package is being developed to help researchers in the
handling, processing, and analysis of macroecological data. Its purpose
is to integrate these methodological processes into a single software
platform for macroecological analyses. The package's main functions
allow users to build presence-absence matrices, the basic analytical
tool in macroecology, from species' geographical distributions and merge
them with species' traits, conservation information (downloadable using
functions from this package) and spatial environmental layers. In
addition, other package's functions enable users to summarize and
visualize information from presence-absence matrices.

## Details

All functions in this package use a prefix and a suffix separated by a
dot. The prefix refers to the package's name and the suffix to the
actual function. This is done to avoid confusion with potentially
similarly-named functions from other R packages. For instance, the letsR
function used to create presence-absence matrices is called
[`lets.presab`](https://brunovilela.github.io/letsR/reference/lets.presab.md)
(but see also
[`lets.presab.birds`](https://brunovilela.github.io/letsR/reference/lets.presab.birds.md)
and
[`lets.presab.points`](https://brunovilela.github.io/letsR/reference/lets.presab.points.md))
whereas the one used to add variables to a presence-absence matrix is
called
[`lets.addvar`](https://brunovilela.github.io/letsR/reference/lets.addvar.md).
The package's basic functions create and work on a particular S3 object
class called `PresenceAbsence`. Such
[`PresenceAbsence`](https://brunovilela.github.io/letsR/reference/PresenceAbsence.md)
object class allows storing information beyond presence-absence data
(e.g. user-defined grid-cell system) and using the generic `plot`,
`summary` and `print` functions of R. Also, some package's functions
allow the user to input customary R objects (e.g. `vector`, `matrix`,
`data.frame`).

If you are looking for the most recent version of the package, you can
get the development version of letsR on github
(<https://github.com/macroecology/letsR>).

|          |            |
|----------|------------|
| Package: | lestR      |
| Type:    | Package    |
| Version: | 3.1        |
| Date:    | 2018-01-24 |
| License: | GPL-2      |

## References

Vilela, B., & Villalobos, F. (2015). letsR: a new R package for data
handling and analysis in macroecology. Methods in Ecology and Evolution.

## Author

**Bruno Vilela**  
(email: <bvilela@wustl.edu>; Website: <https://bvilela.weebly.com/>)

**Fabricio Villalobos**  
(email: <fabricio.villalobos@gmail.com>; Website:
<https://fabro.github.io>)
