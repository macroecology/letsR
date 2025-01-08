#'Create a presence-absence matrix of species' geographic ranges within a grid
#'
#'@author Bruno Vilela & Fabricio Villalobos
#'
#'@description Convert species' ranges (in shapefile format) into a
#'  presence-absence matrix based on a user-defined grid system
#'
#'@param shapes Object of class \code{SpatVect} or \code{Spatial} (see packages
#'  \code{\link{terra}} and  \code{\link{sf}} to read these files) containing
#'  the distribution of one or more species. Species names should be stored in
#'  the object as BINOMIAL/binomial or SCINAME/sciname. 
#'@param xmx Maximum longitude used to construct the grid in which the matrix
#'  will be based (i.e. the [gridded] geographic domain of interest). 
#'  If NULL, limits will be calculated based on the limits of the shapes object.
#'@param xmn Minimum longitude used to construct the grid in which the matrix
#'  will be based (i.e. the [gridded] geographic domain of interest).
#'  If NULL, limits will be calculated based on the limits of the shapes object.
#'@param ymx Maximum latitude used to construct the grid in which the matrix
#'  will be based (i.e. the [gridded] geographic domain of interest).
#'  If NULL, limits will be calculated based on the limits of the shapes object.
#'@param ymn Minimum latitude used to construct the grid in which the matrix
#'  will be based (i.e. the [gridded] geographic domain of interest).
#'  If NULL, limits will be calculated based on the limits of the shapes object.
#'@param resol Numeric vector of length 1 or 2 to set the grid resolution. 
#'If NULL, resolution will be equivalent to 1 degree of latitude and longitude.
#'@param remove.cells Logical, if \code{TRUE} the final matrix will not contain
#'  cells in the grid with a value of zero (i.e. sites with no species present).
#'@param remove.sp Logical, if \code{TRUE} the final matrix will not contain
#'  species that do not match any cell in the grid.
#'@param show.matrix Logical, if \code{TRUE} only the presence-absence matrix
#'  will be returned.
#'@param crs Character representing the PROJ.4 type description of a Coordinate
#'  Reference System (map projection) of the polygons.
#'@param crs.grid Character representing the PROJ.4 type description of a
#'  Coordinate Reference System (map projection) for the grid. Note that when
#'  you change this options you may probably change the extent coordinates and
#'  the resolution.
#'@param cover Percentage of the cell covered by the shapefile that will be
#'  considered for presence (values between 0 and 1).
#'@param presence A vector with the code numbers for the presence type to be
#'  considered in the process (for IUCN spatial data
#'  \url{https://www.iucnredlist.org/resources/spatial-data-download}, see
#'  metadata).
#'@param origin A vector with the code numbers for the origin type to be
#'  considered in the process (for IUCN spatial data).
#'@param seasonal A vector with the code numbers for the seasonal type to be
#'  considered in the process (for IUCN spatial data).
#'@param count Logical, if \code{TRUE} a progress bar indicating the processing 
#'progress will be shown.
#'
#'
#'@return The result is a list object of class \code{\link{PresenceAbsence}}
#'  with the following objects: \strong{Presence-Absence Matrix}: A matrix of
#'  species' presence(1) and absence(0) information. The first two columns
#'  contain the longitude (x) and latitude (y) of the cells' centroid (from the
#'  gridded domain used); \strong{Richness Raster}: A raster containing species
#'  richness data; \strong{Species name}: A character vector with species' names
#'  contained in the matrix.
#' *But see the optional argument \code{show.matrix}.
#'
#'
#'@details This function creates the presence-absence matrix based on a raster
#'  object. Depending on the cell size, extension used and number of species it
#'  may require a lot of memory, and may take some time to process it. Thus,
#'  during the process, if \code{count} argument is set \code{TRUE}, a counting
#'  window will open to display the progress (i.e. the polygon/shapefile
#'  that the function is working on). Note that the number of polygons is not the same
#'  as the number of species (i.e. a species may have more than
#'  one polygon/shapefiles).
#'
#'@seealso \code{\link{plot.PresenceAbsence}}
#'@seealso \code{\link{lets.presab.birds}}
#'@seealso \code{\link{lets.shFilter}}
#'
#' @examples \dontrun{
#' # Spatial distribution polygons of South American frogs
#' # of genus Phyllomedusa.
#' data(Phyllomedusa)
#' PAM <- lets.presab(Phyllomedusa)
#' summary(PAM)
#' # Species richness map
#' plot(PAM, xlab = "Longitude", ylab = "Latitude",
#'      main = "Phyllomedusa species richness")
#' # Map of individual species
#' plot(PAM, name = "Phyllomedusa nordestina")
#'}
#'
#'
#'@export


lets.presab <- function(shapes,
                        xmn = NULL,
                        xmx = NULL,
                        ymn = NULL,
                        ymx = NULL,
                        resol = NULL,
                        remove.cells = TRUE,
                        remove.sp = TRUE,
                        show.matrix = FALSE,
                        crs = "+proj=longlat +datum=WGS84",
                        crs.grid = crs,
                        cover = 0,
                        presence = NULL,
                        origin = NULL,
                        seasonal = NULL,
                        count = FALSE) {
  
  # look for species names
  if(!any(c("binomial","BINOMIAL","SCINAME","sciname") %in% names(shapes)))
  {
    stop(paste0("species names missing from shapes ",
                "or column name in data does not match required names"))
  }
  
  
  shapes <- .check_shape(shapes)
  
  # Projection set for spatial polygons
  terra::crs(shapes) <- as.character(crs)
  
  if (as.character(crs) != as.character(crs.grid)) {
    shapes <- terra::project(shapes, crs.grid)
  }
  
  # Filter the species range distribution
  if (!all(is.null(presence), is.null(origin), is.null(seasonal))) {
    shapes <- lets.shFilter(
      shapes = shapes,
      presence = presence,
      origin = origin,
      seasonal = seasonal
    )
  }
  
  # Error control for no shapes after filtering
  if (is.null(shapes) | nrow(shapes) == 0) {
    stop("After filtering no species distributions left")
  }
  
  
  # Adjust null limits and resolution
  if (any(is.null(c(xmn, xmx, ymn, ymx)))) {
    limits <- terra::ext(shapes)
    xmn <- limits[1]
    xmx <- limits[2]
    ymn <- limits[3]
    ymx <- limits[4]
  }
  
  if (is.null(resol)) {
    resol <- terra::res(terra::project(terra::rast(), crs.grid))
  }
  
  # Raster creation
  ras <- terra::rast(
    xmin = xmn,
    xmax = xmx,
    ymin = ymn,
    ymax = ymx,
    crs = as.character(crs.grid), 
    resolution = resol
  )
  terra::values(ras) <- 1
  
  # Coordinates saved
  ncellras <- terra::ncell(ras)
  coord <- terra::xyFromCell(object = ras, cell = 1:ncellras)
  colnames(coord) <- c("Longitude(x)", "Latitude(y)")
  

  # Getting species name
  names(shapes) <- toupper(names(shapes))
  names(shapes)[names(shapes) %in% c("SCINAME",
                                     "SCI_NAME",
                                     "SPECIES")] <- "BINOMIAL"
  nomes <- sort(unique(shapes$BINOMIAL))
  nomes2 <- shapes$BINOMIAL
  nomes <- nomes[nomes %in% nomes2]
  
  n <- length(shapes$BINOMIAL)
  
  # Generating the empty matrix
  matriz <- matrix(0, ncol = length(nomes), nrow = ncellras)
  colnames(matriz) <- nomes
  
  # progress bar
  if (count) {
    pb <- utils::txtProgressBar(min = 0,
                                max = n,
                                style = 3)
  }
  # Loop start, running repetitions for the number of polygons (n)
  for (i in seq_len(n)) {
    # Getting species position in the matrix and set to 1
    pospos2 <- .extractpos(ras, shapes[i,], nomes, nomes2,
                           cover, i)
    if (length(pospos2$pos2) != 0) {
      matriz[pospos2$pos2, pospos2$pos] <- 1
    }
    # progress bar
    if (count) {
      utils::setTxtProgressBar(pb, i)
    }
  }
  
  
  # Adding the coordinates to the matrix
  Resultado <- cbind(coord, matriz)
  
  # Remove cells without presence if TRUE
  if (remove.cells) {
    Resultado <- .removeCells(Resultado)
  }
  
  # Remove species without presence if TRUE
  if (remove.sp) {
    Resultado <- .removeSp(Resultado)
  }
  # Close progress bar
  if (count) {
    close(pb)
  }
  # Return result (depending on what the user wants)
  if (show.matrix) {
    return(Resultado)
  } else {
    values(ras) <- rowSums(matriz)
    final <- list(
      "Presence_and_Absence_Matrix" = Resultado,
      "Richness_Raster" = ras,
      "Species_name" = colnames(Resultado)[-(1:2)]
    )
    class(final) <- "PresenceAbsence"
    return(final)
  }
}




# Helper function to avoid code repetition inside the loop <<<<<<<<<

# Function to extract cell positions in the raster
.extractpos <- function(ras,
                        shapepol,
                        nomes = NULL,
                        nomes2 = NULL,
                        cover,
                        i) {
  # Try the extraction of cell occurrence positions
  shapepol1 <- shapepol
  celulas <- terra::extract(
    ras,
    shapepol1,
    cells = TRUE,
    exact = TRUE
  )
  
  # Getting column positions (not for birds)
  if (!is.null(nomes2)) {
    pos <- which(nomes2[i] == nomes)
  } else {
    pos <- NULL
  }
  # Correcting presence based on the cover
  if (cover > 0) {
    celulas <- celulas[celulas$fraction >= cover, , drop = FALSE]
  }
  
  # Getting row positions
  pos2 <- celulas$cell
  
  # Return row and column position
  return (list("pos" = pos, "pos2" = pos2))
}
