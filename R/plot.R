#' Plot for an object of class PresenceAbsence
#' 
#' @author Bruno Vilela
#' 
#' @description Plot species richness map from an object of class PresenceAbsence or an
#' specific species map.
#'
#' @usage plot(x, name=NULL, world=T)
#' @param x an object of class PresenceAbsence (see function presab).
#' @param name you can specify a species to be ploted instead of the richness map.
#' @param world if True a shapefile of countries is added to the plot.
#' 
#' @seealso presab
#' 
#' @export

plot.PresenceAbsence <- function(x, name=NULL, world=T){
  if(is.null(name)){
  colfunc <- colorRampPalette(c("white", "green", "yellow", "red"))
  v <- values(x$Rich)
  v[(v==0)] <- NA
  values(x$Rich) <- v
  plot(x$Rich, col=colfunc((length(x$S)+1)))  
  }
  if(!is.null(name)){
    pos <- which(x$Sp==name)
    
    r <- rasterize(x$Presen[ ,1:2], x$Rich,  x$Presen[ ,(pos+2)])  
    plot(r, col=c("white", "red"))
  }
  if(world==T){
  map(add=T)
  }
}

