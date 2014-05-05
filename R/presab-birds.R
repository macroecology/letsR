#' Shapefiles to presence/absence matrix by folder location
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Convert species' shapefiles into a presence-absence matrix. This function is specially designed to work with BirdLife Intl. shapefiles (\url{http://www.birdlife.org}).
#'
#' @usage lets.presab.birds(path, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1, 
#' remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE, 
#' crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL, 
#' origin=NULL, seasonal=NULL, count=FALSE)
#' 
#' @param path Path location of folders with one or more species' shapefiles.
#' @param xmx Maximun longitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param xmn Minimun longitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param ymx Maximun latitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param ymn Minimun latitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param remove.cells Logical, if \code{TRUE} the final matrix will not contain cells in the grid with a value of zero (i.e. sites with no species present).
#' @param remove.sp Logical, if \code{TRUE} the final matrix will not contain species that do not match any cell in the grid.
#' @param show.matrix Logical, if \code{TRUE} only the presence-absence matrix will be shown.
#' @param crs Character representign the PROJ.4 type description of a Coordinate Reference System (map projection).
#' @param cover Porcentage of the cell covered by the shapefile that will be considered for presence (values between 0 and 1).
#' @param presence A vector with the code numbers for the presence type to be considered in the process (for IUCN spatial data \url{http://www.iucnredlist.org/technical-documents/spatial-data}). 
#' @param origin A vector with the code numbers for the origin type to be considered in the process (for IUCN spatial data).
#' @param seasonal A vector with the code numbers for the seasonal type to be considered in the process (for IUCN spatial data).
#' @param count Logical, if \code{TRUE} a counting window will open.
#' 
#' @return The result is an object of class PresenceAbsence with the following objects:
#' @return \strong{Presence-Absence Matrix}: A matrix of species' presence(1) and absence(0) information. The first two columns contain the longitude (x) and latitude (y) of the cells' centroid (from the gridded domain used);
#' @return \strong{Richness Raster}: A raster containing species richness data;
#' @return \strong{Species name}: A vector with species' names contained in the matrix.
#' @return *But see the option argument \code{show.matrix}.
#'  
#' @details The function creates the presence-absence matrix based on a raster file. Depending on the cell size, extension used and number of species it may require a lot of memory, 
#'and may take some time to process it. Thus, during the process, if \code{count} argument is set \code{TRUE}, a counting window will open so you can see the progress (i.e. in what polygon the function is working). Note that the number of 
#'polygons is not the same as the number of species that you have (i.e. a species may have more than one polygon/shapefiles).
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.shFilter}}
#' 
#' @examples \dontrun{
#' #Constructing a Presence/Absence matrix for birds (this will not work if do not change the path for the folder were you kept the spatial data) 
#' PAM <- lets.presab.birds("YOURPATH/YOURPATH/BIRDS")
#' plot(PAM)  # Species richness map
#' 
#' }
#' 
#' @export

lets.presab.birds <- function(path, xmn=-180, xmx=180, ymn=-90, 
                     ymx=90, resol=1, remove.cells=TRUE,
                     remove.sp=TRUE, show.matrix=FALSE, 
                     crs=CRS("+proj=longlat +datum=WGS84"),
                     cover=0, presence=NULL, origin=NULL, 
                     seasonal=NULL, count=FALSE){
    
  shapes <- list.files(path, pattern=".shp", full.names=T, recursive=T)
  r <- raster(xmn=xmn, xmx=xmx, ymn=ymn, ymx=ymx, crs=crs)
  res(r) <- resol
  values(r) <- 0
  valores <- values(r)
  xy <- xyFromCell(r, 1:length(valores))
  nomes <- numeric(length(shapes))
  matriz <- matrix(0, nrow=nrow(xy), ncol=length(shapes))
  matriz <- cbind(xy, matriz)
  n <- length(shapes)
  k <- 0

  if(count == TRUE){
  x11(2, 2, pointsize=12)
  par(mar=c(0, 0, 0, 0))  
  
  for(j in 1:n){    
    plot.new()
    text(0.5, 0.5, paste(paste("Total:", n, "\n", "Runs to go: ", (n-j))))      
    valores2 <- valores
    shp <- readShapePoly(shapes[j], delete_null_obj=TRUE, force_ring=T)
    nomes[j] <- levels(shp$SCINAME)[1]
    shp <- lets.shFilter(shp, presence=presence, origin=origin, seasonal=seasonal)
    if(!is.null(shp)){  
    k <- k+1
    cell <- extract(r, shp, cellnumber=T, small=T, weights=T)        
    cell2 <- do.call(rbind.data.frame, cell)
    cell3 <- cell2[which(cell2[,3]>=cover), ]    
    valores2[cell3[, 1]] <- 1
    matriz[,(j+2)] <- valores2
    }
  }  
  dev.off()
  }
  
  
  if(count == FALSE){
    
    for(j in 1:n){    
      valores2 <- valores
      shp <- readShapePoly(shapes[j], delete_null_obj=TRUE, force_ring=T)
      nomes[j] <- levels(shp$SCINAME)[1]
      shp <- lets.shFilter(shp, presence=presence, origin=origin, seasonal=seasonal)
      if(!is.null(shp)){  
        k <- k+1
        cell <- extract(r, shp, cellnumber=T, small=T, weights=T)        
        cell2 <- do.call(rbind.data.frame, cell)
        cell3 <- cell2[which(cell2[,3]>=cover), ]    
        valores2[cell3[, 1]] <- 1
        matriz[,(j+2)] <- valores2
      }
    }  
  }
  
  if(k==0){
    stop("after filtering none species distribution left")
  }
  
  colnames(matriz) <- c("Longitude(x)", "Latitude(y)", nomes)
  
  riqueza <- rowSums(as.matrix(matriz[,-c(1,2)]))  
    
  
  if(remove.cells==TRUE){
    matriz <- .removeCells(matriz)
  }
    
  if(remove.sp==TRUE){
    matriz <- .removeSp(matriz)
  }
  

  matriz <- .unicas(matriz)
  
  if(show.matrix==TRUE){
    return(matriz)
  }else{
    values(r) <- riqueza
    final <- list("Presence and Absence Matrix"=matriz, "Richness Raster"=r, 
                  "Species name"=(colnames(matriz)[-(1:2)]))
    class(final) <- "PresenceAbsence"
    return(final)    
}
}



