#' Compute correlogram based on Moran's I index
#' 
#' @author Bruno Vilela, Fabricio Villalobos, Lucas Jardim & Jose Alexandre Diniz-Filho
#' 
#' @description Compute Moran's correlogram of a variable using a distance matrix.
#'
#' @usage lets.correl(x, y, z, equidistant=FALSE, plot=TRUE)
#' 
#' @param x A single variable in vector format or multiple variables in matrix format (as columns). 
#' @param y A distance matrix of class \code{matrix}.
#' @param z The number of distance classes to use in the correlogram.
#' @param equidistant Logical, if \code{TRUE} the classes will be equidistant. If \code{FALSE} the classes will have equal number of observations.
#' @param plot Logical, if \code{TRUE} the correlogram will be ploted. 
#' 
#' @return Returns a matrix with the Moran's I Observed value, Standard Deviation and Expected value. Also the p value of the null model, the mean distance between classes and the number of observations.   
#' 
#' 
#' @examples \dontrun{
#' var <- runif(100)  # random variable
#' 
#' # Correlated distance matrix
#' distan <- matrix(runif(1000), ncol=100, nrow=100)
#' diag(distan) <- 0
#' ind <- lower.tri(distan)
#' distan[ind] <- t(distan)[ind]
#' distan[lower.tri(distan)] <- distan[upper.tri(distan)]   
#' distan2 <- as.matrix(dist(var))
#' distan <- (distan)*(distan2)
#' 
#' moran <- lets.correl(var, distan, 10, equidistant=FALSE, plot=TRUE)
#' }
#' 
#' @export


lets.correl <- function(x, y, z, equidistant=FALSE, plot=TRUE){
  
  if(is.vector(x)){
    return(.br.correlogram(x, y, z, equidistant, plot))
  }
  
  if(!is.vector(x)){     
    n <- ncol(x)
    parcial <- list()
    
    for(i in 1:n){
      parcial[[i]] <- .br.correlogram(x[, i], y, z, equidistant, plot=FALSE)[, c(1, 3, 5, 6)]
    }
    media <- apply(simplify2array(parcial), 1:2, mean)
    desvio <- apply(simplify2array(parcial), 1:2, sd) 
    resu <- cbind(media[, 1], desvio[, 1], media[, 2], media[, 3], media[, 4] )
    colnames(resu) <- c("Observed", "Standard_Deviation", "Expected_value", "Mean_Distance", "Count")
    
    pos3 <- which(!is.na(media[, 1]))

    if(plot==TRUE){
    
      plot(x=resu[pos3, 4], y=resu[pos3, 1], bty="l", 
         ylab= "Moran's I", xlab= "Distance", type="l",
         lty=3, ylim=c(-1.5, 1.5))
    abline(h=mean(resu[pos3, 3]))
    points(x=resu[pos3, 4], y=resu[pos3, 1], pch=20, cex=1.5)
    
    epsilon = max(resu[pos3, 4])/(14*z)
      up <- resu[pos3, 1] + resu[pos3, 2]
      low <- resu[pos3, 1] - resu[pos3, 2]
      segments(resu[pos3, 4], low , resu[pos3, 4], up)
      segments(resu[pos3, 4]-epsilon, up , resu[pos3, 4]+epsilon, up)
      segments(resu[pos3, 4]-epsilon, low , resu[pos3, 4]+epsilon, low)

    }
    return(resu)
  }
}





############
.br.correlogram <- function(x, y, z, equidistant=FALSE, plot=TRUE){
  
  y3 <- y
  diag(y3) <- NA
  y2 <- y
  z2 <- 1/z
    
  if(equidistant==FALSE){
  quant <- quantile(y3, probs=seq(0, 1, z2), na.rm = TRUE)
  }

  if(equidistant==TRUE){
  quant <- seq(min(y), max(y), ((max(y)-min(y))/z)) 
  }
  
 quant <- as.vector(quant)  
 n <- length(quant)
 ob <- rep(NA, (n-1))  
 sd1 <- rep(NA, (n-1))  
 ex <- rep(NA, (n-1))
 dist_cl <- rep(NA, (n-1))
 p <- rep(NA, (n-1))
 count <- rep(NA, (n-1))
 
 for(i in 1:(n-1)){
   if(i>1){
   pos <- (y>quant[i] & y<=quant[i+1])
   count[i] <- sum(pos)
   }
   if(i==1){
     pos <- (y>=quant[i] & y<=quant[i+1])
     count[i] <- sum(pos)     
   }
   
   dist_cl [i] <- mean(c(quant[i], quant[i+1]))
   
  if(count[i]>0){
    

    y2[pos] <- 1
    y2[!pos] <- 0    
    m <- .br.moran(y2, x)
    ob[i] <- m$observed
    sd1[i] <- m$sd
    ex[i] <- m$expected
    dist_cl [i] <- mean(c(quant[i], quant[i+1]))
    p[i] <- m$p.value
 }
  }
 
 resu <- cbind(ob, sd1, ex, p, dist_cl, count)
 colnames(resu) <- c("Observed", "Standard_Deviation", "Expected_value", "p_value", "Mean_Distance", "Count")

 if(plot==TRUE){
   
   pos3 <- which(!is.na(resu[, 1]))
   plot(x=dist_cl[pos3],y=ob[pos3], bty="l", 
     ylab= "Moran's I", xlab= "Distance", type="l",
     lty=3, ylim=c(-1.5, 1.5))
 abline(h=mean(ex[pos3]))
 points(x=dist_cl[pos3], y=ob[pos3], pch=20, cex=1.5)
 
 epsilon = max(dist_cl[pos3])/(14*z)
 for(i in 1:nrow(resu)) {
   up <- resu[pos3, 1] + resu[pos3, 2]
   low <- resu[pos3, 1] - resu[pos3, 2]
   segments(resu[pos3, 5], low , resu[pos3, 5], up)
   segments(resu[pos3, 5]-epsilon, up , resu[pos3, 5]+epsilon, up)
   segments(resu[pos3, 5]-epsilon, low , resu[pos3, 5]+epsilon, low)
 }
 
 }
 
 return(resu)
}


############

.br.moran <- function(w, y){
  n <- sum(ifelse(rowSums(w)>0, 1, 0))
  z <- y-mean(y)
  soma <- n*(sum(w*(z%o%z)))
  divi <- sum(w) * sum((z^2))
  ob <- soma/divi
  es <- -1/(n-1)    
  S1 <-  0.5 * sum((w + t(w))^2)
  S2 <- sum((apply(w, 1, sum) + apply(w, 2, sum))^2)
  k <- n*sum(z^4)/((sum(z^2))^2)
  s.sq <- sum(w)^2
  sdi <- sqrt((n * ((n^2 - 3 * n + 3) * S1 - n * S2 + 3 * s.sq) 
              - k * (n * (n - 1) * S1 - 2 * n * S2 + 6 * s.sq))/((n - 1) *
              (n - 2) * (n - 3) * s.sq) - 1/((n - 1)^2))
  pv <- pnorm(ob, mean = es, sd = sdi)
  pv <- if (ob <= es) 
    2 * pv
  else 2 * (1 - pv)
  return(list("observed"=ob, "expected"=es, "sd"=sdi, "p.value"= pv))  
}
