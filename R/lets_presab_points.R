#' Coordinates into a presence-absence matrix
#' 
#' @author Bruno Vilela
#' 
#' @description Convert species shapefiles into a presence-absence matrix.
#'
#' @usage lets.presab.points(xy, species, xmn=-180, xmx=180, ymn=-90, ymx=90, 
#' resol=1, remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
#' crs=CRS("+proj=longlat +datum=WGS84"), count=FALSE)
#' 
#' @param xy A matrix with coordinates, first column is the longitude (or x), and the second latitude (or y).
#' @param species Character vector with species names, in the same order as the coordinates.
#' @param xmx Maximun longitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param xmn Minimun longitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param ymx Maximun latitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param ymn Minimun latitude used to construct the grid in which the matrix will be based (i.e. the [gridded] geographic domain of interest)
#' @param resol Numeric vector of length 1 or 2 to set the grid resolution.
#' @param remove.cells Logical, if \code{TRUE} the final matrix will not contain cells in the grid with a value of zero (i.e. sites with no species present).
#' @param remove.sp Logical, if \code{TRUE} the final matrix will not contain species that do not match any cell in the grid.
#' @param show.matrix Logical, if \code{TRUE} only the presence-absence matrix will be shown.
#' @param crs Character representign the PROJ.4 type description of a Coordinate Reference System (map projection).
#' @param count Logical, if \code{TRUE} a counting window will open.
#' 
#' 
#' @return The result is an object of class PresenceAbsence with the following objects:
#' @return \strong{Presence-Absence Matrix}: A matrix of species' presence(1) and absence(0) information. The first two columns contain the longitude (x) and latitude (y) of the cells' centroid (from the gridded domain used);
#' @return \strong{Richness Raster}: A raster containing species richness data;
#' @return \strong{Species name}: A character vector with species' names contained in the matrix.
#' @return *But see the optional argument \code{show.matrix}.
#' 
#'  
#' @details The function creates the presence-absence matrix based on a raster file. Depending on the cell size, extension used and number of species it may require a lot of memory, 
#'and may take some time to process it. Thus, during the process, if \code{count} argument is set \code{TRUE}, a counting window will open so you can see the progress (i.e. in what polygon the function is working). Note that the number of 
#'polygons is not the same as the number of species that you have (i.e. a species may have more than one polygon/shapefiles).
#' 
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.shFilter}}
#' 
#' @examples \dontrun{
#' species <- c(rep("sp1", 100), rep("sp2", 100), rep("sp3", 100), rep("sp4", 100))
#' x <- runif(400, min = -69, max = -51)
#' y <- runif(400, min = -23, max = -4)
#' xy <- cbind(x,y)
#' PAM <- lets.presab.points(xy, species, xmn=-93, xmx=-29, ymn= -57, ymx=15)
#' summary(PAM)
#' require(maps)
#' plot(PAM)  # Species richness map
#' plot(PAM, name="sp1")  # Map of the specific species
#' }
#' 
#' 
#' @export



lets.presab.points <- function(xy, species, xmn=-180, xmx=180, ymn=-90, 
                        ymx=90, resol=1, remove.cells=TRUE, 
                        remove.sp=TRUE, show.matrix=FALSE, 
                        crs=CRS("+proj=longlat +datum=WGS84"), 
                        count=FALSE){
  if(is.factor(species)){
    species <- as.character(species)
  }  
  ras <- raster(xmn=xmn, xmx=xmx, ymn=ymn, ymx=ymx, crs=crs)
  res(ras) <- resol
  values(ras) <- 1
  coord <- xyFromCell(ras, 1:length(values(ras)))
  colnames(coord) <- c("Longitude(x)", "Latitude(y)")
  
  nomes <- levels(factor(species))
  
  n <- length(nomes)
  matriz <- matrix(0, ncol=n, nrow=length(values(ras)))
  colnames(matriz) <- nomes
  
  if(count == TRUE){
    dev.new(width=2, height=2, pointsize = 12)
    par(mar=c(0, 0, 0, 0))
    
  for(i in 1:n){
    plot.new()
    text(0.5, 0.5, paste(paste("Total:", n, "\n","Runs to go: ", (n-i))))
    pos <- which(species==nomes[i])
    xy2 <- xy[pos, ]
    celulas <- extract(ras, xy2, cellnumbers=T) [, 1]
    matriz[celulas, i] <- 1
  }
  dev.off()
  }
  
  
  if(count == FALSE){    
    for(i in 1:n){
      pos <- which(species==nomes[i])
      xy2 <- xy[pos, ]
      celulas <- extract(ras, xy2, cellnumbers=T) [, 1]
      matriz[celulas, i] <- 1
    }
  }  
  
  
  Resultado <- cbind(coord,matriz)
  
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
