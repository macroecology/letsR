#' Shapefiles to presence/absence matrix
#' 
#' @author Bruno Vilela & Fabricio Villalobos
#' 
#' @description Transform species shapefiles into a matrix of presence/absence.
#'
#' @usage lets.presab(shapes, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1, 
#' remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE, 
#' crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL, 
#' origin=NULL, seasonal=NULL)
#' 
#' @param shapes SpatialPolygonsDataFrame (see function readShapePoly to open this files) class object. Species name should be in a subclass called BINOMIAL or binomial.
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
                   cover=0, presence=NULL, origin=NULL, seasonal=NULL){
  
  
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
  
  
  cat("This action may take some time...\nWe will take the liberty to open a counting window so you can follow the progress...")
  
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
  cbind(coord,matriz)->Resultado
  if(remove.cells==TRUE){
    Resultado <- .removeCells(Resultado)
  }
  if(remove.sp==TRUE){
    Resultado <- .removeSp(Resultado)
  }
  dev.off()
  cat("\nThank you for your patience!")
  if(show.matrix==TRUE){
    return(Resultado)
  }else{
    values(ras) <- rowSums(matriz)
    final <- list("Presence and Absence Matrix"=Resultado, "Richness Raster"=ras, 
                  "Species name"=colnames(Resultado[,-(1:2)]))
    class(final) <- "PresenceAbsence"
    return(final)
  }
}
