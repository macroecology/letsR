\name{lets.iucn}
\alias{lets.iucn}
\title{Download species' information from IUCN}
\usage{
lets.iucn(input, count=FALSE)
}
\arguments{
  \item{input}{Character vector with one or more species
  names, or an object of class PresenceAbsence.}

  \item{count}{Logical, if TRUE a counting window will
  open.}
}
\value{
Returns a data frame with the Species name, Family, Status,
Criteria used to estabilish the conservation status,
Population Status, Year of Description, and the Countries
where it occurs. NE = Not evaluated
}
\description{
Get species' information from the IUCN website for one or
more species.
}
\details{
Note that you must be connected to the internet to use this
function.
}
\author{
Bruno Vilela
}
\seealso{
lets.iucn.ha
}

