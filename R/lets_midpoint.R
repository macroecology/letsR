#' Compute the midpoint of species' geographic ranges
#' 
#' @author Fabricio Villalobos & Bruno Vilela
#' 
#' @description Calculate species' distributional midpoint from a 
#' presence-absence matrix.
#' 
#' @param pam A presence-absence \code{matrix} (sites in the rows and species
#' in the columns, with the first two columns containing the longitudinal
#' and latitudinal coordinates, respectively), or an object of class 
#' \code{\link{PresenceAbsence}}.
#' @param planar Logical, if \code{FALSE} the coordinates are in Longitude/Latitude.
#' If \code{TRUE} the coordinates are planar.
#' @param method Users can choose between the geographic midpoint (or center of gravity), 
#' using the option "GM". Alternatively, the midpoint can be calculated as the point
#' that minimize the distance between all cells of the PAM (center of minimun distance),
#' using the method "CMD". 
#' 
#' 
#' @return A \code{data.frame} containing the species' names and geographic coordinates 
#' (longitude [x], latitude [y]) of species' midpoints.
#'           
#' @import fields
#' @import geosphere
#' 
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#' 
#' @examples \dontrun{
#' data(PAM)
#' mid <- lets.midpoint(PAM)
#' } 
#' 
#' @export



lets.midpoint <- function(pam, planar = FALSE, method = "GM") {
  
  if (class(pam) == "PresenceAbsence") {
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
  
  if (method == "GM") {
    for(i in 3:n) {
      pos <- which(pam2[, i] == 1)
      a <- max(pam2[pos, 1])
      b <- min(pam2[pos, 1])
      c <- max(pam2[pos, 2])
      d <- min(pam2[pos, 2])
      
      if (!planar) {
        dis2 <- midPoint(c(a, c), c(b, d))
        
        if (length(pam2[pos, 1]) > 1) {
          dis <- geomean(cbind(pam2[pos, 1], pam2[pos, 2]))
          dist1 <- rdist.earth(cbind(dis[1, 1], 0), 
                               cbind(dis2[1, 1],0),
                               miles = FALSE)
          # An aroximation, not necessary to be so accurate, 
          # to avoid computation time.
          denomina <- (111.321 * 1000) 
          dif <-  dist1 / denomina
          
          if (dif > 150) {
            if (dis2[1, 1] >= 0) {
              dis2[1, 1] <- dis2[1, 1] - 180
            } else {
              dis2[1, 1] <- dis2[1, 1] + 180
            }
          }
        }
        xm[(i - 2)] <- dis2[1, 1]
        ym[(i - 2)] <- dis2[1, 2]
      }
      
      if (planar) {
        xm[(i - 2)] <- mean(c(a, b))
        ym[(i-2)] <- mean(c(c, d))
      }
    }
  }
  
  if (method == "CMD") {
    for (i in 3:n) {
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
          dist.mat <- as.matrix(dist(pam2[loc, 1:2]))
        }
        summed.dist <- apply(dist.mat, 2, sum)
        mid.p <- pam2[loc, 1:2][which.min(summed.dist)[1], ] 
        xm[i - 2] <- mid.p[1]
        ym[i - 2] <- mid.p[2]
      }
    }
  }
  
  resu <- as.data.frame(cbind(species, xm, ym))
  colnames(resu) <- c("Species", "x", "y")
  resu[, 2] <- as.numeric(levels(resu[, 2]))[resu[, 2]]
  resu[, 3] <- as.numeric(levels(resu[, 3]))[resu[, 3]]  
  return(resu)
}
