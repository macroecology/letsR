\name{lets.addpoly}
\alias{lets.addpoly}
\title{Add polygon values to a PresenceAbscence object}
\usage{
lets.addpoly(x, y, onlyvar=F)
}
\arguments{
  \item{x}{A PresenceAbsence object.}

  \item{y}{Polygon values to add.}

  \item{z}{Name of polygon values.}

  \item{onlyvar}{If True only the matrix object will be
  returned.}
}
\value{
The result is a presence-absence matrix of species with the
polygon values added as columns at the right-end of the
matrix . The Values represent the percentage of the cell
covered by the polygon.
}
\description{
Add polygon values to a PresenceAbsence object.
}
\author{
Bruno Vilela
}
\seealso{
lets.presab.birds

lets.presab

lets.addvar
}

