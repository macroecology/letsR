\name{lets.iucn}
\alias{lets.iucn}
\title{Download species information from IUCN}
\usage{
lets.iucn(input, count=FALSE)
}
\arguments{
  \item{input}{Character vector with one or more species
  names, or an object of the PresenceAbsence class.}

  \item{count}{Logical, if TRUE a counting window will be
  open.}
}
\value{
Return a data frame with the species name, Family, Status,
Criteria used to estabilish that status (when the species
is threatened), population status, the year of description
and the countries where it occurs. NE = Not evaluated
}
\description{
Get species information from IUCN website for one or more
species.
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
lets.iucn.ha
}

