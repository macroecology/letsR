\name{lets.addvar}
\alias{lets.addvar}
\title{Add variables to a PresenceAbscence object}
\usage{
lets.addvar(x, y, onlyvar=F)
}
\arguments{
  \item{x}{An PresenceAbsence object.}

  \item{y}{Variables to be added in Raster or RasterStack
  format.}

  \item{onlyvar}{If True only the variable matrix will be
  returned.}
}
\value{
The result is a matrix of species presence/absence with the
variables columns added at the end.
}
\description{
Add variables in raster format to a PresenceAbsence object.
}
\author{
Bruno Vilela
}
\seealso{
lets.presab.birds

lets.presab

lets.addpoly
}

