\name{lets.correl}
\alias{lets.correl}
\title{Compute correlogram based on Moran's I}
\usage{
lets.correl(x, y, z, equidistant=FALSE, plot=TRUE)
}
\arguments{
  \item{x}{A single variable in vector format or multiple
  variables in matrix format (as columns).}

  \item{y}{A distance matrix of class 'matrix'.}

  \item{z}{The number of distance classes to use in the
  correlogram.}

  \item{equidistant}{Logical, if TRUE the classes will be
  equidistant. If FALSE the classes will have equal number
  of observations.}

  \item{plot}{Logical, if TRUE the correlogram will be
  ploted.}
}
\description{
Compute Moran's correlogram of a variable using a distance
matrix.
}
\author{
Bruno Vilela, Fabricio Villalobos, Lucas Jardim & Jose
Alexandre Diniz-Filho
}

