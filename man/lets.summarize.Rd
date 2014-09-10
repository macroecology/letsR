\name{lets.summarize}
\alias{lets.summarize}
\title{Summary cell variables for species}
\usage{
lets.summarize(x, pos, xy=TRUE, fun=mean)
}
\arguments{
  \item{x}{Presence-absence matrix with variables added.}

  \item{pos}{Column position of the variables.}

  \item{xy}{Logical, if \code{TRUE} the matrix contains the
  coordinates in the first two columns.}

  \item{fun}{Function to be used to summary the variable
  per species.}
}
\description{
Based on a Presence-Absence matrix with variables added
(see \code{\link{lets.addvar}}) summarizes the values per
species.
}
\author{
Bruno Vilela & Fabricio Villalobos
}
\seealso{
\code{\link{lets.addvar}}

\code{\link{lets.addpoly}}
}

