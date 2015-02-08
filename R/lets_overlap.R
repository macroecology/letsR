#' Compute pairwise species' geographic overlapsa
#' 
#' @author Fabricio Villalobos & Bruno Vilela
#' 
#' @description Creates a species geographic overlap matrix from a Presence-absence matrix.
#' 
#' @usage lets.overlap(pam, method="Chesser&Zink", xy=TRUE)
#' 
#' @param pam A presence-absence matrix (sites in rows and species in columns, with the first two columns containing the longitudinal and latitudinal coordinates, respectively), or an object of class PresenceAbsence. 
#' @param method The method used to calculate the overlap matrix. "Chesser&Zink" calculates the degree of overlap as the proportion of the smaller range that overlaps within the larger range (Chesser & Zink 1994). "Proportional" calculates the proportion of a range that overlaps another range, the resultant matrix is not symmetric. "Cells" will show the number of overlapping grid cells between a pair of species' ranges (same for both species in a pair), here the resultant matrix is symmetric.
#' @param xy Logical, if \code{TRUE} the input matrix contains geographic coordinates in the first two columns.
#'
#' @references Chesser, R. Terry, and Robert M. Zink. "Modes of speciation in birds: a test of Lynch's method." Evolution (1994): 490-497.
#' @references Barraclough, Timothy G., and Alfried P. Vogler. "Detecting the geographical pattern of speciation from species-level phylogenies." The American Naturalist 155.4 (2000): 419-434.
#' 
#' @seealso \code{\link{lets.presab}}
#' @seealso \code{\link{lets.presab.birds}}
#' 
#' @examples \dontrun{
#' data(PAM)
#' CZ <- lets.overlap(PAM, method="Chesser&Zink", xy=TRUE)
#' prop <- lets.overlap(PAM, method="Proportional", xy=TRUE)
#' cells <- lets.overlap(PAM, method="Cells", xy=TRUE)
#' }
#'    
#' @export


lets.overlap <- function(pam, method="Chesser&Zink", xy=TRUE){
  
  if(class(pam)=="PresenceAbsence"){
    pam <- pam$Pre    
  }
  
  if(!xy){
  pam <- pam[, -(1:2)]  
  }
  nomes <- colnames(pam)
  n <- ncol(pam)
  
  if(method=="Cells"){
  resu <- matrix(NA, ncol=n, nrow=n)
  diag(resu) <- 1  
  for(i in 1:(n-1)){
    for(j in ((i+1):n)){
      over <- sum(rowSums(pam[, c(i,j)])==2)
      resu[i, j] <- over
    }    
  }
  ind <- lower.tri(resu)  
  resu[ind] <- t(resu)[ind]
  colnames(resu) <- nomes
  rownames(resu) <- nomes
  }

  if(method=="Proportional"){
    resu <- matrix(NA, ncol=n, nrow=n)
    range <- colSums(pam)
    
    for(i in 1:n){
      for(j in 1:n){
        over <- sum(rowSums(pam[, c(i,j)])==2)
        over2 <- over/range[i]
        resu[i, j] <- over2
      }    
    }
    colnames(resu) <- nomes
    rownames(resu) <- nomes
  }
  
  if(method=="Chesser&Zink"){
    range <- colSums(pam)
    resu <- matrix(NA, ncol=n, nrow=n)
    diag(resu) <- 1  
    for(i in 1:(n-1)){
      for(j in ((i+1):n)){
        over <- sum(rowSums(pam[, c(i,j)])==2)
        resu[i, j] <- over/min(range[c(i,j)])
      }
    }
    ind <- lower.tri(resu)  
    resu[ind] <- t(resu)[ind]
    colnames(resu) <- nomes
    rownames(resu) <- nomes
  }
  
  return(resu)
}
