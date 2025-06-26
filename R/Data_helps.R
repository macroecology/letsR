#' IUCN evaluation for frogs of the genus Phyllomedusa
#' 
#' Result of the (deprecated) function lets.iucn. 
#' applied to South American frog genus Phyllomedusa in 2014.
#'
#'@format A data frame with 32 rows and 7 columns:
#'\describe{
#'  \item{Species}{Scientific name}
#'  \item{Family}{Family}
#'  \item{Status}{Red List Status}
#'  \item{Criteria}{Criteria for listing as threatened}
#'  \item{Population}{Population trend per IUCN}
#'  \item{Description_Year}{Year described}
#'  \item{Country}{Presence in country}
#'}
#'
#'@source IUCN - \url{https://www.iucnredlist.org/}. 2014.  
"IUCN" 


#' PresenceAbsence object for frogs of the genus Phyllomedusa
#' 
#' PresenceAbsence object obtained using the function \code{\link{lets.presab}} 
#' for the Geographic distribution of the South American frog genus \link{Phyllomedusa}.
#' @format A PresenceAbsence object
#' @source Generated from IUCN Spatial Data - \url{https://www.iucnredlist.org/}. 2014.
"PAM"

#' Phyllomedusa
#' 
#' Geographic distribution of the South American frog genus Phyllomedusa. 
# 'Data modified from the IUCN Red List spatial dataset, downloaded 05/2014).
#'
#' See the IUCN Red List Attribute Information for Species Ranges. 
#'
#' @format A simple feature collection for 32 species with 46 features and 4 fields.
#' 
#' \describe{
#'  \item{binomial}{Scientific name}
#'  \item{presence}{IUCN Red List distributional code}
#'  \item{origin}{IUCN Red List distributional code}
#'  \item{seasonal}{IUCN Red List distributional code}
#' }
#' @source IUCN - \url{https://www.iucnredlist.org/}. 2014.
"Phyllomedusa"


#' Mean temperature raster for the world.
#'
#' Mean temperature raster in degrees Celsius (multiplied by 100) 
#' for the world in 10 arc min of resolution. 
#' @format A PackedStatRaster object.
#' @source Data was modified from WorldClim (\url{https://worldclim.com/}, downloaded 05/2014).
#' 
#' Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. 
#' Very high resolution interpolated climate surfaces for global land areas. 
#' International Journal of Climatology 25: 1965-1978.
"temp"



#' Annual Precipitation raster for the world.
#'
#' Annual Precipitation in mm for the world in 10 arc min of resolution. 
#' @format A PackedStatRaster object.
#' @source Data was modified from WorldClim (\url{https://worldclim.com/}, downloaded 10/2024).
#' 
#' Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. 
#' Very high resolution interpolated climate surfaces for global land areas. 
#' International Journal of Climatology 25: 1965-1978.
"prec"

#' Simplified world country polygons
#' 
#' World map in sf format. Obtained from maptools 
#' and converted to sf.
#'  
#' @format A simple feature collection with 246 features and 11 fields.
#' @source Originally
#'  \url{https://mappinghacks.com/data/TM_WORLD_BORDERS_SIMPL-0.2.zip}, 
#'  now available from
#'  \url{https://github.com/nasa/World-Wind-Java/tree/master/WorldWind/testData/shapefiles}.
"wrld_simpl"


