\name{lets.presab.birds}
\alias{lets.presab.birds}
\title{Shapefiles to presence/absence matrix by folder location}
\usage{
lets.presab.birds(path, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1,
remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
origin=NULL, seasonal=NULL, count=FALSE)
}
\arguments{
  \item{path}{Path location of folders with one or more
  species' shapefiles.}

  \item{xmx}{Maximun longitude used to construct the grid
  in which the matrix will be based (i.e. the geographic
  domain of interest).}

  \item{xmn}{Minimun longitude used to construct the grid
  in which the matrix will be based (i.e. the geographic
  domain of interest).}

  \item{ymx}{Maximun latitude used to construct the grid in
  which the matrix will be based (i.e. the geographic
  domain of interest).}

  \item{ymn}{Minimun latitude used to construct the grid in
  which the matrix will be based (i.e. the geographic
  domain of interest).}

  \item{remove.cells}{If true, the final matrix will not
  contain cells in the grid that have value of zero (i.e.
  no species present in that cell).}

  \item{remove.sp}{If true, the final matrix will not
  contain species that do not match any cell in the grid
  (i.e. species not distributed in the domain).}

  \item{show.matrix}{if true, only the presence-absence
  matrix will be shown.}

  \item{crs}{the projection of the shapefiles.}

  \item{cover}{Percentage of the cell covered by the
  shapefile that will be considered for presence (values
  between 0 and 1).}

  \item{count}{Logical, if TRUE a counting window will
  open.}
}
\value{
The result is an object of class PresenceAbsence with the
following objects:

Presence-Absence Matrix: A matrix of species' presence(1)
and absence(0). The first two columns contain the longitude
(x) and latitude (y) of the cells' centroid and the
remainin columns the incidence values (1,0);

Richness Raster: A raster containing species richness data
within the gridded domain;

Species name: A vector of species' names contained in the
presence-absence matrix.

*But see the option argument show.matrix.
}
\description{
Convert species' shapefiles into a presence-absence matrix.
This function is specially designed to work with BirdLife
Intl. shapefiles (www.birdlife.org).
}
\details{
The function creates the presence-absence matrix based on a
raster file. Depending on the cell size, extension used and
number of species it may require a lot of memory, and may
take some time to process it. Thus, during this process, a
counting window is open so you can see the progress (i.e.
in what polygon the function is working). Note that the
number of polygons is not the same as the number of species
(i.e. one species may have more than one
polygon/shapefile).
}
\author{
Bruno Vilela & Fabricio Villalobos
}
\seealso{
plot.PresenceAbsence

lets.presab

lets.shFilter
}

