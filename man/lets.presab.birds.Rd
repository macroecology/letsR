\name{lets.presab.birds}
\alias{lets.presab.birds}
\title{Shapefiles to presence/absence matrix by folder location}
\usage{
lets.presab.birds(path, xmn=-180, xmx=180, ymn=-90, ymx=90, resol=1,
remove.cells=TRUE, remove.sp=TRUE, show.matrix=FALSE,
crs=CRS("+proj=longlat +datum=WGS84"), cover=0, presence=NULL,
origin=NULL, seasonal=NULL)
}
\arguments{
  \item{path}{Path location in which the folders with one
  or more individual species shapefiles.}

  \item{xmx}{Maximun longitude used to construct the grid
  of cells in which the matrix will be based.}

  \item{xmn}{Minimun longitude used to construct the grid
  of cells in which the matrix will be based.}

  \item{ymx}{Maximun latitude used to construct the grid of
  cells in which the matrix will be based.}

  \item{ymn}{Minimun latitude used to construct the grid of
  cells in which the matrix will be based.}

  \item{remove.cells}{If true, the final matrix will not
  contain cells in the grid with a value equal to zero.}

  \item{remove.sp}{If true, the final matrix will not
  contain species that do not match any cell in the grid.}

  \item{show.matrix}{if true, only the object matrix will
  be shown.}

  \item{crs}{the projection of the shapefiles.}

  \item{cover}{Porcentage of the cell covered by the
  shapefile that shall be considered for presence (values
  between 0 and 1).}
}
\value{
The result is an object of class PresenceAbsence with the
following objects:

Presence and Absence Matrix: A matrix of Presence(1) and
Absence(0) with x (longitude) and y (latitude) of cells
centroid;

Richness Raster: A raster containing richness data;

Species name: A vector with species names that are in the
matrix.

*But see the option argument show.matrix.
}
\description{
Transform species shapefiles into a matrix of
presence/absence (specially desinged for BirdLife output).
}
\details{
The function creates the matrix of presence/absence based
on a raster file. Depending on the cell size, extension
used and number of species it may require a lot of memmory,
and may take some time to process it. Because of this,
during the process we open a counting window so you can see
in what polygon the function is working. Note that the
number of polygons is not the same number of species that
you have. Before run the function please check if the
arguments are in the way you want.
}
\author{
Bruno Vilela & Fabricio Villalobos
}
\seealso{
plot.PresenceAbsence

lets.presab

lets.shFilter
}

