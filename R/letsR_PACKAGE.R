#'The letsR package is being developed to help researchers in the handling, processing, 
#'and analysis of macroecological data. Its purpose is to integrate these methodological processes 
#'into a single software platform for macroecological analyses. 
#'The package's main functions allow users to build presence-absence matrices, the basic analytical tool in macroecology, 
#'from species' geographical distributions and merge them with species' traits, conservation information 
#'(downloadable using functions from this package) and spatial environmental layers.  
#'In addition, other package's functions enable users to summarize and visualize information from presence-absence matrices.
#'
#'All functions in this package use a prefix and a suffix separated by a dot. 
#'The prefix refers to the package's name and the suffix to the actual function. 
#'This is done to avoid confusion with potentially similarly-named functions from other R packages. 
#'For instance, the letsR function used to create presence-absence matrices is called \code{\link{lets.presab}} (but see also
#'\code{\link{lets.presab.birds}} and \code{\link{lets.presab.points}}) whereas the one used to add variables to a 
#'presence-absence matrix is called \code{\link{lets.addvar}}.  
#'The package's basic functions create and work on a particular S3 object class called \code{PresenceAbsence}. 
#'Such \code{\link{PresenceAbsence}} object class allows storing information beyond presence-absence data 
#'(e.g. user-defined grid-cell system) and using the generic \code{plot}, \code{summary} and \code{print} functions of R. 
#'Also, some package's functions allow the user to input customary R objects (e.g. \code{vector}, \code{matrix}, 
#'\code{data.frame}). 
#'
#'
#'If you are looking for the most recent version of the package, you can get the development version
#'of letsR on github (\url{https://github.com/macroecology/letsR}).
#'
#' @name letsR-package
#' @aliases letsR
#' @aliases letsR-package
#' @title Tools for Data Handling and Analysis in  Macroecology.
#' @author \strong{Bruno Vilela}\cr
#' (email: \email{bvilela@@wustl.edu}; 
#' Website: \url{https://bvilela.weebly.com/})
#' @author \strong{Fabricio Villalobos}\cr
#' (email: \email{fabricio.villalobos@@gmail.com}; 
#' Website: \url{https://fabro.github.io})
#' 
#' @keywords package
#'
#' @details \tabular{ll}{
#' Package: \tab lestR\cr
#' Type: \tab Package\cr
#' Version: \tab 3.1\cr
#' Date: \tab 2018-01-24\cr
#' License: \tab GPL-2\cr
#' }
#' 
#' @references Vilela, B., & Villalobos, F. (2015). letsR: a new R package for data handling and analysis in macroecology. Methods in Ecology and Evolution.
#' 
#' @import geosphere terra sf
#' @importFrom grDevices colorRampPalette dev.new dev.off
#' @importFrom graphics abline par plot.new segments
#' @importFrom methods is
#' @importFrom stats dist pnorm sd
NULL
