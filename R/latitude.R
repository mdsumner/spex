#' Latitude circle
#'
#' Create a circular polygon using a latitude value in a map projection. The
#' longitude range can be modified from global to give a portion of a circle.
#' 
#' The argument `nverts` controls the total number of vertices of the circle
#' within a linearly within the `lonlim` range of longitudes at `latitude`
#' 
#' This is for use on classic polar projections centred on the north or the
#' south pole, particularly Polar Stereographic and Lambert Azimuthal Equal Area
#' but will also work with some caveats on other families and situations. We
#' have not explored this more general use. Feel free to contact the maintainer
#' if you have interest in less typical usage or find problems.
#' 
#' @param latitude latitude value for the boundary, defaults to 0
#' @param crs map projection to use, defaults to southern Polar Stereographic true scale at -71S
#' @param lonlim the range of longitude to use, defaults to entire globe
#' @param nverts total number of vertices to use, see Details 
#' @return SpatialPolygonsDataFrame
#' @export
#'
#' @examples
#' latitudecircle(seq(0, -65, by = -5))
#' library(raster)
#' plot(ice)
#' circ <- latitudecircle(-71, crs = projection(ice))
#' plot(circ, add = TRUE)
latitudecircle <- function(latitude = 0, crs = "+proj=stere +lon_0=0 +lat_0=-90 +lat_ts=-71 +ellps=WGS84", 
                           lonlim = c(-180, 180), 
                           nverts = 1800) {
  stopifnot(is.numeric(latitude))
  if (length(latitude) > 1) warning("ignoring multiple latitude values, using first")
  latitude <- latitude[1L]

  raster::spPolygons(proj4::project(cbind(seq(lonlim[1], lonlim[2], length = nverts), latitude), crs), crs = crs, attr  = data.frame(latitude = latitude))
}

#' Latitude mask for polar raster
#' 
#' Mask out values based on latitude for a raster. This works by finding all cells at
#' latitudes less than `latitude` and setting them to missing. If `southern = FALSE` 
#' the inequality is reversed, and all cells at latitudes greater than `latitude` are
#' masked out. 
#' 
#' The `trim` option allows for the result to be reduced to the common bounding box
#' within which any row or column has a non-missing value. 
#' @param x a raster layer
#' @param latitude maximum latitude  (effectively a minimum latitude if `southern = FALSe`)
#' @param southern flag for whether south-polar context is used, default is `TRUE`
#' @param trim if `TRUE` runs `raster::trim` on the result, to remove `NA` margin
#' @param ... ignored currently
#' 
#' @seealso [raster::trim], [latitudecircle]
#' @return RasterLayer
#' @export
#'  
#' @examples  
#' library(raster)
#' plot(latmask(ice, -60))
#' plot(latmask(ice, -60, trim = TRUE))
#' ice[!ice > 0] <- NA
#' plot(ice)
#' plot(latmask(ice, -55, trim = TRUE))
latmask <- function(x, latitude = 0, southern = TRUE, trim = FALSE, ...) {
  if (length(latitude) > 1) warning("ignoring multiple latitude values, using first")
  latitude <- latitude[1L]
  
  if (raster::isLonLat(x))  {
    xy <- sp::coordinates(x)
    } else   {
      xy <- proj4::ptransform(sp::coordinates(x), raster::projection(x), "+proj=longlat +datum=WGS84")
    }
  if (southern) x[xy[,2] > (latitude * pi/180)] <- NA else x[xy[,2] < (latitude * pi/180)] <- NA
  if (trim) x <- raster::trim(x)
  x
}