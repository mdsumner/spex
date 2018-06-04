#' spex
#'
#' Tools for spatial extents that are agnostic regarding format (i.e. `sp`,
#' `sf`, or `raster`). These functions fill some of the gaps within and between
#' these packages for dealing with object extents in flexible ways. Generally,
#' spex considers extents of raster cells, and extents of objects as first-class
#' objects (with projection metadata). and provides helpers for  latitudinal
#' boundaries within projected data.

#' @name spex-package
#' @section Spatial Extent:
#' \tabular{ll}{
#'  \code{\link{buffer_extent}} \tab Buffer an extent to a given whole number. \cr
#'  \code{\link{latitudecircle}} \tab Create a latitude circle in a chosen projection. \cr
#'  \code{\link{latmask}} \tab Mask a raster based on a minimum (or maximum) latitude. \cr
#'  \code{\link{polygonize}} \tab Convert raster cells to polygons. \cr
#'  \code{\link{qm_rasterToPolygons}} \tab The `sf` version of `polygonize`.  \cr
#'  \code{\link{qm_rasterToPolygons_sp}} \tab The `sp` version of `polygonize`. \cr
#'  \code{\link{spex}} \tab A function to produce a fully fledged Spatial object extent. \cr
#'  \code{\link{xlim}, \link{ylim}} \tab Helper functions for extents. \cr
#'  
#' }
#' @docType package
NULL

#' The 'lux' Spatial Polygons from the 'raster' package.
#'
#' @name lux
#' @format \code{\link[sp]{SpatialPolygonsDataFrame}} with columns:
#' \itemize{
#'  \item ID_1
#'  \item NAME_1
#'  \item ID_2
#'  \item NAME_2
#'  \item AREA
#' }
#' @docType data
#' @examples
#' library(sp)
#' plot(lux)
NULL

#' A polygon data set with `sf` class. 
#' 
#' @name psf
#' @docType data
NULL

#' A raster data set with southern ocean sea ice concentration
#' 
#' When first created this data set was from 2018-04-28. 
#' @name ice
#' @docType data
NULL