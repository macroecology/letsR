#' Spatial correlogram based on Moran's I
#'
#' @description
#' Computes spatial correlograms using Moran's I to quantify spatial
#' autocorrelation across geographic distance classes. The function
#' accepts a single numeric variable or a matrix containing multiple
#' variables and calculates spatial autocorrelation at different
#' spatial scales.
#'
#' @author Bruno Vilela, Fabricio Villalobos, Lucas Jardim &
#'   Jose Alexandre Diniz-Filho
#'
#' @param x A numeric vector containing the values of a variable
#'   measured at different geographic locations, or a numeric matrix
#'   with variables in columns and locations in rows. The order of
#'   locations must correspond to the distance matrix supplied in `y`.
#'
#' @param y A geographic distance matrix of class `matrix` or `dist`.
#'   Distances must correspond to the locations represented in `x`.
#'   Distances calculated using [lets.distmat()] are expressed in meters
#'   when geographic coordinates are supplied.
#'
#' @param z Integer specifying the number of geographic distance
#'   classes used to construct the correlogram. Distance classes
#'   containing insufficient observations are omitted.
#'
#' @param equidistant Logical. If `TRUE`, distance classes have equal
#'   widths. If `FALSE` (default), classes are defined using quantiles
#'   of pairwise distances, producing approximately equal numbers of
#'   location pairs per class. Repeated distances may result in unequal
#'   class sizes. Currently, this argument is only applied when `x`
#'   is a single variable.
#'
#' @param plot Logical. If `TRUE` (default), plots the spatial
#'   correlogram showing Moran's I across geographic distance classes.
#'
#' @return
#' A numeric matrix containing the results for each geographic
#' distance class.
#'
#' When `x` is a numeric vector, the matrix contains:
#'
#' \describe{
#'   \item{Observed}{Observed Moran's I for each distance class.}
#'   \item{Confidence_Interval_(95\%)}{Half-width of the approximate
#'     95\% interval around the observed Moran's I, calculated as
#'     1.96 times its estimated standard deviation.}
#'   \item{Expected_value}{Expected Moran's I under the null
#'     hypothesis of spatial randomness.}
#'   \item{p_value}{Two-sided p-value calculated using a normal
#'     approximation to the null distribution.}
#'   \item{Mean_Distance}{Midpoint of the distance-class boundaries,
#'     expressed in the same units as `y`.}
#'   \item{Count}{Number of ordered location pairs included in
#'     the distance class.}
#' }
#'
#' When `x` contains multiple variables, the function returns:
#'
#' \describe{
#'   \item{Observed}{Mean observed Moran's I across variables.}
#'   \item{Standard_Deviation}{Standard deviation of Moran's I
#'     across variables.}
#'   \item{Expected_value}{Mean expected Moran's I across variables.}
#'   \item{Mean_Distance}{Mean distance-class midpoint across variables.}
#'   \item{Count}{Mean number of ordered location pairs across variables.}
#' }
#'
#' @details
#' Moran's I measures the degree of spatial autocorrelation in a
#' variable. Positive values indicate that locations separated by
#' a given geographic distance tend to have similar values, whereas
#' negative values indicate spatial dissimilarity. Values close to
#' the expected Moran's I indicate little evidence of spatial
#' autocorrelation at that distance.
#'
#' The geographic distance matrix is divided into `z` distance
#' classes. For each class, a binary spatial weights matrix is
#' constructed, assigning a weight of one to pairs of locations
#' within the corresponding distance interval and zero otherwise.
#' Moran's I is then calculated independently for each class.
#'
#' The expected value is calculated as -1 / (n - 1), where `n`
#' is the number of locations having at least one connection
#' within the distance class. The approximate 95% interval is
#' obtained from the analytical variance of Moran's I under
#' randomization assumptions. P-values are calculated using
#' a normal approximation, without Monte Carlo permutations.
#'
#' When multiple variables are provided, Moran's I is computed
#' separately for each variable and summarized by its mean and
#' standard deviation across variables. This standard deviation
#' describes variation among variables and should not be interpreted
#' as inferential uncertainty around the mean.
#'
#' Spatial correlograms can be used to investigate the spatial
#' structure of ecological and environmental variables, identify
#' characteristic distances of spatial autocorrelation, and compare
#' broad-scale spatial patterns among variables.
#'
#' Results depend on the number and definition of distance classes,
#' the geographic distribution of sampling locations, and the
#' spatial structure of the analyzed variable. Distance classes
#' containing too few connected locations may produce undefined
#' statistics and are excluded from the output.
#'
#' @references
#' Sokal, R. R. & Oden, N. L. (1978). Spatial autocorrelation in
#' biology. 1. Methodology. Biological Journal of the Linnean
#' Society, 10, 199-228.
#'
#' Sokal, R. R. & Oden, N. L. (1978). Spatial autocorrelation in
#' biology. 2. Some biological implications and four applications
#' of evolutionary and ecological interest. Biological Journal
#' of the Linnean Society, 10, 229-249.
#'
#' @seealso [lets.distmat()]
#'
#' @examples
#' # Generate geographic coordinates
#' coords <- as.matrix(expand.grid(
#'   longitude = seq(-50, -46, length.out = 8),
#'   latitude = seq(-18, -14, length.out = 8)
#' ))
#'
#' # Calculate geographic distances in meters
#' dist_mat <- lets.distmat(coords)
#'
#' # Create a spatially structured variable
#' set.seed(123)
#' x <- coords[, 1] + coords[, 2] +
#'   rnorm(nrow(coords), sd = 0.5)
#'
#' # Moran's I correlogram
#' result <- lets.correl(
#'   x,
#'   dist_mat,
#'   z = 6,
#'   equidistant = FALSE,
#'   plot = TRUE
#' )
#'
#' print(result)
#'
#' # Compare multiple variables
#' x2 <- rnorm(nrow(coords))
#' variables <- cbind(
#'   Spatial_gradient = x,
#'   Random_variable = x2
#' )
#'
#' result_multi <- lets.correl(
#'   variables,
#'   dist_mat,
#'   z = 6,
#'   plot = FALSE
#' )
#'
#' print(result_multi)
#'
#' @export





lets.correl <- function(x, y, z, equidistant = FALSE,
                        plot = TRUE) {
  
  # Absent values in x (better error message)
  if (any(is.na(x))) {
    stop("Missing values in x argument")
  }
  
  # Allow dist classes
  if (class(y)[1] == "dist") {
    y <- as.matrix(y)
  }
  
  # Absent values in y (better error message)
  if (any(is.na(y))) {
    stop("Missing values in y argument")
  }
  
  
  # Check if it has one
  if (is.matrix(x)) {
    if (ncol(x) == 1) {
      x <- as.vector(x)
    }
  }
  
  
  if (is.vector(x)) {
    return1 <- .br.correlogram(x, y, z, equidistant, plot)
    # Warning for removing some classes
    if (nrow(return1) < z) {
      warning(paste("Some of the distance classes", 
                    "were removed due to small number",
                    "of occurrences on it"))
    }
    return(return1)
  }
  
  if (!is.vector(x)) {
    n <- ncol(x)
    parcial <- list()
    
    for(i in 1:n) {
      parcial1 <- .br.correlogram(x[, i], y, z, plot = FALSE)
      parcial[[i]] <- parcial1[, c(1, 3, 5, 6)]
    }
    media <- apply(simplify2array(parcial), 1:2, mean)
    desvio <- apply(simplify2array(parcial), 1:2, stats::sd) 
    resu <- cbind(media[, 1], desvio[, 1], media[, 2],
                  media[, 3], media[, 4] )
    colnames(resu) <- c("Observed", "Standard_Deviation",
                        "Expected_value", "Mean_Distance",
                        "Count")
    
    if (plot) {
      .plotcorrel(plot1 = resu[, 4],
                  plot2 = resu[, 1],
                  plot3 = resu[, 2],
                  plot4 = resu[, 3],
                  z)
    }
    
    if (nrow(resu) < z) {
      warning(paste("Some of the distance classes", 
                    "were removed due to few number",
                    "of occurrence on it"))
    }
    
    return(resu)
  }
}





############
.br.correlogram <- function(x, y, z, equidistant = FALSE,
                            plot = TRUE) {
  y3 <- y
  diag(y3) <- NA
  y2 <- y
  z2 <- 1 / z
  
  if (!equidistant) {
    quant <- quantile(y3, probs = seq(0, 1, z2),
                      na.rm = TRUE)
  }
  if (equidistant) {
    quant <- seq(min(y), max(y), ((max(y) - min(y)) / z))
  }
  
  quant <- as.vector(quant)
  n <- length(quant)
  ob <- rep(NA, (n - 1))
  CI <- rep(NA, (n - 1))
  ex <- rep(NA, (n - 1))
  dist_cl <- rep(NA, (n - 1))
  p <- rep(NA, (n - 1))
  count <- rep(NA, (n - 1))
  
  for(i in 1:(n - 1)) {
    if (i > 1) {
      pos <- (y > quant[i] & y <= quant[i + 1])
      diag(pos) <- FALSE
      count[i] <- sum(pos)
    }
    
    if (i == 1) {
      pos <- (y >= quant[i] & y <= quant[i + 1])
      diag(pos) <- FALSE
      count[i] <- sum(pos)
    }
    dist_cl [i] <- mean(c(quant[i], quant[i + 1]))
    
    if (count[i] > 0) {
      y2[pos] <- 1
      y2[!pos] <- 0
      m <- .br.moran(y2, x)
      ob[i] <- m$observed
      CI[i] <- m$ci
      ex[i] <- m$expected
      dist_cl[i] <- mean(c(quant[i], quant[i + 1]))
      p[i] <- m$p.value
    }
  }
  
  if (all(is.na(ob))) {
    stop(paste("None of the distance classes sets",
               "has enough sample size to calculate",
               "Moran's I. Set less classes or increase",
               "the sample size"))
    
  }
  
  resu <- cbind(ob, CI, ex, p, dist_cl, count)
  colnames(resu) <- c("Observed", "Confidence_Interval_(95%)",
                      "Expected_value", "p_value",
                      "Mean_Distance", "Count")
  resu <- resu[!is.na(resu[, 1]), , drop = FALSE]
  
  if (plot) { 
    
    .plotcorrel(plot1 = resu[, 5],
                plot2 = resu[, 1],
                plot3 = resu[, 2],
                plot4 = resu[, 3],
                z)
  }
  
  return(resu)
}


############

.br.moran <- function(w, y) {
  
  n <- sum(ifelse(rowSums(w) > 0, 1, 0))
  
  if (n > 3) {
    z <- y - mean(y)
    soma <- n * (sum(w * (z %o% z)))
    divi <- sum(w) * sum((z ^ 2))
    ob <- soma / divi
    es <- -1 / (n - 1)
    S1 <-  0.5 * sum((w + t(w)) ^ 2)
    S2 <- sum((apply(w, 1, sum) + apply(w, 2, sum)) ^ 2)
    k <- n * sum(z ^ 4) / ((sum(z ^ 2)) ^ 2)
    s.sq <- sum(w) ^ 2
    calc1 <- (n ^ 2 - 3 * n + 3) * S1 - n * S2 + 3 * s.sq
    calc2 <- n * (n - 1) * S1 - 2 * n * S2 + 6 * s.sq
    calc3 <- (n - 1) * (n - 2) * (n - 3) * s.sq
    sdi0 <- (n * calc1 - k * calc2) / calc3 - 1/((n - 1) ^ 2)
    if (sdi0 < 0) {
      sdi0 <- 0
    }
    sdi <- sqrt(sdi0)
    ci <- sdi * 1.96
    pv <- stats::pnorm(ob, mean = es, sd = sdi)
    if (ob <= es) {
      pv <- 2 * pv
    } else {
      pv <- 2 * (1 - pv)
    }
  } else {
    ob <- NA
    es <- NA
    ci <- NA
    pv <- NA
  } 
  return(list("observed" = ob, "expected" = es, "ci" = ci,
              "p.value" = pv))
}


### Plot

.plotcorrel <- function(plot1, plot2, plot3, plot4, z) {
  epsilon <- max(plot1) / (14 * z)
  up <- plot2 + plot3
  low <- plot2 - plot3  
  plot(x = plot1, y = plot2, bty = "l", 
       ylab = "Moran's I", xlab = "Distance",
       type = "l", lty = 3, 
       ylim = c(min(low) - 0.2, max(up) + 0.2))
  graphics::abline(h = mean(plot4))
  graphics::points(x = plot1, y = plot2,
         pch = 20, cex = 1.5)
  graphics::segments(plot1, low,
           plot1, up)
  graphics::segments(plot1 - epsilon, up,
           plot1 + epsilon, up)
  segments(plot1 - epsilon, low,
           plot1 + epsilon, low)
  invisible(NULL)
}