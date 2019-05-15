parse_leaf_extent <- function(x) {
  if (missing(x)) {
    x <- try(readLines("clipboard", warn = FALSE), silent = TRUE)
    if (inherits(x, "try-error")) {
      stop("cannot read from clipboard")
    }
    
    
    if (!grepl("^'\\{\"\\_southWest", x)) stop("clipboard contents does not look like leafem copy output")
  }
  #{"_southWest":{"lat":-1.307259612275665,"lng":23.411865234375},"_northEast":{"lat":6.937332868878443,"lng":31.904296875000004}}'
  parts <- unlist(strsplit(x, ":")[[1]][c(4, 7, 3, 6)])
  lon <- as.numeric(unlist(lapply(strsplit(parts[1:2], "\\}"), "[", 1)))
  lat <- as.numeric(unlist(lapply(strsplit(parts[3:4], ","), "[", 1)))
  spex(raster::extent(lon, lat), crs = "+proj=longlat +datum=WGS84")
}

#' Polygon extent
#'
#' Create Spatial Polygons with projection metadata from a 'Spatial Extent'.
#'
#' Called with no arguments will return the extent of the current 'par("usr")' setting. 
#' 
#' Called with a matrix, list, or data frame it will create an extent from a two columned thing. 
#' 
#' Called with `clipboard = TRUE` and `x` will be treated as the JSON-ic output of the clipboard copy from 
#' leafem (WIP). If x is missing, it will be attempted to be read from the clipboard. Clipboard read cannot
#' work on RStudio Server, so we allow the text value to be passed in. 
#' I.e. `spex(clipboard = TRUE)` will
#' read from the clipboard, `spex(tx, clipboard = TRUE)` will read from tx with value like 
#' \code{'{"_southWest":{"lat":-1.307259612275665,"lng":23.411865234375},"_north...}"'}. 
#' 
#' 
#' This function is to replace a common pattern in spatial packages which is
#' \itemize{
#' \item create an \code{\link[raster]{Extent}}, a bounding box in xmin,xmax,ymin,ymax but without projection metadata
#' \item coerce the Extent to \code{\link[sp]{SpatialPolygons}}
#' \item restore the 'CRS', the "coordinate reference system", i.e. projection metadata
#' \item elevate the object to be a \code{\link[sp]{SpatialPolygonsDataFrame}}.
#' }
#'
#' In short, this pattern exists because there is no projection metadata stored
#'  with either sp's \code{\link[sp]{bbox}} or raster's \code{\link[raster]{Extent}}.
#'
#' @param x any object with a \code{\link[raster]{Extent}}
#' @param byid return a separate object for every input sub-object (not yet implemented)
#' @param .id optional name for output attribute name
#' @param ... arguments for methods
#' @param crs a projection string
#' @param clipboard WIP this special-case allows x to be the result of the leafem clipboard copy process
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
#' @export
#' @seealso This pattern is displayed in the example code for \code{\link[raster]{cover}}.
spex <- function(x, crs, byid = FALSE, .id, ..., clipboard = FALSE) {
  UseMethod("spex")
}

#' @export
#' @name spex
spex.default <- function(x, crs, byid = FALSE, .id, ..., clipboard = FALSE) {
  if (clipboard) {
    out <- if (missing(x)) parse_leaf_extent() else parse_leaf_extent(x)
    return(out)
  }

  if (missing(crs)) crs <- NULL
   if (missing(x)) return(spex(raster::extent(graphics::par("usr")), crs = crs))
    if (byid) {
    stop("byid option not yet implemented")
    #lapply(split(x, seq(nrow(x))), raster::extent)
  } else {
    p <- as(extent(x), 'SpatialPolygons')
  }

if (is.data.frame(x)) x<- as.matrix(x)
if (is.list(x)) x <- do.call(cbind, x)
if (is.numeric(x)) {
  x <- as.matrix(x)
  if (ncol(x) < 2) stop("matrix of 2 columns required")
  if (ncol(x) > 2) warning("only 2 columns used from input")
  return(spex(raster::extent(range(x[, 1L]), range(x[, 2L])), crs = crs))
}
  if (missing(.id)) {
    .id <- sprintf("%s_extent", class(x)[1])
  }
  crs(p) <- crs(x)
  SpatialPolygonsDataFrame(p, setNames(data.frame(1L), .id))
}

#' @export
#' @name spex
spex.Extent <- function(x, crs, byid = FALSE, .id, ..., clipboard = FALSE) {
  p <- as(extent(x), 'SpatialPolygons')
  crs <- if (missing(crs) && raster::couldBeLonLat(x))  "+proj=longlat +datum=WGS84 +no_defs" else NULL
  raster::crs(p) <- crs
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
spex.sf <- function(x, crs, byid = FALSE, .id, ..., clipboard = FALSE) {
  spex(extent(x), attr(x[[attr(x, "sf_column")]], "crs")$proj4string)
}

#' Axis ranges from extent
#' 
#' Functions `xlim` and `ylim` return the two-value counterparts of an extent. 
#' 
#' Any projection metadata is dropped since this is a one-dimensional entity. 
#' @param x any object with an extent understood by `spex`
#' @param ... reserved for future methods
#' @export
xlim <- function(x, ...) UseMethod("xlim")
#' @export
#' @name xlim
xlim.default <- function(x, ...) {
  spx <- spex(x)
  c(raster::xmin(spx), raster::xmax(spx))
}
#' @export
#' @name xlim
ylim <- function(x, ...) UseMethod("ylim")
#' @export
#' @name xlim
ylim.default <- function(x, ...) {
  spx <- spex(x)
  c(raster::ymin(spx), raster::ymax(spx))
}

