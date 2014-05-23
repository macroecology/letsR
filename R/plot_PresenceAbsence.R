#' Plot an object of class PresenceAbsence
#' 
#' @author Bruno Vilela
#' 
#' @description Plots species richness map from an object of class PresenceAbsence or an
#' specific species map.
#'
#' @usage 
#' \method{plot}{PresenceAbsence}(x, name=NULL, world=TRUE, \dots)
#' 
#' @param x an object of class PresenceAbsence (see function presab).
#' @param name you can specify a species to be ploted instead of the species richness map.
#' @param world if \code{TURE} a map of political divisions (countries) is added to the plot.
#' @param ... Other plot parameters.
#' 
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#' 
#' @examples \dontrun{
#' data(PAM)
#' require(maps)
#' plot(PAM)
#' plot(PAM, name="Phyllomedusa atelopoides")
#' plot(PAM, name="Phyllomedusa azurea")
#' }
#' 
#' @export

plot.PresenceAbsence <- function(x, name=NULL, world=TRUE, ...){
  if(is.null(name)){
  colfunc <- colorRampPalette(c("green", "yellow", "red"))
  v <- values(x$Rich)
  c <- max(v)
  v[(v==0)] <- NA
  values(x$Rich) <- v
  plot(x$Rich, col=colfunc(c), ...)  
  }
  if(!is.null(name)){
    pos <- which(x$Sp==name)
    
    r <- rasterize(x$Presen[ ,1:2], x$Rich,  x$Presen[ ,(pos+2)])  
    plot(r, col=c("white", "red"), legend=F, ...)
  }
  if(world==T){
    map(add=T)
  }
}

