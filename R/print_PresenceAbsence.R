#' Print for object of class PresenceAbsence
#' @author Bruno Vilela
#' 
#' @description Print for objects of class PresenceAbsence.
#' 
#' @usage 
#' \method{print}{PresenceAbsence}(x, \dots)
#' 
#' @param x an object of class PresenceAbsence (see function presab).
#' @param ... Other print parameters.
#' 
#' @export


print.PresenceAbsence <- function(x, ...){
  resolution <- res(x$Ric)
  cat("\nClass:", class(x),
      "\nNumber of species:", (ncol(x$Pre)-2),
      "\nNumber of cells:", nrow(x$Pre))
  cat("\nResolution: ", resolution[1], ", ", resolution[2], " (x, y)", sep="")  
      
}

