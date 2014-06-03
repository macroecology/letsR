\name{lets.overlap}
\alias{lets.overlap}
\title{Geographic range overlap}
\usage{
lets.overlap(pam, method="Chesser&Zink", xy=TRUE)
}
\arguments{
  \item{pam}{A presence-absence matrix (sites in rows and
  species in columns, with the first two columns being
  longitude and latitude coordinates, respectively), or an
  object of class PresenceAbsence.}

  \item{method}{The method used to calculate the overlap
  matrix. "Chesser&Zink" calculates the degree of overlap
  as the proportion of the smaller range that overlaps
  within the larger range (Chesser & Zink 1994).
  "Proportional" calculates the proportion of a range that
  overlaps another range, the resultant matrix is not
  symmetric. "Cells" will show the number of overlapping
  grid cells between a pair of ranges (same for both
  species in a pair), the resultant matrix is symmetric.}

  \item{xy}{Logical, if \code{TRUE} the matrix has two
  columns of coordinates.}
}
\description{
Creates geographic range overlap matrix from a species
Presence-absence matrix.
}
\examples{
\dontrun{
data(PAM)
CZ <- lets.overlap(PAM, method="Chesser&Zink", xy=TRUE)
prop <- lets.overlap(PAM, method="Proportional", xy=TRUE)
cells <- lets.overlap(PAM, method="Cells", xy=TRUE)
}
}
\author{
Fabricio Villalobos & Bruno Vilela
}
\references{
Chesser, R. Terry, and Robert M. Zink. "Modes of speciation
in birds: a test of Lynch's method." Evolution (1994):
490-497.

Barraclough, Timothy G., and Alfried P. Vogler. "Detecting
the geographical pattern of speciation from species-level
phylogenies." The American Naturalist 155.4 (2000):
419-434.
}
\seealso{
\code{\link{lets.presab}}

\code{\link{lets.presab.birds}}
}

