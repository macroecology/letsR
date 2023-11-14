#' Save a PresenceAbsence object
#'
#' @author Bruno Vilela
#'
#' @description Save an external representation of a PresenceAbsence object to
#'   the specified file. The object can be read back from the file at a later
#'   date by using the function \code{\link{lets.load}}.
#'
#' @param pam A PresenceAbsence object.
#' @param ... other arguments passed to the function \code{\link{save}}
#'
#'
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#'
#' @examples \dontrun{
#' data(PAM)
#' lets.save(PAM, file = "PAM.RData")
#' PAM <- lets.load(file = "PAM.RData")
#' }
#'
#' @export

lets.save <- function(pam, ...) {
    pam$Richness_Raster <- terra::wrap(pam$Richness_Raster)
    save(pam, ...)  
}


#' Load a PresenceAbsence object
#'
#' @author Bruno Vilela
#'
#' @description Reload PresenceAbsence objects written with the function
#'   \code{\link{lets.save}}.
#'
#' @param file a character string giving the name of the file to load.
#'
#'
#' @seealso \code{\link{lets.save}}
#' @seealso \code{\link{lets.presab}}
#'
#' @examples \dontrun{
#' data(PAM)
#' lets.save(PAM, file = "PAM.RData")
#' PAM <- lets.load(file = "PAM.RData")
#' }
#'
#' @export


lets.load <- function(file) {
  e <- base::new.env()
  name_file <- load(file, envir = e)
  pam <- base::get(name_file)
  pam$Richness_Raster <- terra::unwrap(pam$Richness_Raster)
  return(pam)
}
