#' Compute the midpoint of species' geographic ranges
#'
#' @author Fabricio Villalobos & Bruno Vilela
#'
#' @description Calculate species distribution midpoint from a
#'   presence-absence matrix using several methods.
#'
#' @param pam A presence-absence \code{matrix} (sites in the rows and species in
#'   the columns, with the first two columns containing the longitudinal and
#'   latitudinal coordinates, respectively), or an object of class
#'   \code{\link{PresenceAbsence}}.
#' @param planar Logical, if \code{FALSE} the coordinates are in
#'   Longitude/Latitude. If \code{TRUE} the coordinates are planar.
#' @param method Default option, "PC" (polygon centroid) will generate a polygon
#'   from the raster, and calculate the centroid of this polygon based on the
#'   function \code{terra::centroids}. Note that for the "PC" method,
#'   users can only use PresenceAbsence objects. Note also that this method will
#'   not be the best for PresenceAbsence objects made from occurrence records,
#'   or that have multiple disjoint distributions. Users can also choose the
#'   geographic midpoint, using the option "GM". "GM" will create a bounding box
#'   across the extremes of the distribution and calculate the centroid.
#'   Alternatively, the midpoint can be calculated as the point that minimize
#'   the distance between all cells of the PAM, using the method "CMD"(centre of
#'   minimum distance). The user can also calculate the midpoint, based on the
#'   centroid of the minimum convex polygon of the distribution, using the
#'   method "MCC". This last method is useful when using a PresenceAbsence
#'   object made from occurrence records.
#'   @param inside logical. If TRUE the points returned are guaranteed to be
#'     inside the polygons or on the lines, but they are not the true centroids.
#'     True centroids may be outside a polygon, for example when a polygon is
#'     "bean shaped", and they are unlikely to be on their line
#'   
#'
#'
#' @return A \code{data.frame} containing the species' names and geographic
#'   coordinates (longitude [x], latitude [y]) of species' midpoints.
#'
#'
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#'
#' @examples \dontrun{
#' data(PAM)
#' mid <- lets.midpoint(PAM, method = "PC")
#' mid2 <- lets.midpoint(PAM, method = "GM")
#' mid3 <- lets.midpoint(PAM, method = "CMD")
#' mid4 <- lets.midpoint(PAM, method = "MCC")
#' mid5 <- lets.midpoint(PAM, method = "PC", planar = TRUE)
#' mid6 <- lets.midpoint(PAM, method = "GM", planar = TRUE)
#' mid7 <- lets.midpoint(PAM, method = "CMD", planar = TRUE)
#' mid8 <- lets.midpoint(PAM, method = "MCC", planar = TRUE)
#'
#' for (sp in seq_len(nrow(mid))) {
#'  #sp = 4 # Or choose a line or species
#'  plot(PAM, name = mid[sp, 1])
#'  points(mid[sp, -1], col = adjustcolor("blue", .8), pch = 20, cex = 1.5)
#'  points(mid2[sp, -1], col = adjustcolor("green", .8), pch = 20, cex = 1.5)
#'  points(mid3[sp, -1], col = adjustcolor("yellow", .8), pch = 20, cex = 1.5)
#'  points(mid4[sp, -1], col = adjustcolor("purple", .8), pch = 20, cex = 1.5)
#'  points(mid5[sp, -1], col = adjustcolor("orange", .8), pch = 20, cex = 1.5)
#'  points(mid6[sp, -1], col = adjustcolor("black", .8), pch = 20, cex = 1.5)
#'  points(mid7[sp, -1], col = adjustcolor("gray", .8), pch = 20, cex = 1.5)
#'  points(mid8[sp, -1], col = adjustcolor("brown", .8), pch = 20, cex = 1.5)
#'  Sys.sleep(1)
#' }
#' }
#'
#' @export



lets.midpoint <- function(pam, planar = FALSE, method = "PC",
                          inside = FALSE) {
  
  if (!(method %in% c("PC", "CMD", "MCC", "GM"))) {
    stop("method not found. The chosen method should be PC, CMD, MCC or GM.")
  }
  
  if (inherits(pam, "PresenceAbsence")) {
    pam <- .check_pam(pam)
    n <- ncol(pam[[1]])
    species <- pam[[3]]
    pam2 <- pam[[1]]
  } else {
    n <- ncol(pam)
    species <- colnames(pam)[-(1:2)]
    pam2 <- pam
  }
  
  xm <- numeric((n - 2))
  ym <- xm
  
  if (method == "PC") {
    if (!inherits(pam, "PresenceAbsence")) {
      stop("This method only works for PresenceAbsence objects")
    }
    for (i in seq(3, n)) {
      pos <- which(pam2[, i] == 1)
      if (length(pos) == 1) {
        dis2 <- pam2[pos, 1:2, drop = FALSE]
      } else {
        ptemp <- pam[[2]]
        pos2 <- terra::extract(ptemp, pam2[pos, 1:2, drop = FALSE],
                                cells  = TRUE)[, 1]
        terra::values(ptemp)[-pos2] <- NA
        terra::values(ptemp)[pos2] <- 1
        p <- terra::as.polygons(ptemp, dissolve = TRUE)
        dis2 <- terra::centroids(p, inside = inside)
        dis2 <- terra::geom(dis2)[, 3:4, drop = FALSE]
      }
      xm[(i - 2)] <- dis2[1, 1]
      ym[(i - 2)] <- dis2[1, 2]
    }  
  }
  if (method == "GM") {
    for (i in seq(3, n)) {
      pos <- which(pam2[, i] == 1)
      if (length(pos) == 1) { # Only one point
        dis2 <- pam2[pos, 1:2, drop = FALSE]
        xm[(i - 2)] <- dis2[1, 1]
        ym[(i - 2)] <- dis2[1, 2]
        
      } else {
        a <- max(pam2[pos, 1])
        b <- min(pam2[pos, 1])
        c <- max(pam2[pos, 2])
        d <- min(pam2[pos, 2])
        
        if (!planar) {
          if (length(pos) == 2) { # Only two points
            dis2 <- geosphere::midPoint(pam2[pos[1], 1:2], pam2[pos[2], 1:2])
          } else {
            if (a == b | c == d) { # Same lat or long
              if (a == b) {
                dis2 <- geosphere::midPoint(c(a, c), c(a, d))
              } else {
                dis2 <- geosphere::midPoint(c(a, c), c(b, c))
              }
            }
            pol <- matrix(c(a, a, b, b, c, d, d, c), ncol = 2)
            pol <- terra::vect(pol, "polygons")
            dis2 <- terra::centroids(pol, inside)
            dis2 <- terra::geom(dis2)[, 3:4, drop = FALSE]
          }
          xm[(i - 2)] <- dis2[1, 1]
          ym[(i - 2)] <- dis2[1, 2]
        }
        
        if (planar) {
          xm[(i - 2)] <- mean(c(a, b))
          ym[(i - 2)] <- mean(c(c, d))
        }
      }
    }
  }
  if (method == "CMD") {
    for (i in seq(3, n)) {
      loc <- pam2[, i] == 1
      if (sum(loc) == 0) {
        ym[i - 2] <- xm[i - 2] <- NA
      }
      if (sum(loc) == 1) {
        xm[i - 2] <- pam2[loc, 1]
        ym[i - 2] <- pam2[loc, 2]
      }
      if (sum(loc) > 1) {
        if (!planar) {
          dist.mat <- lets.distmat(pam2[loc, 1:2], asdist = FALSE)
        }
        if (planar) {
          dist.mat <- as.matrix(stats::dist(pam2[loc, 1:2]))
        }
        summed.dist <- apply(dist.mat, 2, sum)
        mid.p <- pam2[loc, 1:2][which.min(summed.dist)[1], ] 
        xm[i - 2] <- mid.p[1]
        ym[i - 2] <- mid.p[2]
      }
    }
  }
  if (method == "MCC") { # Minimum convex centroid
    for (i in seq(3, n)) {
      pos <- which(pam2[, i] == 1)
      lpos <- length(pos)
      if (lpos == 1) {
        dis2 <- pam2[pos, 1:2, drop = FALSE]
      } else {
        if (lpos == 2) {
          if (!planar) {
            dis2 <- geosphere::midPoint(pam2[pos[1], 1:2], pam2[pos[2], 1:2])
          } else {
            dis2 <- matrix(colMeans(pam2[pos, 1:2]), ncol = 2)
          }
        } else {
          pam3 <- pam2[pos, 1:2]
          hp <- grDevices::chull(pam2[pos, 1], pam2[pos, 2])
          hp <- c(hp, hp[1])
          p <- terra::vect(pam3[hp, 1:2], type = "polygons")
          dis2 <- terra::centroids(p, inside)
          dis2 <- terra::geom(dis2)[, 3:4, drop = FALSE]
        }
      }
      xm[(i - 2)] <- dis2[1, 1]
      ym[(i - 2)] <- dis2[1, 2]
    }  
  }
  resu <- data.frame("Species" = species,
                        "x" = xm,
                        "y" = ym)
  return(resu)
}
