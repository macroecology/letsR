#' Shapefiles to presence/absence matrix by folder location
#' 
#' @author Bruno Vilela
#' 
#' @description Transform species shapefiles into a matrix of presence/absence (specially desinged for bird life output).
#'
#' @usage lets.presab.birds(path, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1, 
#' remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE, 
#' crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL, 
#' origin=NULL, seasonal=NULL)
#' 
#' @param path Path location in which the folders with one or more individual species shapefiles.
#' @param xmx Maximun longitude used to construct the grid of cells in which the matrix will be based. 
#' @param xmn Minimun longitude used to construct the grid of cells in which the matrix will be based.
#' @param ymx Maximun latitude used to construct the grid of cells in which the matrix will be based. 
#' @param ymn Minimun latitude used to construct the grid of cells in which the matrix will be based.
#' @param remove.cells If true, the final matrix will not contain cells in the grid with a value equal to zero.
#' @param remove.sp If true, the final matrix will not contain species that do not match any cell in the grid.
#' @param show.matrix if true, only the object matrix will be shown.
#' @param crs the projection of the shapefiles.
#' @param cover Porcentage of the cell covered by the shapefile that shall be considered for presence (values between 0 and 1).
#' 
#' @return The result is an object of class PresenceAbsence with the following objects:
#' @return Presence and Absence Matrix: A matrix of Presence(1) and Absence(0) with x (longitude) and y (latitude) of cells centroid;
#' @return Richness Raster: A raster containing richness data;
#' @return Species name: A vector with species names that are in the matrix.
#' @return *But see the option argument show.matrix.
#' 
#'  
#' @details The function creates the matrix of presence/absence based on a raster file. Depending on the cell size, extension used and number of species it may require a lot of memmory, 
#'and may take some time to process it. Because of this, during the process we open a counting window so you can see in what polygon the function is working. Note that the number of 
#'polygons is not the same number of species that you have. Before run the function please check if the arguments are in the way you want.
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
                     cover=0, presence=NULL, origin=NULL, seasonal=NULL){
    
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
  cat("This action may take some time...\nWe will take the liberty to open a counting window so you can follow the progress...")
  
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
  
  if(k==0){
    dev.off()
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
  
  dev.off()
  cat("\nThank you for your patience!")

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



