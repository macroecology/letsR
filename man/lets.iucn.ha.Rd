\name{lets.iucn.ha}
\alias{lets.iucn.ha}
\title{Download habitat information from IUCN}
\usage{
lets.iucn.ha(input, count=FALSE)
}
\arguments{
  \item{input}{character vector with one or more species
  names, or an object of the PresenceAbsence class.}

  \item{count}{Logical, if TRUE a counting window will be
  open.}
}
\value{
A data frame with the species names in the rows and the
habitats in the columns, the number 1 indicates the use of
the habitat while the 0 indicates that the species do not
use the habitat.
}
\description{
Get species habitat information from IUCN website for one
or more species.
}
\details{
Depending on your internet conection and the number of
species, the function may take some time. So, we open a
count window where you can follow the progress. Note that
the internet must be turned on during all the process.
}
\author{
Bruno Vilela
}
\seealso{
lets.iucn
}

