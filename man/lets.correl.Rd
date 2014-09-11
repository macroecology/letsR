\name{lets.correl}
\alias{lets.correl}
\title{Compute correlogram based on Moran's I}
\usage{
lets.correl(x, y, z, equidistant=FALSE, plot=TRUE)
}
\arguments{
  \item{x}{A single variable in vector format or multiple
  variables in matrix format (as columns).}

  \item{y}{A distance matrix of class \code{matrix}.}

  \item{z}{The number of distance classes to use in the
  correlogram.}

  \item{equidistant}{Logical, if \code{TRUE} the classes
  will be equidistant. If \code{FALSE} the classes will
  have equal number of observations.}

  \item{plot}{Logical, if \code{TRUE} the correlogram will
  be ploted.}
}
\value{
Returns a matrix with the Moran's I Observed value,
Standard Deviation and Expected value. Also the p value of
the null model, the mean distance between classes and the
number of observations.
}
\description{
Compute Moran's correlogram of a variable using a distance
matrix.
}
\examples{
\dontrun{
var <- runif(100)  # random variable

# Correlated distance matrix
distan <- matrix(runif(1000), ncol=100, nrow=100)
diag(distan) <- 0
ind <- lower.tri(distan)
distan[ind] <- t(distan)[ind]
distan[lower.tri(distan)] <- distan[upper.tri(distan)]
distan2 <- as.matrix(dist(var))
distan <- (distan)*(distan2)

moran <- lets.correl(var, distan, 10, equidistant=FALSE, plot=TRUE)
}
}
\author{
Bruno Vilela, Fabricio Villalobos, Lucas Jardim & Jose
Alexandre Diniz-Filho
}

