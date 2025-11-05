#'Create a presence–absence matrix in environmental space
#'
#'@author Bruno Vilela
#'
#'@description Transform a presence–absence matrix (PAM) based on geographic
#'  coordinates into a new PAM structured in environmental space. The function
#'  rasterizes the environmental variable space (based on two continuous
#'  environmental predictors), and assigns species presences to binned
#'  environmental conditions, producing a species richness raster in
#'  environmental space.
#'
#'@param pam A `PresenceAbsence` object, typically created using
#'  \code{\link{lets.presab}}.
#'@param envs A two-column matrix or data frame with continuous environmental
#'  variables corresponding to the coordinates in the PAM. The first column will
#'  be used as the x-axis and the second as the y-axis in the environmental
#'  space.
#'@param n_bins Number of bins used to discretize each environmental variable.
#'  Default is 30.
#'@param remove.cells Logical. Should cells with no species be removed from the
#'  final matrix?
#'@param remove.sp Logical. Should species with no occurrences in environmental
#'  space be removed?
#'@param count Logical. If TRUE, displays a progress bar for species processing.
#'
#'@return A list with the following elements:
#'\itemize{
#'  \item \code{Presence_and_Absence_Matrix_env}: A matrix of species presences across environmental bins.
#'  \item \code{Presence_and_Absence_Matrix_geo}: The original PAM coordinates associated with environmental cells.
#'  \item \code{Env_Richness_Raster}: A raster layer of species richness in environmental space.
#'  \item \code{Geo_Richness_Raster}: The original species richness raster in geographic space.
#'}
#'
#'@details This function projects species occurrences into a two-dimensional
#'  environmental space, facilitating ecological analyses that depend on
#'  environmental gradients. The environmental space is discretized into a
#'  regular grid (determined by \code{n_bins}), and each cell is assigned the
#'  number of species occurring under those environmental conditions. 
#'
#'@seealso \code{\link{lets.presab}}, \code{\link{lets.addvar}},
#'  \code{\link{lets.plot.envpam}}
#'
#'@examples
#'\dontrun{
#' # Load data
#' data("Phyllomedusa")
#' data("prec")
#' data("temp")
#'
#' prec <- unwrap(prec)
#' temp <- unwrap(temp)
#' PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
#' envs <- lets.addvar(PAM, c(temp, prec), onlyvar = TRUE)
#' colnames(envs) <- c("Temperature", "Preciptation")
#' wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
#' PAM <- lets.pamcrop(PAM, vect(wrld_simpl))
#'
#' # Run function
#' res <- lets.envpam(PAM, envs)
#'
#' # Plot results
#' lets.plot.envpam(x = res,
#'             species = NULL,
#'             cell_id_env = NULL,
#'             cell_id_geo = NULL,
#'             T,
#'             world = TRUE,
#'             mar = c(4, 4, 4, 4))
#'}
#'
#'@export
#'@import terra




lets.envpam <- function(pam,
                        envs,
                        n_bins = 30,
                        remove.cells = TRUE,
                        remove.sp = TRUE,
                        count = FALSE) {
  
  # Calculations
  pam_mat <- pam$Presence_and_Absence_Matrix # with the xy

  # Check for NAs in envs
  keep <- !(is.na(envs[, 1]) | is.na(envs[, 2]))
  if (any(!keep)) {
    warning("Some environmental data have NA values, these data will be excluded.")
    envs <- envs[keep, ]
    pam_mat <- pam_mat[keep, ]
  }

  xy_pam <- pam_mat[, 1:2]
  pam_mat <- pam_mat[, -(1:2)]
  n <- ncol(pam_mat)

  # Get the range of each environmental variable
  x_range <- range(envs[, 1], na.rm = TRUE)  # e.g., temperature
  y_range <- range(envs[, 2], na.rm = TRUE)  # e.g., precipitation
  
  # Bin edges for each axis
  x_breaks <- seq(x_range[1], x_range[2], length.out = n_bins + 1)
  y_breaks <- seq(y_range[1], y_range[2], length.out = n_bins + 1)
  
  # Assign each observation to a bin
  x_bin <- cut(envs[, 1], breaks = x_breaks, include.lowest = TRUE)
  y_bin <- cut(envs[, 2], breaks = y_breaks, include.lowest = TRUE)
  
  # Count occurrences per bin (as 2D frequency table)
  freq_table <- table(x_bin, y_bin)
  
  # Convert to matrix and clean up
  freq_matrix <- matrix(as.numeric(freq_table), nrow = n_bins, ncol = n_bins)
  freq_matrix[freq_matrix == 0] <- NA
  
  # Flip y-axis if needed
  freq_matrix <- t(freq_matrix[, ncol(freq_matrix):1])
  
  # Create raster
  ras <- terra::rast(freq_matrix)
  
  # Set extent based on actual variable ranges
  terra::ext(ras) <- c(min(x_breaks), max(x_breaks), min(y_breaks), max(y_breaks))
  
  # Add species
  # Coordinates xy
  l.values <- length(terra::values(ras))
  coord <- terra::xyFromCell(ras, 1:l.values)
  colnames(coord) <- colnames(envs)
  
  # Extract positions
  celulas <- terra::extract(ras, envs, cells = TRUE)[, 1]
  celulas_ras <- terra::extract(pam$Richness_Raster, xy_pam, cells = TRUE)[, 1]

  # Matrix creation
  nomes <- colnames(pam_mat)
  n <- length(nomes)
  matriz <- matrix(0, ncol = n, nrow = l.values)
  colnames(matriz) <- nomes

  # progress bar
  if (count) {
    pb <- utils::txtProgressBar(min = 0,
                                max = n,
                                style = 3)
  }

  for (i in seq_len(n)) {
    celulas2 <- celulas[pam_mat[, i] == 1]
    matriz[celulas2, i] <- 1
    if (count) {
      utils::setTxtProgressBar(pb, i)
    }

  }

  Resultado <- cbind("Cell_env" = 1:l.values,
                     coord, matriz)
  Resultado2 <- cbind("Cell_env" = celulas,
                      "Cell_geo" = celulas_ras,
                      pam$Presence_and_Absence_Matrix[keep, ])


  if (remove.cells) {
    Resultado <- .removeCells(Resultado)
  }
  if (remove.sp) {
    Resultado <- .removeSp(Resultado)
  }

  # Close progress bar
  if (count) {
    close(pb)
  }
  ras_rich <- ras
  rich <- rowSums(matriz)
  terra::values(ras_rich) <- ifelse(rich == 0, NA, rich)

  pos_0 <- which(is.na(terra::values(ras_rich)) &
        !is.na(terra::values(ras)))
  terra::values(ras_rich)[pos_0] <- 0
  # values(PAM$Richness_Raster)[values(PAM$Richness_Raster) == 0] <- NA

  final <- list("Presence_and_Absence_Matrix_env" = Resultado,
                "Presence_and_Absence_Matrix_geo" = Resultado2,
                "Env_Richness_Raster" = ras_rich,
                "Geo_Richness_Raster" = pam$Richness_Raster)

  return(final)
}


