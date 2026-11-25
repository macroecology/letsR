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
| Package: | letsR      |
| Type:    | Package    |
| Version: | 6.1        |
| Date:    | 2026-07-24 |
| License: | GPL-2      |

## References

Vilela, B., & Villalobos, F. (2015). letsR: a new R package for data
handling and analysis in macroecology. Methods in Ecology and Evolution.

## Author

**Authors:**

**Bruno Vilela**  
Email: <bvilela.bv@gmail.com>  
ORCID: <https://orcid.org/0000-0003-4072-0558>  
Website: <https://bvilela.com>

**Fabricio Villalobos**  
Email: <fabricio.villalobos@gmail.com>  
ORCID: <https://orcid.org/0000-0002-5230-2217>

**Contributors:**

Bruna M. Farina (<https://orcid.org/0000-0001-6506-3801>)  
Ricardo Dobrovolski (<https://orcid.org/0000-0002-8775-5486>)  
Sidney F. Gouveia (<https://orcid.org/0000-0003-4941-7440>)  
José Alexandre F. Diniz-Filho
(<https://orcid.org/0000-0002-0967-9684>)  
Thiago F. Rangel (<https://orcid.org/0000-0002-2001-7382>)  
Trevor S. Fristoe (<https://orcid.org/0000-0002-3894-8126>)  
Carlos Calderón del Cid (<https://orcid.org/0000-0002-3897-4615>)  
Marco Túlio Pacheco Coelho (<https://orcid.org/0000-0002-7831-3053>)  
Catherine H. Graham (<https://orcid.org/0000-0001-9267-7948>)
