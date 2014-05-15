#' Create variables based on species geographical ranges
#' 
#' @author Bruno Vilela
#' 
#' @description Create species' attributes based on the attribute values of species co-occurring within their ranges.
#'
#' @usage lets.field(x, y, z, weigth=TRUE, count=FALSE)
#' 
#' @param x A PresenceAbsence object.
#' @param y Species attribute to be considered. It must be a numeric attribute.
#' @param z Species names in the same order as the attributes.
#' @param weigth If \code{TRUE} the value is weighted by species' range size, 
#' if \code{FALSE} the value is the mean of all species that cooccur with the
#'  species target.
#' @param count Logical, if \code{TRUE} a counting window will open.
#'  
#'  @details If the species do not co-occur with any other species NaN will be returned. 
#' 
#' @seealso \code{\link{lets.presab.birds}}
#' @seealso \code{\link{lets.presab}}
#' 
#' @examples \dontrun{
#' data(PAM)
#' range <- colSums(PAM$P)[-(1:2)]
#' field <- lets.field(PAM, range, PAM$S, weigth=TRUE)
#' }
#' 
#' @export


lets.field <- function(x, y, z, weigth=TRUE, count=FALSE){
  
 if(is.factor(y)){
  y <- as.numeric(levels(y))[y]
 }

 p <- x$P[, -(1:2)]
 p2 <- p


 for(i in 1:ncol(p2)){
  pos <- which(z==x$S[i])
  if(length(pos)>0){
    p2[, i] <- p2[, i]*y[pos]
    pos2 <- which(p2[, i]==0)
    p2[pos2, i] <- NA
  }else{
    p2[, i] <- NA
  }  
 }

 media <- numeric(ncol(p))
 n <- length(media)
 
 
 if(count == TRUE){
 x11(2, 2, pointsize = 12)
 par(mar=c(0, 0, 0, 0)) 
 
 for(i in 1:n){
   
   plot.new()
   text(0.5, 0.5, paste(paste("Total:", n, "\n","Runs to go: ", (n-i))))
   
  pos3 <- p[, i]==1
  p3 <- p[pos3, -i]
  p4 <- p2[pos3, -i]
  mult <- p3*p4
  if(weigth==T){
   media[i] <- mean(mult, na.rm=T)
  }
  if(weigth==F){
  mult <- matrix(mult, ncol=(ncol(p)-1)) 
  me <- colMeans(mult, na.rm=T)
  media[i] <- mean(me, na.rm=T)
  }
 }
 dev.off()
 }
 
 if(count == FALSE){
   for(i in 1:n){
          
     pos3 <- p[, i]==1
     p3 <- p[pos3, -i]
     p4 <- p2[pos3, -i]
     mult <- p3*p4
     if(weigth==T){
       media[i] <- mean(mult, na.rm=T)
     }
     if(weigth==F){
       mult <- matrix(mult, ncol=(ncol(p)-1)) 
       me <- colMeans(mult, na.rm=T)
       media[i] <- mean(me, na.rm=T)
     }
   }
 }
 
 resultado <- cbind(x$S, media)
 colnames(resultado) <- c("Species", "Value")
 resultado <- as.data.frame(resultado)
 resultado[, 2] <- as.numeric(levels(resultado[, 2]))[resultado[, 2]]
 return(resultado)
}