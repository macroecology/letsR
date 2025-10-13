#' Plot species richness in environmental and geographical space
#'
#'@author Bruno Vilela
#'
#'@description
#'This function plots species richness in both environmental and geographical space
#'based on the output of \code{\link{lets.envpam}}. It can optionally highlight species
#'distributions, individual cells, or regions in both spaces.
#'
#'@param x The output object from \code{\link{lets.envpam}}).
#'@param species A character string indicating the species name to be highlighted in both plots.
#'@param cell_id_env An integer or vector of integers indicating environmental space cell(s) to be highlighted.
#'@param cell_id_geo An integer or vector of integers indicating geographic cell(s) to be highlighted.
#'@param geo_plot Logical. Should the geographic richness map also be plotted? Default is TRUE.
#'@param env_plot Logical. Should the environmental space richness map also be plotted? Default is TRUE.
#'@param world Logical. If TRUE, plots a base map using the `wrld_simpl` object from the `letsR` package over the geographic raster.
#'@param rast_return Logical. If TRUE, returns the modified raster objects instead of plotting.
#'@param col_rich A custom color ramp palette function to use for plotting richness (e.g., from \code{colorRampPalette}).
#'@param ... Additional arguments passed to the \code{\link{plot}} function for rasters.
#'
#'@details
#'This function provides a visual summary of species richness across both geographic and environmental dimensions.
#'Users can highlight specific species or environmental/geographical cells. When a highlight is selected, both rasters are
#'modified to display only presences related to the selected species or cells, and all other cells are greyed out.
#'
#'@seealso \code{\link{lets.envpam}}, \code{\link{lets.presab}}, \code{\link{plot.PresenceAbsence}}
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
#' # Create environmental PAM
#' res <- lets.envpam(PAM, envs)
#'
#' # Plot both spaces
#' lets.plot.envpam(x = res,
#'             species = NULL,
#'             cell_id_env = NULL,
#'             cell_id_geo = NULL,
#'             geo_plot = TRUE,
#'             world = TRUE,
#'             mar = c(4, 4, 4, 4))
#'
#' # Highlight a single species
#' lets.plot.envpam(res, species = "Phyllomedusa_atlantica")
#'}
#'
#'@export
#'@import terra


lets.plot.envpam <- function(x,
                             species = NULL,
                             cell_id_env = NULL,
                             cell_id_geo = NULL,
                             geo_plot = TRUE,
                             env_plot = TRUE,
                             world = TRUE,
                             rast_return = FALSE,
                             col_rich = NULL,
                             ...) {
  check_a <- !is.null(cell_id_env)
  check_b <- !is.null(cell_id_geo)
  check_c <- !is.null(species)
  check_all <- sum(check_a, check_b, check_c)
  
  if (check_all > 1) {
    stop("More than one highligh was indicated, please choose one option.")
  }
  if (check_all == 1) {
    if (check_a) {
      pos <- x[[2]][, 1] %in% cell_id_env
    }
    if (check_b) {
      pos <- x[[2]][, 2] %in% cell_id_geo
    }
    if (check_c) {
      sp_id <- colnames(x[[2]]) == species
      pos <- x[[2]][, sp_id] == 1
    }
    cell_id_env <- x[[2]][pos, 1]
    cell_id_geo <- x[[2]][pos, 2]
    n1 <- terra::ncell(x[[3]])
    n2 <- terra::ncell(x[[4]])
    
    v1 <- terra::values(x[[3]])
    v1[(!1:n1 %in% cell_id_env) & !is.na(v1)] <- 0
    v1[1:n1 %in% cell_id_env] <- 1
    terra::values(x[[3]]) <- v1
    
    v2 <- terra::values(x[[4]])
    v2[(!1:n2 %in% cell_id_geo) & !is.na(v2)] <- 0
    v2[1:n2 %in% cell_id_geo] <- 1
    terra::values(x[[4]]) <- v2
  }
  labs <- colnames(x[[1]])[2:3]
  
  # Creating the color function
  if (is.null(col_rich)) {
    if (check_all == 0) {
      # Colour ramp from colorbrewer (T. Lucas suggestion)
      colfunc <- grDevices::colorRampPalette(c("#fff5f0", "#fb6a4a", "#67000d"))
    } else {
      colfunc <- grDevices::colorRampPalette(c("gray90", "red"))
    }
    
  } else {
    colfunc <- col_rich
  }
  if ((geo_plot & env_plot)) {
    par(mfrow = c(1, 2))
  } 
  if (geo_plot) {
    n_col <- length(table(terra::values(x[[4]])))
    plot(x[[4]], main = "Geographical space", 
         col =  colfunc(n_col + 1),
         ylab = "Latitude", xlab = "Longitude", 
         ...)
    if (world) {
      wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
      plot(sf::st_geometry(wrld_simpl), add = TRUE)
    }
  }
  if (env_plot) {
  # Extract matrix of values (z)
  n_col2 <- length(table(terra::values(x[[3]])))
  # Get raster extent
  ext_vals <- terra::ext(x[[3]])
  x_range <- ext_vals[2] - ext_vals[1]  # xmax - xmin
  y_range <- ext_vals[4] - ext_vals[3]  # ymax - ymin
  
  # Compute aspect ratio
  asp_ratio <- x_range / y_range
  
  plot(x[[3]],
       main = "Environmental space",
       col = colfunc(n_col2 + 1),
       asp = asp_ratio,
       xlab = labs[1],
       ylab = labs[2],
       ...)
  }
  if (rast_return) {
    return(x[[3]])
  } else {
    invisible(NULL)
  }
}
