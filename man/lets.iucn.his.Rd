\name{lets.iucn.his}
\alias{lets.iucn.his}
\title{Download historical conservation status of species from IUCN}
\usage{
lets.iucn.his(input, count=FALSE)
}
\arguments{
  \item{input}{character vector with one or more species
  names, or an object of class PresenceAbsence.}

  \item{count}{Logical, if TRUE a counting window will
  open.}
}
\value{
A data frame with the species names in the first column
rows and the years (1980 - present) in the remaining
columns, the code represents the species' conservation
status (see the IUCN website for details). If species do
not have information (i.e. have not been evaluated), the
result is: NE (Not evaluated).
}
\description{
Get species conservation status through history (i.e. from
1980 to present date available) from the IUCN website for
one or more species.
}
\details{
Note that you must be connected to the internet to use this
function.
}
\author{
Bruno Vilela
}
\seealso{
lets.iucn

lets.iucn.ha
}

