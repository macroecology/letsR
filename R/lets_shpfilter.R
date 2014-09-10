#' Shapefiles filtering 
#' 
#' @author Bruno Vilela
#' 
#' @description Filter species shapefiles by origin, presence and seasonal type (following IUCN types: \url{http://www.iucnredlist.org/technical-documents/spatial-data}, see metadata)).
#'
#' @usage lets.shFilter(shapes, presence=NULL, origin=NULL, seasonal=NULL)
#' 
#' @param shapes Object of class SpatialPolygonsDataFrame (see function readShapePoly to open this files).
#' @param presence A vector with the code numbers for the presence type to be maintained.
#' @param origin A vector with the code numbers for the origin type to be maintained.
#' @param seasonal A vector with the code numbers for the seasonal type to be maintained.
#' 
#' @return The result is the shapefile(s) filtered according to the selected types. If the filters remove all polygons, the result will be NULL.
#' 
#'  
#' @details Presence codes:
#' (1) Extant, 
#' (2) Probably Extant, 
#' (3) Possibly Extant, 
#' (4) Possibly Extinct, 
#' (5) Extinct (post 1500) &
#' (6) Presence Uncertain.
#' 
#' Origin codes:
#' (1) Native, 
#' (2) Reintroduced, 
#' (3) Introduced, 
#' (4) Vagrant &
#' (5) Origin Uncertain.
#' 
#' Seasonal codes:
#' (1) Resident, 
#' (2) Breeding Season, 
#' (3) Non-breeding Season, 
#' (4) Passage &
#' (5) Seasonal Occurrence Uncertain.
#' 
#' More info in the shapefiles' metadata.
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#' 
#' 
#' @export



lets.shFilter <- function(shapes, presence=NULL, origin=NULL, seasonal=NULL){
  
 if(is.null(presence) & is.null(origin) & is.null(seasonal)){
  return(shapes)
 }else{
  
 try(names(shapes)[names(shapes)=="ORIGIN"]  <- "origin", silent = T)
 try(names(shapes)[names(shapes)=="PRESENCE"]  <- "presence", silent = T)
 try(names(shapes)[names(shapes)=="SEASONAL"]  <- "seasonal", silent = T)


 if(!is.null(presence)){
  pos <- which(shapes$presence %in% presence)
  if(length(pos)>0){
    shapes <- shapes[pos, ]
  }else{
  shapes <-  NULL
  }
 }

 if(!is.null(origin)){
  pos2 <- which(shapes$origin %in% origin)

  if(length(pos2)>0){
   shapes <- shapes[pos2, ]
  }else{
  shapes <- NULL
  }
 }

 if(!is.null(seasonal)){
  pos3 <- which(shapes$seasonal %in% seasonal)
  if(length(pos3)>0){
    shapes <- shapes[pos3, ]
  }else{
    shapes <- NULL
  }      
 }

 return(shapes)
 }
}
