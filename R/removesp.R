# Function to remove species with values of zero (i.e. species not present in the grid) in PresenceAbscence object
# Bruno Vilela

.removeSp <- function(x){
  if(nrow(as.matrix(x))==1){
    nomes <- colnames(x)
    x <- as.vector(x)
    names(x) <- nomes  
  }
  if(is.vector(x)){    
  x <- x[!x==0]
  nomes <- names(x)
  x <- matrix(x, ncol=length(x))
  colnames(x) <- nomes
  }else{
  rem <- which(colSums(x[,-(1:2)])==0)+2
  if(length(rem)>0){
    x <- x[, -rem]
  }
  }
  return(x)
}
