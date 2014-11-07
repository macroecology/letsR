#' Calculate species range size 
#' 
#' @author Bruno Vilela
#' 
#' @description This function calculate species range size from a PresenceAbsence object or direct from the species shapefiles.
#' 
#' @param x a PresenceAbsence object or an SpatialPolygonsDataFrame.
#' @param species_name  species name in the same other as in the SpatialPolygonsDataFrame (only needed if x is a SpatialPolygonsDataFrame).
#' @param coordinates "geographical" or "planar". Indicate wheter the shapefile has geographical or planar coordinates(only needed if x is a SpatialPolygonsDataFrame). 
#' @param units "cell" or "squaremeters". Indicate if the units wanted are in number of cells occupied or in square meters(only needed if x is a PresenceAbsence object).
#' 
#' @return The result is a matrix with the range size of each species.
#' If the range size accounts for the earth curvature (Yes or No) and it's unit
#' may differ for each argument combination:
#' 1) SpatialPolygonsDataFrame & geographical = Square meters. Yes.
#' 2) SpatialPolygonsDataFrame & planar = same units as the coordinates. No.
#' 3) PresenceAbsence & cell = number of cells. No.
#' 4) PresenceAbsence & squaremeters = squaremeters. Yes.
#' 
#' @examples \dontrun{
#' # SpatialPolygonsDataFrame & geographical
#' data(Phyllomedusa)  
#' rangesize <- lets.rangesize(x=Phyllomedusa, coordinates="geographic")
#' 
#' # SpatialPolygonsDataFrame & planar
#' rangesize2 <- lets.rangesize(x=Phyllomedusa, coordinates="planar")
#' 
#' # PresenceAbsence & cell
#' data(PAM)  
#' rangesize3 <- lets.rangesize(x=PAM, units="cell")
#' 
#' # PresenceAbsence & squaremeters
#' rangesize4 <- lets.rangesize(x=PAM, units="squaremeter")
#' }
#' 
#' 
#' @export


lets.rangesize <- function(x, species_name=x@data[, 1],
                           coordinates="geographic", 
                           units="cells"){
  
  if(class(x)=="PresenceAbsence"){
    
    if(units=="cell"){
    Range_Size <- colSums(x$P[, -(1:2)])
    Range_Size <- as.matrix(Range_Size)
    colnames(Range_Size) <- 'Range_size'
    return(Range_Size)
    }
    
    if(units=="squaremeter"){
      grid <- rasterToPolygons(x$R)
      cellsize <- areaPolygon(grid)
      r <- rasterize(grid, x$R, cellsize)
      cellsize2 <- extract(r, x$P[, 1:2])            
      Range_Size <- colSums(x$P[, -(1:2)]*cellsize2)
      Range_Size <- as.matrix(Range_Size)
      colnames(Range_Size) <- 'Range_size'
      return(Range_Size)
      
      
    }
  }
    if(class(x)=="SpatialPolygonsDataFrame"){
    if(coordinates=="planar"){
    Range_Size <- sapply(slot(x, "polygons"), slot, "area")
    Range_Size <- as.matrix(Range_Size)
    rownames(Range_Size) <- species_name
    colnames(Range_Size) <- 'Range_size'
    Range_Size2 <- aggregate(Range_Size[, 1]~species_name, FUN=sum)
    Range_Size <- as.matrix(Range_Size2[, 2])
    rownames(Range_Size) <- Range_Size2[, 1]
    return(Range_Size)
    }
    
    if(coordinates=="geographic"){
    Range_Size <- areaPolygon(x)
    Range_Size <- as.matrix(Range_Size)
    rownames(Range_Size) <- species_name
    colnames(Range_Size) <- 'Range_size'
    Range_Size2 <- aggregate(Range_Size[, 1]~species_name, FUN=sum)
    Range_Size <- as.matrix(Range_Size2[, 2])
    rownames(Range_Size) <- Range_Size2[, 1]
    return(Range_Size)    
    }
  }
}



