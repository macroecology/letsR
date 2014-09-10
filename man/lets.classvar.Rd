\name{lets.classvar}
\alias{lets.classvar}
\title{Fucntion to count for frequency distribution along a variable}
\usage{
lets.classvar(x, groups="default", pos, xy)
}
\arguments{
  \item{x}{Presence-absence matrix with a unique variable
  added.}

  \item{pos}{Column position of the variables.}

  \item{groups}{The number of classes wanted for the
  variable. Default calculates the number of classes
  default for a histogram (\code{\link{hist}}).}

  \item{xy}{Logical, if \code{TRUE} the matrix contains the
  coordinates in the first two columns.}
}
\value{
A matrix with species in rows and class in columns.
}
\description{
Based on a Presence-Absence matrix with variables added
(see \code{\link{lets.addvar}}), the function divides a
continuous variable into classes and count the occurence
frequency of each species in each class.
}
\examples{
\dontrun{
data(PAM)
data(temp)
pamvar <- lets.addvar(PAM, temp)
head(pamvar)
resu <- lets.classvar(x=pamvar, pos=ncol(pamvar), xy=TRUE)
}
}
\author{
Bruno Vilela
}

