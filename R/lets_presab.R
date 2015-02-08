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
#' @param shapes Object of class SpatialPolygonsDataFrame (see function \code{\link{readShapePoly}} 
#' to open these files). Species name should be in a column (within the .DBF table of the shapefile) 
#' called BINOMIAL or binomial.
#' @param xmx Maximun longitude used to construct the grid in which the matrix will be based 
#' (i.e. the [gridded] geographic domain of interest)
#' @param xmn Minimun longitude used to construct the grid in which the matrix will be based 
#' (i.e. the [gridded] geographic domain of interest)
#' @param ymx Maximun latitude used to construct the grid in which the matrix will be based 
#' (i.e. the [gridded] geographic domain of interest)
#' @param ymn Minimun latitude used to construct the grid in which the matrix will be based 
#' (i.e. the [gridded] geographic domain of interest)
#' @param resol Numeric vector of length 1 or 2 to set the grid resolution.
#' @param remove.cells Logical, if \code{TRUE} the final matrix will not contain cells in the 
#' grid with a value of zero (i.e. sites with no species present).
#' @param remove.sp Logical, if \code{TRUE} the final matrix will not contain species that 
#' do not match any cell in the grid.
#' @param show.matrix Logical, if \code{TRUE} only the presence-absence matrix will be shown.
#' @param crs Character representign the PROJ.4 type description of a Coordinate Reference System (map projection).
#' @param cover Porcentage of the cell covered by the shapefile that will be considered for presence 
#' (values between 0 and 1).
#' @param presence A vector with the code numbers for the presence type to be considered in the process 
#' (for IUCN spatial data \url{http://www.iucnredlist.org/technical-documents/spatial-data}, see metadata). 
#' @param origin A vector with the code numbers for the origin type to be considered in the process 
#' (for IUCN spatial data).
#' @param seasonal A vector with the code numbers for the seasonal type to be considered in the process 
#' (for IUCN spatial data).
#' @param count Logical, if \code{TRUE} a counting window will open.
#' 
#' 
#' @return The result is an object of class PresenceAbsence with the following objects:
#' @return \strong{Presence-Absence Matrix}: A matrix of species' presence(1) and absence(0) information. 
#' The first two columns contain the longitude (x) and latitude (y) of the cells' centroid 
#' (from the gridded domain used);
#' @return \strong{Richness Raster}: A raster containing species richness data;
#' @return \strong{Species name}: A character vector with species' names contained in the matrix.
#' @return *But see the optional argument \code{show.matrix}.
#' 
#'  
#' @details The function creates the presence-absence matrix based on a raster file. 
#' Depending on the cell size, extension used and number of species it may require a lot of memory, 
#'and may take some time to process it. Thus, during the process, if \code{count} argument is 
#' set \code{TRUE}, a counting window will open so you can see the progress 
#' (i.e. in what polygon the function is working). Note that the number of 
#'polygons is not the same as the number of species that you have 
#' (i.e. a species may have more than one polygon/shapefiles).
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.shFilter}} 
#' 
#' @examples \dontrun{
#' data(Phyllomedusa)  # Spatial distribution polygons of south american frogs of genus Phyllomedusa. 
#' PAM <- lets.presab(Phyllomedusa, xmn=-93, xmx=-29, ymn= -57, ymx=15)
#' summary(PAM)
#' require(maps)
#' plot(PAM)  # Species richness map
#' plot(PAM, name="Phyllomedusa nordestina")  # Map of the specific species
#' }
#' 
#' 
#' @import raster
#' @import maptools
#' @import maps
#' @import sp
#' @import rgdal 
#' 
#' @export


lets.presab <- function(shapes, xmn=-180, xmx=180, ymn=-90, 
                        ymx=90, resol=1, remove.cells=TRUE, 
                        remove.sp=TRUE, show.matrix=FALSE, 
                        crs=CRS("+proj=longlat +datum=WGS84"),
                        cover=0, presence=NULL, origin=NULL, 
                        seasonal=NULL, count=FALSE){
  
  if(!all(is.null(presence), is.null(origin), is.null(seasonal))){
    shapes <- lets.shFilter(shapes, presence=presence, origin=origin, seasonal=seasonal)
  }
  
  if(is.null(shapes)){
    stop("after filtering none species distribution left")
  }
  
  ras <- raster(xmn=xmn, xmx=xmx, ymn=ymn, ymx=ymx, crs=crs)
  res(ras) <- resol
  values(ras) <- 1
  coord <- xyFromCell(ras, 1:ncell(ras))
  colnames(coord) <- c("Longitude(x)", "Latitude(y)")
  
  if(cover>0){
    grid <- rasterToPolygons(ras)
    areagrid <- areaPolygon(grid)
    areashape <- areaPolygon(shapes)
  }
  
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
  
  matriz <- matrix(0, ncol=length(nomes), nrow=ncell(ras))
  colnames(matriz) <- nomes
  
  if(count){
    dev.new(width=2, height=2, pointsize = 12)
    par(mar=c(0, 0, 0, 0))
    
    for(i in 1:n){
      plot.new()
      text(0.5, 0.5, paste(paste("Total:", n, "\n","Runs to go: ", (n-i))))
      
      celulas <- try(celulas <- extract(ras, SpatialPolygons(list(shapes@polygons[[i]])),
                                        cellnumbers=T, weights=T, small=T), silent=T)
      if(class(celulas)=="try-error"){
        celulas <- extract(ras, SpatialPolygons(list(shapes@polygons[[i]])),
                           cellnumbers=T)
        nen <- sapply(celulas, nrow)
        for(ky in 1:length(nen)){
          weigth <- rep(0, nen[ky]) 
          celulas[[ky]] <- cbind(celulas[[ky]], weigth)  
        } 
      }
      
      celulas <- celulas[!sapply(celulas, is.null)]
      if(length(celulas)>0){
        celulas <- lapply(celulas, function(x){colnames(x)<-1:3;return(x)})
      }
      pos <- which(nomes2[i]==nomes)
      
      pos2 <- do.call(rbind.data.frame, celulas)
      if(cover==0){
        pos2 <- pos2[which(pos2[,3]>=cover), ]
      }else{
        prop <- round((pos2[, 3]*areashape[i])/areagrid[pos2[, 1]], 2)
        if(any(prop>1)){
          prop[prop>1] <- 1
        }
        pos2 <- pos2[which(prop>=cover), ]
      }
      
      matriz[pos2[, 1], pos] <- 1
    }
    dev.off()
  }
  
  
  if(!count){
    
    for(i in 1:n){
      
      celulas <- try(celulas <- extract(ras, SpatialPolygons(list(shapes@polygons[[i]])),
                                        cellnumbers=T, weights=T, small=T), silent=T)
      if(class(celulas)=="try-error"){
        celulas <- extract(ras, SpatialPolygons(list(shapes@polygons[[i]])),
                           cellnumbers=T)
        nen <- sapply(celulas, nrow)
        for(ky in 1:length(nen)){
          weigth <- rep(0, nen[ky]) 
          celulas[[ky]] <- cbind(celulas[[ky]], weigth)  
        } 
      }
      
      celulas <- celulas[!sapply(celulas, is.null)]
      if(length(celulas)>0){
        celulas <- lapply(celulas, function(x){colnames(x)<-1:3;return(x)})
      }
      
      pos <- which(nomes2[i]==nomes)
      pos2 <- do.call(rbind.data.frame, celulas)      
      if(cover==0){
        pos2 <- pos2[which(pos2[,3]>=cover), ]
      }else{
        prop <- round((pos2[, 3]*areashape[i])/areagrid[pos2[, 1]], 2)
        if(any(prop>1)){
          prop[prop>1] <- 1
        }
        pos2 <- pos2[which(prop>=cover), ]
      }      
      matriz[pos2[, 1], pos] <- 1
    }
  }  
  
  cbind(coord,matriz)->Resultado
  if(remove.cells){
    Resultado <- .removeCells(Resultado)
  }
  if(remove.sp){
    Resultado <- .removeSp(Resultado)
  }
  
  if(show.matrix){
    return(Resultado)
  }else{
    values(ras) <- rowSums(matriz)
    final <- list("Presence_and_Absence_Matrix"=Resultado, "Richness_Raster"=ras, 
                  "Species_name"=colnames(Resultado)[-(1:2)])
    class(final) <- "PresenceAbsence"
    return(final)
  }
}
