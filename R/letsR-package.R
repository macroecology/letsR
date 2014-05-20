#'R functions for handling and analyzing geographic data, mainly species' geographic distributions (in ESRI shapefile format) and environmental variables (in raster format), as well as species' information related to their description (e.g. taxonomy and year of description) and conservation status (e.g. category of threat, population trend) as provided by the IUCN's RedList database. The package includes functions to create presence-absence matrices based on species distributions and user-defined grid systems, from which several other functions could be applied to generate, for example, species richness rasters and maps, and geographical midpoints of species. In addition, it provides a function to create spatial correlograms of variables, based on the Moran's I index, under the equiprobable or equidistant criterion to define distance classes.
#'The letsR package is in continuous development and suggestions are more than welcome!
#'We hope you enjoy it and find it useful.
#'
#' @name letsR
#' @aliases letsR-package
#' @docType package
#' @title Tools for data handling and analysis in  macroecology.
#' 
#' @author Bruno Vilela \email{brunovilelasilva@@hotmal.com}
#' @author Fabricio Villalobos \email{fabricio.villalobos@@gmail.com} 
#' 
#' @keywords package
#'
#' @details \tabular{ll}{
#' Package: \tab lestR\cr
#' Type: \tab Package\cr
#' Version: \tab 1.0\cr
#' Date: \tab 2014-05-05\cr
#' License: \tab GPL-2\cr
#' }
#' 
#' @import raster geosphere XML maptools maps sp

NULL