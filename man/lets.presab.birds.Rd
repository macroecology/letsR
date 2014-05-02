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

  \item{remove.cells}{If \code{TRUE}, the final matrix will
  not contain cells in the grid with a value of zero (i.e.
  sites with no species present).}

  \item{remove.sp}{If \code{TRUE}, the final matrix will
  not contain species that do not match any cell in the
  grid.}

  \item{show.matrix}{if \code{TRUE}, only the
  presence-absence matrix will be shown.}

  \item{character}{representign the PROJ.4 type description
  of a Coordinate Reference System (map projection).}

  \item{cover}{Percentage of the cell covered by the
  shapefile that will be considered for presence (values
  between 0 and 1).}

  \item{presence}{A vector with the code numbers for the
  presence type to be considered in the process.}

  \item{origin}{A vector with the code numbers for the
  origin type to be considered in the process.}

  \item{seasonal}{A vector with the code numbers for the
  seasonal type to be considered in the process.}

  \item{count}{Logical, if \code{TRUE} a counting window
  will open.}
}
\value{
The result is an object of class PresenceAbsence with the
following objects:

\strong{Presence-Absence Matrix}: A matrix of species'
presence(1) and absence(0) information. The first two
columns contain the longitude (x) and latitude (y) of the
cells' centroid (from the gridded domain used);

\strong{Richness Raster}: A raster containing species
richness data;

\strong{Species name}: A vector with species' names
contained in the matrix.

*But see the option argument \code{show.matrix}.
}
\description{
Convert species' shapefiles into a presence-absence matrix.
This function is specially designed to work with BirdLife
Intl. shapefiles (\url{http://www.birdlife.org}).
}
\details{
The function creates the presence-absence matrix based on a
raster file. Depending on the cell size, extension used and
number of species it may require a lot of memory, and may
take some time to process it. Thus, during the process, if
\code{count} argument is set \code{TRUE}, a counting window
will open so you can see the progress (i.e. in what polygon
the function is working). Note that the number of polygons
is not the same as the number of species that you have
(i.e. a species may have more than one polygon/shapefiles).
}
\examples{
\dontrun{
#Constructing a Presence/Absence matrix for birds (this will not work if do not change the path for the folder were you kept the spatial data)
PAM <- lets.presab.birds("YOURPATH/YOURPATH/BIRDS")
plot(PAM)  # Species richness map

}
}
\author{
Bruno Vilela & Fabricio Villalobos
}
\seealso{
\code{\link{plot.PresenceAbsence}}

\code{\link{lets.presab}}

\code{\link{lets.shFilter}}
}

