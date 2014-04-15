#' Shapefiles into a presence-absence matrix
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Convert species shapefiles into a presence-absence matrix.
#'
#' @usage lets.presab(shapes, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1, 
#' remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE, 
#' crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL, 
#' origin=NULL, seasonal=NULL, count=FALSE)
#' 
#' @param shapes Object of class SpatialPolygonsDataFrame (see function readShapePoly to open these files). Species name should be in a column (within the .DBF table of the shapefile) called BINOMIAL or binomial.
#' @param xmx Maximun longitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param xmn Minimun longitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param ymx Maximun latitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param ymn Minimun latitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param remove.cells If true, the final matrix will not contain cells in the grid with a value of zero (i.e. sites with no species present).
#' @param remove.sp If true, the final matrix will not contain species that do not match any cell in the grid.
#' @param show.matrix if true, only the presence-absence matrix will be shown.
#' @param crs the projection of the shapefiles.
#' @param cover Porcentage of the cell covered by the shapefile that will be considered for presence (values between 0 and 1).
#' @param count Logical, if TRUE a counting window will open.
#' 
#' 
#' @return The result is an object of class PresenceAbsence with the following objects:
#' @return Presence-Absence Matrix: A matrix of species' presence(1) and absence(0) information. The first two columns contain the longitude (x) and latitude (y) of the cells' centroid (from the gridded domain used);
#' @return Richness Raster: A raster containing species richness data;
#' @return Species name: A vector with species' names contained in the matrix.
#' @return *But see the option argument show.matrix.
#' 
#'  
#' @details The function creates the presence-absence matrix based on a raster file. Depending on the cell size, extension used and number of species it may require a lot of memory, 
#'and may take some time to process it. Thus, during the process, a counting window will open so you can see the progress (i.e. in what polygon the function is working). Note that the number of 
#'polygons is not the same as the number of species that you have (i.e. a species may have more than one polygon/shapefiles). Before running the function, please check if the arguments are in the way you want.
#' 
#' @seealso plot.PresenceAbsence
#' @seealso lets.presab.birds
#' @seealso lets.shFilter
#' 
#' @import raster
#' @import maptools
#' @import maps
#' 
#' @export

lets.presab <- function(shapes, xmn=-180, xmx=180, ymn=-90, 
                   ymx=90, resol=1, remove.cells=TRUE, 
                   remove.sp=TRUE, show.matrix=FALSE, 
                   crs=CRS("+proj=longlat +datum=WGS84"),
                   cover=0, presence=NULL, origin=NULL, 
                   seasonal=NULL, count=FALSE){
  
  
  shapes <- lets.shFilter(shapes, presence=presence, origin=origin, seasonal=seasonal)
  
  if(is.null(shapes)){
    stop("after filtering none species distribution left")
  }
  
  ras <- raster(xmn=xmn, xmx=xmx, ymn=ymn, ymx=ymx, crs=crs)
  res(ras) <- resol
  values(ras) <- 1
  coord <- xyFromCell(ras, 1:length(values(ras)))
  colnames(coord) <- c("Longitude(x)", "Latitude(y)")
  
  if(any(names(shapes)=="BINOMIAL")){  
    nomes <- levels(shapes$BINOMIAL)
    n <- length(shapes$BINOMIAL)
    nomes2 <- shapes$BINOMIAL
  }
  
  if(any(names(shapes)=="binomial")){  
    nomes <- levels(shapes$binomial)
    n <- length(shapes$binomial)
    nomes2 <- shapes$binomial
  }
  
  matriz <- matrix(0, ncol=length(nomes), nrow=length(values(ras)))
  colnames(matriz) <- nomes
  
  if(count == TRUE){
  x11(2, 2, pointsize = 12)
  par(mar=c(0, 0, 0, 0))
  
  for(i in 1:n){
    plot.new()
    text(0.5, 0.5, paste(paste("Total:", n, "\n","Runs to go: ", (n-i))))
    celulas <- extract(ras, SpatialPolygons(list(shapes@polygons[[i]])), cellnumbers=T, weights=T, small=T)
    
    pos <- which(nomes2[i]==nomes)
    
    pos2 <- do.call(rbind.data.frame, celulas)
    pos2 <- pos2[which(pos2[,3]>=cover), ]
    matriz[pos2[, 1], pos] <- 1
  }
  dev.off()
  }
  
  
  if(count == FALSE){
    
    for(i in 1:n){

      celulas <- extract(ras, SpatialPolygons(list(shapes@polygons[[i]])), cellnumbers=T, weights=T, small=T)
      
      pos <- which(nomes2[i]==nomes)
      
      pos2 <- do.call(rbind.data.frame, celulas)
      pos2 <- pos2[which(pos2[,3]>=cover), ]
      matriz[pos2[, 1], pos] <- 1
    }
  }  
  
  cbind(coord,matriz)->Resultado
  if(remove.cells==TRUE){
    Resultado <- .removeCells(Resultado)
  }
  if(remove.sp==TRUE){
    Resultado <- .removeSp(Resultado)
  }
  
  if(show.matrix==TRUE){
    return(Resultado)
  }else{
    values(ras) <- rowSums(matriz)
    final <- list("Presence and Absence Matrix"=Resultado, "Richness Raster"=ras, 
                  "Species name"=colnames(Resultado)[-(1:2)])
    class(final) <- "PresenceAbsence"
    return(final)
  }
}
