\name{lets.field}
\alias{lets.field}
\title{Create variables based on species geographical ranges}
\usage{
lets.field(x, y, z, weigth=TRUE)
}
\arguments{
  \item{x}{A PresenceAbsence object.}

  \item{y}{Species attribute to be considered. It must be a
  continuous attribute}

  \item{z}{Species names in the same order as the
  attributes.}

  \item{weigth}{If TRUE the value is weighted by species'
  range size (i.e. ), if FALSE the value is the mean of all
  species that cooccur with the species target.}
}
\value{
Return a matrix with species x values.
}
\description{
Create species' attributes based on the attribute values of
species co-occurring within their ranges.
}
\author{
Bruno Vilela
}
\seealso{
lets.presab
}

