#' Create a polygon layer from a raster. 
#'
#' This method uses the quadmesh to generate the coordinates, and creates a simple features layer. 
#' It's faster by turning off the checking done in the simple features package, but it's also faster
#' than raster because it uses a dense mesh to generate the coordinates. 
#'
#' Note that `na.rm` adds efficiency only if a fair proportion of the cells are NA, and so is reduced if 
#' these aren't shared over layers.  
#' @param x raster, brick or stack
#' @param na.rm defaults to `FALSE`, if `TRUE` will polygonize only the cells that are non-NA across all layers
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
  ## get all the layers off the raster
  sf1 <- stats::setNames(as.data.frame(raster::values(x)), names(x))
  
  na_rm <- na.rm
  if (na.rm && raster::nlayers(x) > 1) {
    na_all <- Reduce(`&`, lapply(sf1, function(x) is.na(x)))
    na.rm <- FALSE
  } else {
    na_all <- is.na(sf1[[1]])
    
  }
  
  ## create dense mesh of cell corner coordinates
  qm <- quadmesh::quadmesh(x, z = NULL, na.rm = na.rm)
  ## a dummy structure to copy
  template <- structure(list(cbind(1:5, 0)), 
            class = c("XY", "POLYGON", "sfg"))
  
  ## TODO: speed up, this is the slow part
  spl <- split(t(qm$vb[1:2, qm$ib]), rep(seq_len(ncol(qm$ib)), each = 4))
  ## remove the *common-missing* quads here
  if (na_rm) {
    sf1 <- sf1[!na_all, , drop = FALSE]
    spl <- spl[!na_all]
    
  }
  l <- lapply(spl, function(a) {
    template[[1L]] <- 
    cbind(a[c(1, 2, 3, 4, 1)], a[c(5, 6, 7, 8, 5)])
    template
    })
  
  ex <- extent(x)
  sf1[["geometry"]] <- structure(l, n_empty = 0L, 
                                 crs = structure(list(epsg = NA_integer_, proj4string = raster::projection(x)), class = "crs"),
                                 precision = 0, 
            bbox = structure(c(xmin = ex@xmin, 
                               ymin = ex@ymin, 
                               xmax = ex@xmax, 
                               ymax = ex@ymax), 
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
#' @importFrom raster getValues
qm_rasterToPolygons_sp <- function(x, na.rm = FALSE, ...) {
  x0 <- polygonize(x, na.rm = na.rm)
  g <- unclass(x0[[attr(x0, "sf_column")]])
  x0[[attr(x0, "sf_column")]] <- NULL
     
  gl <- lapply(unlist(lapply(g, function(x) unclass(x)), recursive = FALSE), sp::Polygon)
  sp::SpatialPolygonsDataFrame(sp::SpatialPolygons(lapply(seq_along(gl), function(x) sp::Polygons(list(gl[[x]]), as.character(x))), proj4string = sp::CRS(raster::projection(x))), 
                               as.data.frame(unclass(x0)), match.ID = FALSE)
}



