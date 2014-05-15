\name{lets.field}
\alias{lets.field}
\title{Create variables based on species geographical ranges}
\usage{
lets.field(x, y, z, weigth=TRUE, count=FALSE)
}
\arguments{
  \item{x}{A PresenceAbsence object.}

  \item{y}{Species attribute to be considered. It must be a
  numeric attribute.}

  \item{z}{Species names in the same order as the
  attributes.}

  \item{weigth}{If \code{TRUE} the value is weighted by
  species' range size, if \code{FALSE} the value is the
  mean of all species that cooccur with the species
  target.}

  \item{count}{Logical, if \code{TRUE} a counting window
  will open.}
}
\description{
Create species' attributes based on the attribute values of
species co-occurring within their ranges.
}
\details{
If the species do not co-occur with any other species NaN
will be returned.
}
\examples{
\dontrun{
data(PAM)
range <- colSums(PAM$P)[-(1:2)]
field <- lets.field(PAM, range, PAM$S, weigth=TRUE)
}
}
\author{
Bruno Vilela
}
\seealso{
\code{\link{lets.presab.birds}}

\code{\link{lets.presab}}
}

