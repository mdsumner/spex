#' Polygon extent
#'
#' Create Spatial Polygons with projection metadata from a 'Spatial Extent'.
#'
#' This function is to replace a common pattern in the 'sp'-'raster' family which is
#' \itemize{
#' \item create an \code{\link[raster]{Extent}}, a bounding box in xmin,xmax,ymin,ymax but without projection metadata
#' \item coerce the Extent to \code{\link[sp]{SpatialPolygons}}
#' \item restore the 'CRS', the "coordinate reference system", i.e. projection metadata
#' \item elevate the object to be a \code{\link[sp]{SpatialPolygonsDataFrame}}.
#' }
#'
#' In short, this pattern exists because there is no projection metadata stored
#'  with either sp''s \code{\link[sp]{bbox}} or 'raster''s \code{\link[raster]{Extent}}.
#'
#' @param x any object with a \code{\link[raster]{Extent}}
#' @param byid return a separate object for every input sub-object (not yet implemented)
#' @param .id optional name for output attribute name
#' @param ... arguments for methods
#' @param crs a projection string
#' @importFrom methods as
#' @importFrom raster crs<- crs extent
#' @importFrom sp SpatialPolygonsDataFrame
#' @importFrom stats setNames
#' @return 'SpatialPolygonsDataFrame'
#' @section Warning: Please note that an extent converted to polygons consists
#' of only four unique coordinates, and so this is not necessarily suited for
#' projection transformations.
#' @examples
#' library(raster)
#' data(lux)
#' exlux <- spex(lux)
#'
#' plot(lux)
#' plot(exlux, add = TRUE)
#'
#' ## put an extent and a CRS together
#' spex(extent(0, 1, 0, 1), crs = "+proj=laea +ellps=WGS84")
#' \dontrun{
#'  ## library(rgdal)
#'  ## p4 <- "+proj=laea +ellps=WGS84"
#'  ## plot(spTransform(lux, p4))
#'  ## warning, this is just 4 coordinates
#'  ## plot(spTransform(exlux, p4), add = TRUE)
#' }
#' @export
#' @section Potentially Unwelcome Rant:
#' Consider also that this is a common limitation, outside of R, where the "OGC
#' standard" for serialized geometry in "well known text" (WKT) or "well known
#' binary" (WKB) do not include projection metadata.   Some GIS systems do
#' provide serialized geometries that include this crucial metadata, and may we
#' encourage this to become more common. Not only is "longitude / latitude"
#' coordinates not always suitable, they are actually meaningless without
#' knowing the _datum_ (the ellipsoid radii and orientation, often WGS84) and
#' the units in use (usually 'degrees', but sometimes 'radians')
#'
#' @seealso This pattern is displayed in the example code for \code{\link[raster]{cover}}.
spex <- function(x, ...) {
  UseMethod("spex")
}

#' @export
#' @name spex
spex.default <- function(x, byid = FALSE, .id, ...) {
  if (byid) {
    stop("byid option not yet implemented")
    #lapply(split(x, seq(nrow(x))), raster::extent)
  } else {
    p <- as(extent(x), 'SpatialPolygons')
  }
  if (missing(.id)) .id <- deparse(substitute(x))
  crs(p) <- crs(x)
  SpatialPolygonsDataFrame(p, setNames(data.frame(1L), .id))
}

#' @export
#' @name spex
spex.Extent <- function(x, crs, ...) {
  p <- as(extent(x), 'SpatialPolygons')
  crs(p) <- crs
  spex(p, ...)
}
