\name{lets.presab}
\alias{lets.presab}
\title{Shapefiles into a presence-absence matrix}
\usage{
lets.presab(shapes, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1,
remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
origin=NULL, seasonal=NULL, count=FALSE)
}
\arguments{
  \item{shapes}{Object of class SpatialPolygonsDataFrame
  (see function readShapePoly to open these files). Species
  name should be in a column (within the .DBF table of the
  shapefile) called BINOMIAL or binomial.}

  \item{xmx}{Maximun longitude used to construct the grid
  in which the matrix will be based (i.e. the [gridded]
  geographic domain of interest)}

  \item{xmn}{Minimun longitude used to construct the grid
  in which the matrix will be based (i.e. the [gridded]
  geographic domain of interest)}

  \item{ymx}{Maximun latitude used to construct the grid in
  which the matrix will be based (i.e. the [gridded]
  geographic domain of interest)}

  \item{ymn}{Minimun latitude used to construct the grid in
  which the matrix will be based (i.e. the [gridded]
  geographic domain of interest)}

  \item{remove.cells}{If true, the final matrix will not
  contain cells in the grid with a value of zero (i.e.
  sites with no species present).}

  \item{remove.sp}{If true, the final matrix will not
  contain species that do not match any cell in the grid.}

  \item{show.matrix}{if true, only the presence-absence
  matrix will be shown.}

  \item{crs}{the projection of the shapefiles.}

  \item{cover}{Porcentage of the cell covered by the
  shapefile that will be considered for presence (values
  between 0 and 1).}

  \item{count}{Logical, if TRUE a counting window will
  open.}
}
\value{
The result is an object of class PresenceAbsence with the
following objects:

Presence-Absence Matrix: A matrix of species' presence(1)
and absence(0) information. The first two columns contain
the longitude (x) and latitude (y) of the cells' centroid
(from the gridded domain used);

Richness Raster: A raster containing species richness data;

Species name: A vector with species' names contained in the
matrix.

*But see the option argument show.matrix.
}
\description{
Convert species shapefiles into a presence-absence matrix.
}
\details{
The function creates the presence-absence matrix based on a
raster file. Depending on the cell size, extension used and
number of species it may require a lot of memory, and may
take some time to process it. Thus, during the process, a
counting window will open so you can see the progress (i.e.
in what polygon the function is working). Note that the
number of polygons is not the same as the number of species
that you have (i.e. a species may have more than one
polygon/shapefiles). Before running the function, please
check if the arguments are in the way you want.
}
\author{
Bruno Vilela & Fabricio Villalobos
}
\seealso{
plot.PresenceAbsence

lets.presab.birds

lets.shFilter
}

