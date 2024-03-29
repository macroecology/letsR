#' Print for object of class PresenceAbsence
#' @author Bruno Vilela
#' 
#' @description Print for objects of class PresenceAbsence.
#' 
#' @usage 
#' \method{print}{PresenceAbsence}(x, \dots)
#' 
#' @param x an object of class \code{\link{PresenceAbsence}}.
#' @param ... Other print parameters.
#' 
#' @method print PresenceAbsence
#' @export


print.PresenceAbsence <- function(x, ...) {
  x <- .check_pam(x)
  resolution <- res(x$Ric)
  cat("\nClass:", class(x),
      "\nNumber of species:", (ncol(x$Pre) - 2),
      "\nNumber of cells:", nrow(x$Pre))
  cat("\nResolution: ", resolution[1], ", ", resolution[2], " (x, y)\n", sep="")  
  
}

