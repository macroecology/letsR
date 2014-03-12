\name{lets.field}
\alias{lets.field}
\title{Create variables based on species range field}
\usage{
lets.field(x, y, z, weigth=TRUE)
}
\arguments{
  \item{x}{A PresenceAbsence object.}

  \item{y}{Species atribute to be maped}

  \item{z}{Species names in the same order of the
  atributes.}

  \item{weigth}{If TRUE the value is weighted by species
  range cover, if FASLSE the value is the mean of all
  species that cooccur with the species target.}
}
\value{
Return a matrix with species x values.
}
\description{
Create a variable based on other species values that
cooccur in the geographic range.
}
\author{
Bruno Vilela
}
\seealso{
lets.presab
}

