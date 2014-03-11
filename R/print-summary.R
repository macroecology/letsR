#print summary
#' @export
print.summary.PresenceAbsence <- function(x){
  cat("\nClass:", x$class)
  cat("\n_ _")
  
  cat("\nNumber of species:", x$Numberofspecies,
      "\nNumber of cells:", x$Numberofcells)
  cat("\nCells with presence:", x$Cellswithpresence)
  cat("\nCells without presence:", x$Cellswithoutanypresence)  
  cat("\nSpecies without presence:", x$Specieswithoutanypresence)
  cat("\nSpecies with the largest range:", x$SpeciesLargestRange)
  cat("\n_ _")  
  
  cat("\nRaster carachteristics")
  cat("\nScale: ", x$resolution[1], ", ", x$resolution[2], " (x, y)", sep="")  
  cat("\nExtention: ", xmin(x$ex), ", ",  xmax(x$ex), ", ", ymin(x$ex), ", ", ymax(x$ex), " (xmin, xmax, ymin, ymax)", sep="")
  cat("\nCoord. Ref.: ", x$coordRef)
  
}
