#'R functions for handling, processing, and analyzing geographic data on species’ distributions and environmental variables
#'
#'The letsR package is being developed to help researchers in the handling, processing, 
#'and analysis of macroecological data. Its purpose is to integrate these methodological processes 
#'into a single software platform for macroecological analyses. 
#'The package’s main functions allow users to build presence-absence matrices, the basic analytical tool in macroecology, 
#'from species’ geographical distributions and merge them with species’ traits, conservation information 
#'(downloadable using functions from this package) and spatial environmental layers.  
#'In addition, other package’s functions enable users to summarize and visualize information from presence-absence matrices.
#'
#'All functions in this package use a prefix and a suffix separated by a dot. 
#'The prefix refers to the package’s name and the suffix to the actual function. 
#'This is done to avoid confusion with potentially similarly-named functions from other R packages. 
#'For instance, the letsR function used to create presence-absence matrices is called lets.presab, 
#'whereas the one used to add variables to a presence-absence matrix is called lets.addvar.  
#'The package’s basic functions create and work on a particular S3 object class called ‘PresenceAbsence’. 
#'Such ‘PresenceAbsence’ object class allows storing information beyond presence-absence data 
#'(e.g. user-defined grid-cell system) and using the generic ‘plot’, ‘summary’ and ‘print’ functions of R. 
#'Also, some package’s functions allow the user to input customary R objects (e.g. ‘vector’, ‘matrix’, ‘data.frame’). 
#'
#'Another set of functions in this package allow the user to download species’ information related to 
#'their description and conservation status as provided by the IUCN’s REdList database. 
#'For this, such functions use the IUCN’s RedList API to retrieve information from its webpage.
#'
#'
#' @name letsR
#' @aliases letsR-package
#' @docType package
#' @title Tools for Data Handling and Analysis in  Macroecology.
#' 
#' @author Bruno Vilela \email{brunovilelasilva@@hotmal.com}
#' @author Fabricio Villalobos \email{fabricio.villalobos@@gmail.com} 
#' 
#' @keywords package
#'
#' @details \tabular{ll}{
#' Package: \tab lestR\cr
#' Type: \tab Package\cr
#' Version: \tab 2.0\cr
#' Date: \tab 2015-02-09\cr
#' License: \tab GPL-2\cr
#' }
#' 
#' @import raster geosphere XML maptools maps sp rgdal fields
NULL
