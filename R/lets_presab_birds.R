#' Create a presence-absence matrix of species' geographic ranges within a grid
#' for the Birdlife spatial data
#'
#' @author Bruno Vilela & Fabricio Villalobos
#'
#' @description Convert species' ranges (in shapefile format and stored in
#'   particular folders) into a presence-absence matrix based on a user-defined
#'   grid. This function is specially designed to work with BirdLife Intl.
#'   shapefiles (\url{https://www.birdlife.org}). (Notice that new versions of
#'   birds spatial data are in a similar format to other groups and should be
#'   run using the lets.presab function. We will keep this function in case
#'   someone needs to use on the previous data format.)
#'
#' @inheritParams lets.presab
#' @param path Path location of folders with one or more species' individual
#'   shapefiles. Shapefiles with more than one species will not work on this
#'   function. To use multi-species shapefiles see \code{\link{lets.presab}}.
#'
#' @inherit lets.presab return
#'
#' @details The function creates the presence-absence matrix based on a raster
#'   file. Depending on the cell size, extension used and number of species it
#'   may require a lot of memory, and may take some time to process it. Thus,
#'   during the process, if \code{count} argument is set \code{TRUE}, a counting
#'   window will open so you can see the progress (i.e. in what polygon the
#'   function is working). Note that the number of polygons is not the same as
#'   the number of species that you have (i.e. a species may have more than one
#'   polygon/shapefiles).
#'
#' @seealso \code{\link{plot.PresenceAbsence}}
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.shFilter}}
#'
#' @examples \dontrun{
#' # Constructing a Presence/Absence matrix for birds
#' # Attention: For your own files, omit the 'system.file'
#' # and 'package="letsR"', these are just to get the path
#' # to files installed with the package.
#' path.Ramphastos <- system.file("extdata", package = "letsR")
#' PAM <- lets.presab.birds(path.Ramphastos, xmn = -93, xmx = -29,
#'                          ymn = -57, ymx = 25)
#'
#' # Species richness map
#' plot(PAM, xlab = "Longitude", ylab = "Latitude",
#'      main = "Ramphastos species Richness")
#'
#' }
#'
#'
#' @import terra
#' @export



lets.presab.birds <-
  function(path,
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
    
  # Shapefile list
  shapes <- list.files(path, pattern = ".shp$", 
                       full.names = TRUE, recursive = TRUE)
  # Adjust null limits and resolution
  if (any(is.null(c(xmn, xmx, ymn, ymx)))) {
    limits <- terra::ext(terra::project(terra::rast(), crs.grid))
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
  
  
  # Corrdinates saved
  valores <- terra::values(ras)
  xy <- terra::xyFromCell(ras, 1:length(valores))
  
  # Generating the empty matrix
  n <- length(shapes)
  nomes <- numeric()
  matriz <- matrix(0, nrow = nrow(xy), ncol = n)
  matriz <- cbind(xy, matriz)
  
  # Control for "after filtering none species distribution left" (see below) 
  k <- numeric(n)
  
  # progress bar
  if (count) {
    pb <- utils::txtProgressBar(min = 0,
                                max = n,
                                style = 3)
  }
  
  test_crs <- as.character(crs) != as.character(crs.grid)
  
  for (i in seq_len(n)) {
    
    # readshape
    shapesi <- terra::vect(shapes[i], crs = as.character(crs))
    if (test_crs) {
      shapesi <- terra::project(shapesi, as.character(crs.grid))
    }
    shapesi <- lets.shFilter(shapesi, 
                             presence,
                             origin, 
                             seasonal)
    k[i] <- nrow(shapesi)
    # Getting species position in the matrix and set to 1
    pospos2 <- .extractpos(ras, shapesi, 
                           nomes = NULL, nomes2 = NULL,
                           cover, i)
    if (length(pospos2$pos2) != 0) {
      matriz[pospos2$pos2, i + 2] <- 1
    }
    nomes[i] <- shapesi$SCINAME[1]
    # progress bar
    if (count) {
      utils::setTxtProgressBar(pb, i)
    }
    
  }  

  
  if (all(k == 0)) {
    stop("after filtering, no species distribution left")
  }
  
  colnames(matriz) <- c("Longitude(x)", "Latitude(y)", nomes)
  
  riqueza <- rowSums(matriz[, -c(1, 2), drop = FALSE])  
  
  # Remove cells without presence if TRUE
  if (remove.cells) {
    matriz <- .removeCells(matriz)
  }
  
  # Remove species without presence if TRUE
  if (remove.sp) {
    matriz <- .removeSp(matriz)
  }
  
  # Putting together species with more than one shapefile
  matriz <- .unicas(matriz)
  
  # Close progress bar
  if (count) {
    close(pb)
  }
  
  # Return result (depending on what the user wants)
  if (show.matrix) {
    return(matriz)
  } else {
    terra::values(ras) <- riqueza
    final <-
      list(
        "Presence_and_Absence_Matrix" = matriz,
        "Richness_Raster" = ras,
        "Species_name" = (colnames(matriz)[-(1:2)])
      )
    class(final) <- "PresenceAbsence"
    return(final)
  }
  }
