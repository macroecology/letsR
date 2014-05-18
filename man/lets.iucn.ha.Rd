\name{lets.iucn.ha}
\alias{lets.iucn.ha}
\title{Download habitat information for species from IUCN}
\usage{
lets.iucn.ha(input, count=FALSE)
}
\arguments{
  \item{input}{Character vector with one or more species
  names, or an object of the PresenceAbsence class.}

  \item{count}{Logical, if \code{TRUE} a counting window
  will open.}
}
\value{
A data frame with species names in the first column and the
habitats in the remaining columns, '1' if species is
present in that habitat and '0' otherwise.
}
\description{
Get species' habitat information from IUCN
website(\url{http//:http://www.iucnedlist.org/}) for one or
more species.
}
\details{
Note that you must be connected to the internet to use this
function.
}
\examples{
\dontrun{
# Single species
lets.iucn.ha("Pongo pygmaeus")

# Multiple species
lets.iucn.ha(c("Musonycteris harrisoni", "Ailuropoda melanoleuca", "Cebus flavius"))
}
}
\author{
Bruno Vilela
}
\seealso{
\code{\link{lets.iucn}}

\code{\link{lets.iucn.his}}
}

