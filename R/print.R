#Print for object of class PresenceAbsence
#Bruno Vilela
#' @export

print.PresenceAbsence <- function(x){
  resolution <- res(x$Ric)
  cat("\nClass:", class(x),
      "\nNumber of species:", (ncol(x$Pre)-2),
      "\nNumber of cells:", nrow(x$Pre))
  cat("\nScale: ", resolution[1], ", ", resolution[2], " (x, y)", sep="")  
      
}

