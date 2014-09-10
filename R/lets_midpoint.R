#' Species' geographical range midpoint
#' 
#' @author Fabricio Villalobos & Bruno Vilela
#' 
#' @description Calculate species' geographical range midpoint from a presence-absence matrix.
#' 
#' @usage lets.midpoint(pam, planar=FALSE)
#' 
#' @param pam A presence-absence matrix (sites in the rows and species in the columns, with the first two columns being longitude and latitude coordinates, respectively), or an object of class PresenceAbsence.
#' @param planar Logical, if \code{FALSE} the coordinates are in Longitude/Latitude. If \code{TRUE} the coordinates are planar.
#' 
#' @return A matrix containing the species' names and coordinates (longitude [x], latitude [y]) of species' midpoints.
#'           
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



lets.midpoint <- function(pam, planar=FALSE){
  if(class(pam)=="PresenceAbsence"){
  n <- ncol(pam$P)
  species <- pam$S
  pam2 <- pam$P
  }else{
    n <- ncol(pam)
    species <- colnames(pam)[-(1:2)]
    pam2 <- pam
  }  
  
  xm <- numeric((n-2))
  ym <- numeric((n-2))
  
  for(i in 3:n){
  
  pos <- which(pam2[,i]==1)
  
  a <- max(pam2[pos, 1])
  b <- min(pam2[pos, 1])
  c <- max(pam2[pos, 2])
  d <- min(pam2[pos, 2])
  
  if(planar==F){
  dis2 <- midPoint(c(a,c), c(b,d))
  
  if(length(pam2[pos, 1])>1){
  dis <- geomean(cbind(pam2[pos, 1], pam2[pos, 2]))  
  dif <- distCosine(c(dis[1, 1], 0), c(dis2[1, 1],0))/(111.321*1000) 
  
  if(dif>150){
    if(dis2[1, 1]>=0){
    dis2[1, 1] <- dis2[1, 1]-180
    }else{
      dis2[1, 1] <- dis2[1, 1]+180
    }
  }
  }
  xm[(i-2)] <- dis2[1, 1]
  ym[(i-2)] <- dis2[1, 2]
  
  }

  if(planar==T){
    xm[(i-2)] <- mean(c(a,b))
    ym[(i-2)] <- mean(c(c,d))
  }
  
  }
  resu <- as.data.frame(cbind(species, xm, ym))
  colnames(resu) <- c("Species", "x", "y")
  resu[, 2] <- as.numeric(levels(resu[, 2]))[resu[, 2]]
  resu[, 3] <- as.numeric(levels(resu[, 3]))[resu[, 3]]  
  return(resu)
}
