#' Polygon extent
#'
#' Create Spatial Polygons with projection metadata from a 'Spatial Extent'.
#'
#' Called with no arguments will return the extent of the current 'par("usr")' setting. 
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
#' @seealso This pattern is displayed in the example code for \code{\link[raster]{cover}}.
spex <- function(x, ...) {
  UseMethod("spex")
}

#' @export
#' @name spex
spex.default <- function(x, crs, byid = FALSE, .id, ...) {
  if (missing(crs)) crs <- NULL
   if (missing(x)) return(spex(raster::extent(graphics::par("usr")), crs = crs))
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

#' Extent of simple features
#' 
#' This is the simplest of the missing "raster support" for the sf package, 
#' here using the xmin, xmax, ymin, ymax convention used by raster rather than 
#' the transpose version favoured in sp and sf. 
#' @param x object with an extent
#' @param ... unused 
#' @name extent
#' @aliases Extent
#' @importFrom raster extent
extent_sf <- function(x, ...) {
  raster::extent(attr(x[[attr(x, "sf_column")]], "bbox")[c(1, 3, 2, 4)])
}
setOldClass("sf")
setMethod(f = "extent", signature = "sf", definition = extent_sf)

#' @export
#' @name spex
spex.sf <- function(x, crs, ...) {
  spex(extent(x), attr(x[[attr(x, "sf_column")]], "crs")$proj4string)
}

#' Axis ranges from extent
#' 
#' Functions `xlim` and `ylim` return the two-value counterparts of an extent. 
#' 
#' Any projection metadata is dropped since this is a one-dimensional entity. 
#' @param x any object with an extent understood by `spex`
#' @param ... reserved for future methods
#'
xlim <- function(x, ...) UseMethod("xlim")
#' @export
#' @name spex
xlim.default <- function(x, ...) {
  spx <- spex(x)
  c(raster::xmin(spx), raster::xmax(spx))
}
#' @export
#' @name spex
ylim <- function(x, ...) UseMethod("ylim")
#' @export
#' @name spex
ylim.default <- function(x, ...) {
  spx <- spex(x)
  c(raster::ymin(spx), raster::ymax(spx))
}

