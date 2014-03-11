\name{lets.addpoly}
\alias{lets.addpoly}
\title{Add polygon values to a PresenceAbscence object}
\usage{
lets.addpoly(x, y, onlyvar=F)
}
\arguments{
  \item{x}{An PresenceAbsence object.}

  \item{y}{Polygon information to be added.}

  \item{z}{Name of the information inside the polygon.}

  \item{onlyvar}{If True only the variable matrix will be
  returned.}
}
\value{
The result is a matrix of species presence/absence with the
polygon information columns added at the end. The Values
repesent the porcentage of the cell covered by the polygon.
}
\description{
Add polygon information to a PresenceAbsence object.
}
\author{
Bruno Vilela
}
\seealso{
lets.presab.birds

lets.presab

lets.addvar
}

