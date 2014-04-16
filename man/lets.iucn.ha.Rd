\name{lets.iucn.ha}
\alias{lets.iucn.ha}
\title{Download habitat information for species from IUCN}
\usage{
lets.iucn.ha(input, count=FALSE)
}
\arguments{
  \item{input}{character vector with one or more species
  names, or an object of the PresenceAbsence class.}

  \item{count}{Logical, if TRUE a counting window will
  open.}
}
\value{
A data frame with species names in the first column and the
habitats in the remaining columns, '1' if species is
present in that habitat and '0' otherwise.
}
\description{
Get species' habitat information from IUCN website for one
or more species.
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
}

