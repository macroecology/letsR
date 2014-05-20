\name{lets.iucn}
\alias{lets.iucn}
\title{Download species' information from IUCN}
\usage{
lets.iucn(input, count=FALSE)
}
\arguments{
  \item{input}{Character vector with one or more species
  names, or an object of class PresenceAbsence.}

  \item{count}{Logical, if \code{TRUE} a counting window
  will open.}
}
\value{
Returns a data frame with the Species name, Family, Status,
Criteria used to estabilish the conservation status,
Population Status, Year of Description, and the Countries
where it occurs. If species do not have information (i.e.
have not been evaluated), the result is: NE (Not
evaluated).
}
\description{
Get species' information from the IUCN
website(\url{http://www.iucnredlist.org/}) for one or more
species.
}
\details{
Note that you must be connected to the internet to use this
function.
}
\examples{
\dontrun{
# Single species
lets.iucn("Pongo pygmaeus")

# Multiple species
lets.iucn(c("Musonycteris harrisoni", "Ailuropoda melanoleuca", "Cebus flavius"))
}
}
\author{
Bruno Vilela
}
\seealso{
\code{\link{lets.iucn.ha}}

\code{\link{lets.iucn.his}}
}

