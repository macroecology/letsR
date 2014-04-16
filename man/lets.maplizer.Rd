\name{lets.maplizer}
\alias{lets.maplizer}
\title{Create a matrix summarizing species' attributes}
\usage{
lets.maplizer(x, y, z, func=mean, ras=FALSE)
}
\arguments{
  \item{x}{A PresenceAbsence object.}

  \item{y}{Species attribute to be considered.}

  \item{z}{Species names in the same order as the
  attributes.}

  \item{func}{function to summarize the atribute.}

  \item{ras}{If True the raster file will be returned
  together with the matrix}
}
\value{
Return a matrix with coordinates and the atributes
summarized.
}
\description{
Summarize species atributes per cell in a presence-absence
matrix.
}
\author{
Bruno Vilela
}
\seealso{
lets.presab
}

