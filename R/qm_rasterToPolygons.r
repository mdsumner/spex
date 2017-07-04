#' Create a polygon layer from a raster. 
#'
#' This method uses the quadmesh to generate the coordinates, and creates a simple features layer. 
#' It's faster by turning off the checking done in the simple features package, but it's also faster
#' than raster because it uses a dense mesh to generate the coordinates. 
#'
#' @param x raster, brick or stack
#' @param na.rm defaults to `FALSE`, if `TRUE` will polygonize only the populated cells
#' @param ... arguments passed to methods, currently unused
#'
#' @return simple features POLYGON layer, or SpatialPolygonsDataFrame
#' @export
#' @section Warning: 
#' Please don't try this on large rasters, use quadmesh itself for efficient vector based use of a raster's
#' coordinates. It will work reasonably on largish grids, but you won't want to try plotting them or perform
#' operations on them, simple features is incredibly wasteful for objects like this. 
#' @examples
#' #library(raadtools)
#' library(raster)
#' r <- raster(volcano)
#' r[sample(ncell(r), 3000)] <- NA
#' b <- brick(r, r*1.5)
#' psf <- qm_rasterToPolygons(r, na.rm = TRUE)
#' #psp <- qm_rasterToPolygons_sp(r)
#' #pspr <- rasterToPolygons(r)
#' #library(rbenchmark)
#' #benchmark(qm_rasterToPolygons(r), qm_rasterToPolygons_sp(r), rasterToPolygons(r), replications = 2)
#' #                        test replications elapsed relative user.self sys.self user.child sys.child
#' # 1    qm_rasterToPolygons(r)            2   0.476    1.000     0.476    0.000          0         0
#' # 2 qm_rasterToPolygons_sp(r)            2   4.012    8.429     3.964    0.048          0         0
#' # 3       rasterToPolygons(r)            2   2.274    4.777     2.268    0.008          0         0
#' @importFrom raster as.data.frame
#' @importFrom quadmesh quadmesh
#' @importFrom raster projection
#' @rdname polygonize
#' @name polygonize
#' @aliases qm_rasterToPolygons qm_rasterToPolygons_sp
#' @export
polygonize.RasterLayer <- function(x, na.rm = FALSE, ...) {
  ## create dense mesh of cell corner coordinates
  qm <- quadmesh::quadmesh(x, na.rm = na.rm)
  ## split the mesh and construct simple features POLYGONS (without checking them)
  l <- lapply(split(t(qm$vb[1:2, qm$ib]), rep(seq_len(ncol(qm$ib)), each = 4)), function(x) structure(list(matrix(x, ncol = 2)[c(1, 2, 3, 4, 1), ]), 
                                                                                                      class = c("XY", "POLYGON", "sfg")))
  ## get all the layers off the raster
  sf1 <- raster::as.data.frame(x)
  if (na.rm ) {
    sf1 <- sf1[!is.na(values(x[[1]])), , drop = FALSE]
  }
  ## add the geometry column
  #sf1[["geometry"]] <- sf::st_sfc(l)
  sf1[["geometry"]] <- structure(l, n_empty = 0L, 
                                 crs = structure(list(epsg = NA_integer_, proj4string = raster::projection(x)), class = "crs"),
                                 precision = 0, 
            bbox = structure(c(xmin = raster::xmin(x), ymin = raster::ymin(x), xmax = raster::xmax(x), ymax = raster::ymax(x)), 
                             class = "bbox"), class = c("sfc_POLYGON", "sfc"))
  ## cast as simple features object
  structure(sf1, sf_column = "geometry", agr = NULL, class = c("sf", "data.frame"))
}
#' @name polygonize
#' @export
polygonize <- function(x, ...) UseMethod("polygonize")
#' @name polygonize
#' @export
qm_rasterToPolygons <- polygonize.RasterLayer
#' @name polygonize
#' @export
polygonize.RasterStack <- qm_rasterToPolygons
#' @name polygonize
#' @export
polygonize.RasterBrick <- qm_rasterToPolygons


#' @name polygonize
#' @export
qm_rasterToPolygons_sp <- function(x, na.rm = FALSE, ...) {
  x0 <- polygonize(x, na.rm = na.rm)
  g <- unclass(x0[[attr(x0, "sf_column")]])
  x0[[attr(x0, "sf_column")]] <- NULL
     
  gl <- lapply(unlist(lapply(g, function(x) unclass(x)), recursive = FALSE), sp::Polygon)
  sp::SpatialPolygonsDataFrame(sp::SpatialPolygons(lapply(seq_along(gl), function(x) sp::Polygons(list(gl[[x]]), as.character(x))), proj4string = sp::CRS(raster::projection(x))), 
                               as.data.frame(unclass(x0))[!is.na(values(x[[1]])), , drop = FALSE], match.ID = FALSE)
}



