\name{lets.shFilter}
\alias{lets.shFilter}
\title{Shapefiles filtering}
\usage{
lets.shFilter(shapes, presence=NULL, origin=NULL, seasonal=NULL)
}
\arguments{
  \item{shapes}{Object of class SpatialPolygonsDataFrame
  (see function readShapePoly to open this files).}

  \item{presence}{A vector with the code numbers for the
  presence type to be maintained.}

  \item{origin}{A vector with the code numbers for the
  origin type to be maintained.}

  \item{seasonal}{A vector with the code numbers for the
  seasonal type to be maintained.}
}
\value{
The result is the shapefile(s) filtered according to the
selected types. If the filters remove all polygons, the
result will be NULL.
}
\description{
Filter species shapefiles by origin, presence and seasonal
type (following IUCN types:
\url{http://www.iucnredlist.org/technical-documents/spatial-data},
see metadata)).
}
\details{
Presence codes: (1) Extant, (2) Probably Extant, (3)
Possibly Extant, (4) Possibly Extinct, (5) Extinct (post
1500) & (6) Presence Uncertain.

Origin codes: (1) Native, (2) Reintroduced, (3) Introduced,
(4) Vagrant & (5) Origin Uncertain.

Seasonal codes: (1) Resident, (2) Breeding Season, (3)
Non-breeding Season, (4) Passage & (5) Seasonal Occurrence
Uncertain.

More info in the shapefiles' metadata.
}
\author{
Bruno Vilela
}
\seealso{
\code{\link{plot.PresenceAbsence}}

\code{\link{lets.presab}}

\code{\link{lets.presab.birds}}
}

