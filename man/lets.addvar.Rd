\name{lets.addvar}
\alias{lets.addvar}
\title{Add variables to a PresenceAbscence object}
\usage{
lets.addvar(x, y, onlyvar=F, fun=mean)
}
\arguments{
  \item{x}{A PresenceAbsence object.}

  \item{y}{Variables to be added in Raster or RasterStack
  format.}

  \item{onlyvar}{If True only the matrix object will be
  returned.}

  \item{fun}{function used to aggregate values}
}
\value{
The result is a presence-absence matrix of species with the
variables added as columns at the right-end of the matrix.
}
\description{
Add variables (in raster format) to a PresenceAbsence
object.
}
\author{
Bruno Vilela
}
\seealso{
lets.presab.birds

lets.presab

lets.addpoly
}

