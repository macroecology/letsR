\name{lets.iucncont}
\alias{lets.iucncont}
\title{Transform IUCN conservation status to continuous values}
\usage{
lets.iucncont(x, dd=NA, ne=NA)
}
\arguments{
  \item{x}{A vector or a matrix containing IUCN codes to be
  transformed.}

  \item{dd}{The value to be attributed to DD
  (data-deficient) species, the default option is NA.}

  \item{ne}{The value to be attributed to NE
  (not-evaluated) species, the default option is NA.}
}
\value{
Returns a vector/matrix with continuos values from 0 to 5.
}
\description{
Transform IUCN conservation status to continuous values
from 0 to 5.
}
\details{
EX and EW = 5

EN = 4

CR = 3

VU = 2

NT = 1

LC = 0

DD = NA

NE = NA
}
\author{
Bruno Vilela
}
\seealso{
lets.iucn
}

