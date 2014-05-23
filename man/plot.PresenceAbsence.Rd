\name{plot.PresenceAbsence}
\alias{plot.PresenceAbsence}
\title{Plot an object of class PresenceAbsence}
\usage{
\method{plot}{PresenceAbsence}(x, name=NULL, world=TRUE, \dots)
}
\arguments{
  \item{x}{an object of class PresenceAbsence (see function
  presab).}

  \item{name}{you can specify a species to be ploted
  instead of the species richness map.}

  \item{world}{if \code{TURE} a map of political divisions
  (countries) is added to the plot.}

  \item{...}{Other plot parameters.}
}
\description{
Plots species richness map from an object of class
PresenceAbsence or an specific species map.
}
\examples{
\dontrun{
data(PAM)
require(maps)
plot(PAM)
plot(PAM, name="Phyllomedusa atelopoides")
plot(PAM, name="Phyllomedusa azurea")
}
}
\author{
Bruno Vilela
}
\seealso{
\code{\link{lets.presab}}

\code{\link{lets.presab.birds}}
}

