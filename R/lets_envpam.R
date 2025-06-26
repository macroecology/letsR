# library(letsR)
# 
# # Load data
# data("Phyllomedusa")
# data("prec")
# data("temp")
# 
# prec <- unwrap(prec)
# temp <- unwrap(temp)
# PAM <- lets.presab(Phyllomedusa, remove.cells = FALSE)
# envs <- lets.addvar(PAM, c(prec, temp), onlyvar = TRUE) # Two column env
# colnames(envs) <- c("Preciptation", "Temperature")
# wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
# PAM <- lets.pamcrop(PAM, vect(wrld_simpl))
# 
# 
# 
# # # for the tests only
# n_bins = 50; remove.cells = TRUE;
# remove.sp = TRUE; count = FALSE
# 
# 
# lets.envpam <- function(pam, envs, n_bins = 50,
#                         remove.cells = TRUE,
#          remove.sp = TRUE, count = FALSE) {
# 
#   # Calculations
#   pam_mat <- pam$Presence_and_Absence_Matrix # with the xy
# 
#   # Check for NAs in envs
#   keep <- !(is.na(envs[, 1]) | is.na(envs[, 2]))
#   if (any(!keep)) {
#     warning("Some environmental data have NA values, these data will be excluded.")
#     envs <- envs[keep, ]
#     pam_mat <- pam_mat[keep, ]
#   }
# 
#   xy_pam <- pam_mat[, 1:2]
#   pam_mat <- pam_mat[, -(1:2)]
#   n <- ncol(pam_mat)
# 
#   # Create raster env
#   envs <- apply(envs, 2, scale)
#   var1_bins <- cut(envs[, 1], breaks = n_bins,
#                    include.lowest = TRUE)
#   var2_bins <- cut(envs[, 2], breaks = n_bins,
#                    include.lowest = TRUE)
#   ## Get frequency
#   freq_table <- table(var1_bins, var2_bins)
#   freq_matrix <- as.numeric(freq_table)
#   freq_matrix <- ifelse(freq_matrix == 0, NA, freq_matrix)
#   freq_matrix <- matrix(freq_matrix, nrow = n_bins, ncol = n_bins)
#   freq_matrix <- t(freq_matrix[, ncol(freq_matrix):1])
# 
#   ## Make raster
#   ras <- terra::rast(freq_matrix)
#   ext(ras) <- c(min(envs[, 1]), max(envs[, 1]),
#                         min(envs[, 2]), max(envs[, 2]))
#   # Add species
#   # Coordinates xy
#   l.values <- length(values(ras))
#   coord <- terra::xyFromCell(ras, 1:l.values)
#   colnames(coord) <- colnames(envs)
# 
#   # Extract positions
#   celulas <- terra::extract(ras, envs, cells = TRUE)[, 1]
#   celulas_ras <- terra::extract(pam$Richness_Raster, xy_pam, cells = TRUE)[, 1]
# 
#   # Matrix creation
#   nomes <- colnames(pam_mat)
#   n <- length(nomes)
#   matriz <- matrix(0, ncol = n, nrow = l.values)
#   colnames(matriz) <- nomes
# 
#   # progress bar
#   if (count) {
#     pb <- utils::txtProgressBar(min = 0,
#                                 max = n,
#                                 style = 3)
#   }
# 
#   for (i in seq_len(n)) {
#     celulas2 <- celulas[pam_mat[, i] == 1]
#     matriz[celulas2, i] <- 1
#     if (count) {
#       utils::setTxtProgressBar(pb, i)
#     }
# 
#   }
# 
#   Resultado <- cbind("Cell_env" = 1:l.values,
#                      coord, matriz)
#   Resultado2 <- cbind("Cell_env" = celulas,
#                       "Cell_geo" = celulas_ras,
#                       pam$Presence_and_Absence_Matrix[keep, ])
# 
# 
#   if (remove.cells) {
#     Resultado <- .removeCells(Resultado)
#   }
#   if (remove.sp) {
#     Resultado <- .removeSp(Resultado)
#   }
# 
#   # Close progress bar
#   if (count) {
#     close(pb)
#   }
#   ras_rich <- ras
#   rich <- rowSums(matriz)
#   terra::values(ras_rich) <- ifelse(rich == 0, NA, rich)
# 
#   pos_0 <- which(is.na(values(ras_rich)) &
#         !is.na(values(ras)))
#   values(ras_rich)[pos_0] <- 0
#   # values(PAM$Richness_Raster)[values(PAM$Richness_Raster) == 0] <- NA
# 
#   final <- list("Presence_and_Absence_Matrix_env" = Resultado,
#                 "Presence_and_Absence_Matrix_geo" = Resultado2,
#                 "Env_Richness_Raster" = ras_rich,
#                 "Env_Frequency_Raster" = ras,
#                 "Geo_Richness_Raster" = pam$Richness_Raster)
# 
#   return(final)
# }
# 
# 
# 
# 
# plot.envpam <- function(x,
#                         species = NULL,
#                         cell_id_env = NULL,
#                         cell_id_geo = NULL,
#                         world = FALSE,
#                         rast_return = FALSE,
#                         countour_plot = FALSE,
#                         ...) {
#   check_a <- !is.null(cell_id_env)
#   check_b <- !is.null(cell_id_geo)
#   check_c <- !is.null(species)
#   check_all <- sum(check_a, check_b, check_c)
#   if (check_all > 1) {
#     stop("More than one highligh was indicated, please choose one option.")
#   }
#   if (check_all == 1) {
#     if (check_a) {
#       pos <- x$Presence_and_Absence_Matrix_geo[, 1] %in% cell_id_env
#     }
#     if (check_b) {
#       pos <- x$Presence_and_Absence_Matrix_geo[, 2] %in% cell_id_geo
#     }
#     if (check_c) {
#       sp_id <- colnames(x$Presence_and_Absence_Matrix_geo) == species
#       pos <- x$Presence_and_Absence_Matrix_geo[, sp_id] == 1
#     }
#     cell_id_env <- x$Presence_and_Absence_Matrix_geo[pos, 1]
#     cell_id_geo <- x$Presence_and_Absence_Matrix_geo[pos, 2]
# 
#     par(mfrow = c(1, 2))
#     n1 <- ncell(x$Env_Richness_Raster)
#     n2 <- ncell(x$Geo_Richness_Raster)
# 
#     v1 <- values(x$Env_Richness_Raster)
#     v1[(!1:n1 %in% cell_id_env) & !is.na(v1)] <- 0
#     v1[1:n1 %in% cell_id_env] <- 1
#     values(x$Env_Richness_Raster) <- v1
# 
#     v2 <- values(x$Geo_Richness_Raster)
#     v2[(!1:n2 %in% cell_id_geo) & !is.na(v2)] <- 0
#     v2[1:n2 %in% cell_id_geo] <- 1
#     values(x$Geo_Richness_Raster) <- v2
#   }
#   labs <- colnames(x$Presence_and_Absence_Matrix_env)[2:3]
#   par(mfrow = c(1, 2))
#   plot(x$Geo_Richness_Raster, main = "Geographical space", ...)
#   if (world) {
#     wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
#     plot(sf::st_geometry(wrld_simpl), add = TRUE)
#   }
#   plot(x$Env_Richness_Raster, main = "Environmental space",
#        xlab = labs[1], ylab = labs[2], ...)
#   if (countour_plot) {
#     contour(x$Env_Frequency_Raster, add = TRUE,
#             drawlabels=T, lwd = 1)
#   }
#   # Avoid return map
#   if (rast_return) {
#     return(list(
#       "Env_raster" = x$Env_Richness_Raster,
#       "Geo_raster" = x$Geo_Richness_Raster
#     ))
#   } else {
#     invisible(NULL)
#   }
# }
# 
# 
# 
# plot.envfreq <- function(x, rast_return = FALSE, world = TRUE, ...) {
#   freq_vec <- table(x$Presence_and_Absence_Matrix_geo[, 1])
#   geo <- x$Presence_and_Absence_Matrix_geo[, 2]
#   freq_env <- freq_vec[match(x$Presence_and_Absence_Matrix_geo[, 1],
#                              names(freq_vec))]
#   values(x$Geo_Richness_Raster)[geo] <- as.numeric(freq_env)
#   par(mfrow = c(1, 2))
#   plot(x$Geo_Richness_Raster, main = "Geographical space", ...)
#   if (world) {
#     wrld_simpl <- get(utils::data("wrld_simpl", package = "letsR"))
#     plot(sf::st_geometry(wrld_simpl), add = TRUE)
#   }
#   plot(x$Env_Frequency_Raster, main = "Environmental space", ...)
# 
#   # Avoid return map
#   if (rast_return) {
#     return(list(
#       "Env_raster" = x$Env_Frequency_Raster,
#       "Geo_raster" = x$Geo_Richness_Raster
#     ))
#   } else {
#     invisible(NULL)
#   }
# }
# 
# 
# # test
# res <- lets.envpam(PAM, envs, n_bin = 20)
# 
# 
# # Plots
# plot.envpam(x = res,
#             NULL,
#             cell_id_env =,
#             cell_id_geo = NULL,
#             world = T,
#             countour_plot = F,
#             type = "classes",
#             col = )
# plot.envfreq(x = res)
# 
