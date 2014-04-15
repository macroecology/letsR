#' Shapefiles to presence/absence matrix by folder location
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Convert species' shapefiles into a presence-absence matrix. This function is specially designed to work with BirdLife Intl. shapefiles (www.birdlife.org).
#'
#' @usage lets.presab.birds(path, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1, 
#' remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE, 
#' crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL, 
#' origin=NULL, seasonal=NULL, count=FALSE)
#' 
#' @param path Path location of folders with one or more species' shapefiles.
#' @param xmx Maximun longitude used to construct the grid in which the matrix will be based (i.e. the geographic domain of interest). 
#' @param xmn Minimun longitude used to construct the grid in which the matrix will be based (i.e. the geographic domain of interest).
#' @param ymx Maximun latitude used to construct the grid in which the matrix will be based (i.e. the geographic domain of interest).
#' @param ymn Minimun latitude used to construct the grid in which the matrix will be based (i.e. the geographic domain of interest).
#' @param remove.cells If true, the final matrix will not contain cells in the grid that have value of zero (i.e. no species present in that cell).
#' @param remove.sp If true, the final matrix will not contain species that do not match any cell in the grid (i.e. species not distributed in the domain).
#' @param show.matrix if true, only the presence-absence matrix will be shown.
#' @param crs the projection of the shapefiles.
#' @param cover Percentage of the cell covered by the shapefile that will be considered for presence (values between 0 and 1).
#' @param count Logical, if TRUE a counting window will open.

#' @return The result is an object of class PresenceAbsence with the following objects:
#' @return Presence-Absence Matrix: A matrix of species' presence(1) and absence(0). The first two columns contain the longitude (x) and latitude (y) of the cells' centroid and the remainin columns the incidence values (1,0);
#' @return Richness Raster: A raster containing species richness data within the gridded domain;
#' @return Species name: A vector of species' names contained in the presence-absence matrix.
#' @return *But see the option argument show.matrix.
#' 
#'  
#' @details The function creates the presence-absence matrix based on a raster file. Depending on the cell size, extension used and number of species it may require a lot of memory, 
#'and may take some time to process it. Thus, during this process, a counting window is open so you can see the progress (i.e. in what polygon the function is working). Note that the number of 
#'polygons is not the same as the number of species (i.e. one species may have more than one polygon/shapefile).
#' 
#' @seealso plot.PresenceAbsence
#' @seealso lets.presab
#' @seealso lets.shFilter
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



