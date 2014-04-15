\name{lets.correl}
\alias{lets.correl}
\title{Compute correlogram based on Moran's I}
\usage{
lets.correl(x, y, z, equidistant=FALSE, plot=TRUE)
}
\arguments{
  \item{x}{A single variable in a vector, or multiple
  variables in a matrix.}

  \item{y}{A distance matrix.}

  \item{z}{The number of distance classes in the
  correlogram.}

  \item{equidistant}{Logical, if TRUE the classes will be
  equidistant. If FALSE the classes will be contruct to
  have equal number of pairs.}

  \item{plot}{Logical, if TRUE the correlogram will be
  ploted.}
}
\description{
Compute correlogram for a variable from a distance matrix.
}
\author{
Bruno Vilela, Fabricio Villalobos, Lucas Jardim & Jose
Alexandre Diniz-Filho
}

