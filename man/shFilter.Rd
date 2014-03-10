\name{shFilter}
\alias{shFilter}
\title{Shapefiles filtering}
\usage{
shFilter(shapes, presence=NULL, origin=NULL, seasonal=NULL)
}
\arguments{
  \item{shapes}{SpatialPolygonsDataFrame (see function
  readShapePoly to open this files) class object. Species
  name should be in a subclass called BINOMIAL or
  binomial.}

  \item{presence}{A vector with the code numbers of
  presence type to be matained.}

  \item{origin}{A vector with the code numbers of origin
  type to be matained.}

  \item{seasonal}{A vector with the code numbers of
  seasonal type to be matained.}
}
\value{
The result is the shapefile filtered. If the filters remove
all polygons, the result will be NULL.
}
\description{
Filter species shapefiles by origin and presence type
(following IUCN types).
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

More info see metadata file of the shapefiles.
}
\author{
Bruno Vilela
}
\seealso{
plot.PresenceAbsence

presab
}

