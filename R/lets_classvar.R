#' Fucntion to count for frequency distribution along a variable
#' 
#' @author Bruno Vilela
#' 
#' @description Based on a Presence-Absence matrix with variables added (see \code{\link{lets.addvar}}), the function divides a continuous variable into classes and count the occurence frequency of each species in each class. 
#' 
#' @usage lets.classvar(x, groups="default", pos, xy)
#' 
#' @param x Presence-absence matrix with a unique variable added.
#' @param pos Column position of the variables.
#' @param groups The number of classes wanted for the variable. Default calculates the number of classes default for a histogram (\code{\link{hist}}). 
#' @param xy Logical, if \code{TRUE} the matrix contains the coordinates in the first two columns.
#' 
#' @return A matrix with species in rows and class in columns.
#' 
#' @examples \dontrun{
#' data(PAM)
#' data(temp)
#' pamvar <- lets.addvar(PAM, temp)
#' head(pamvar)
#' resu <- lets.classvar(x=pamvar, pos=ncol(pamvar), xy=TRUE)
#' }
#'   
#' @export

lets.classvar <- function(x, groups="default", pos, xy){
  
  if(xy==TRUE){
    sps <- x[, -c(1, 2, pos)]
  }else{
    sps <- x[, -pos]
  }
  
  ric <- ncol(sps)
  
  if(groups=="default"){
    freq <- hist(x[, pos], plot=FALSE)$breaks
    groups <- length(freq)-1    
  }else{
    freq <- quantile(x[, pos], seq(0, 1, (1/groups)), na.rm=TRUE)
  }
  
  freqi <- matrix(ncol=groups, nrow=ric)
  
  for(i in 1:ric){
    freqi[i, ] <- hist(x[(sps[, i]==1), pos], breaks=freq, plot=FALSE)$counts
  }
  
  nomes <- numeric(groups)
  freq <- round(freq, 2)
  for(j in 1:groups){
    nomes[j] <- paste(freq[j], ":", freq[j+1], sep="")
  }
  
  rownames(freqi) <- colnames(sps)
  colnames(freqi) <- nomes
  return(freqi)
}