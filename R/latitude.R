#' Latitude circle
#'
#' Create a circular polygon using a latitude value in a map projection. The longitude range can be
#' modified from global to give a portion of a circle. 
#' 
#' @param latitude latitude value for the boundary, defaults to 0
#' @param proj map projection to use, defaults to southern Polar Stereographic true scale at -71S
#' @param lonlim the range of longitude to use, defaults to entire globe
#'
#' @return SpatialPolygonsDataFrame
#' @export
#'
#' @examples
#' latitudecircle()
latitudecircle <- function(latitude = 0, proj = "+proj=stere +lon_0=0 +lat_0=-90 +lat_ts=-71 +ellps=WGS84", lonlim = c(-180, 180)) {
  stopifnot(is.numeric(latitude))
  if (length(latitude) > 1) warning("ignoring multiple latitude values, using first")
  latitude <- latitude[1L]

  raster::spPolygons(proj4::project(cbind(seq(lonlim[1], lonlim[2], length = 1000), latitude), proj), crs = proj, attr  = data.frame(latitude = latitude))
}

#' Latitude mask for polar raster
#' 
#' @param x a raster layer
#' @param latitude maximum latitude  (effectively a minimum latitude if `southern = FALSe`)
#' @param southern flag for whether south-polar context is used, default is `TRUE`
#' @param trim if `TRUE` runs `raster::trim` on the result, to remove `NA` margin
#' @param ... ignored currently
#' @return RasterLayer
#' @export
#'  
#' @examples  
#' library(raster)
#' plot(latmask(ice, -60))
#' plot(latmask(ice, -60, trim = TRUE))
latmask <- function(x, latitude = 0, southern = TRUE, trim = FALSE, ...) {
  if (raster::isLonLat(x))  {
    xy <- sp::coordinates(x)
    } else   {
      xy <- proj4::ptransform(sp::coordinates(x), raster::projection(x), "+init=epsg:4326")
    }
  if (southern) x[xy[,2] > (latitude * pi/180)] <- NA else x[xy[,2] < (latitude * pi/180)] <- NA
  if (trim) x <- raster::trim(x)
  x
}