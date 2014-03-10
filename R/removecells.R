# Function to remove cells with only zero values from PresenceAbscence matrix
# Bruno Vilela

.removeCells <- function(x){
  rem <- which(rowSums(as.matrix(x[, -c(1, 2)]))==0)
  if(length(rem)>0){
    x <- x[-rem, ]
  }
  if(is.vector(x)){
    nomes <- names(x)
    x <- matrix(x, ncol=length(x))
    colnames(x) <- nomes          
  }
  return(x)
}
