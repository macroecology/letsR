#' Shapefiles filtering 
#' 
#' @author Bruno Vilela
#' 
#' @description Filter species shapefiles by origin and presence type (following IUCN types).
#'
#' @usage lets.shFilter(shapes, presence=NULL, origin=NULL, seasonal=NULL)
#' 
#' @param shapes SpatialPolygonsDataFrame (see function readShapePoly to open this files) class object. Species name should be in a subclass called BINOMIAL or binomial.
#' @param presence A vector with the code numbers of presence type to be matained.
#' @param origin A vector with the code numbers of origin type to be matained.
#' @param seasonal A vector with the code numbers of seasonal type to be matained.
#' 
#' @return The result is the shapefile filtered. If the filters remove all polygons, the result will be NULL.
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
#' More info see metadata file of the shapefiles.
#' 
#' @seealso plot.PresenceAbsence
#' @seealso lets.presab
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
