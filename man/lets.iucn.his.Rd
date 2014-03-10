\name{lets.iucn.his}
\alias{lets.iucn.his}
\title{Download habitat information from IUCN}
\usage{
lets.iucn.his(input)
}
\arguments{
  \item{input}{character vector with one or more species
  names, or an object of the PresenceAbsence class.}
}
\value{
A data frame with the species names in the rows and the
years (1980 - 2014) in the columns, the code represents the
conservation status of the species (see IUCN website for
details). NE = Not evaluated.
}
\description{
Get species conservation status history information from
IUCN website for one or more species.
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

lets.iucn.ha
}

