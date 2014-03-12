\name{lets.iucncont}
\alias{lets.iucncont}
\title{Transform IUCN conservation status to continuos values}
\usage{
lets.iucncont(x, dd=NA)
}
\arguments{
  \item{x}{A vector or a matrix containing IUCN codes.}

  \item{dd}{The value to be atributed to DD and NE species,
  the default option is NA.}
}
\value{
Return a vector with continuos values from 0 to 5.
}
\description{
Transform IUCN conservation status to continuos values from
0 to 5.
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

