#' Create a polygon layer from a raster. 
#'
#' This method uses the quadmesh to generate the coordinates, and creates a simple features layer. 
#' It's faster by turning off the checking done in the simple features package, but it's also faster
#' than raster because it uses a dense mesh to generate the coordinates. 
#' @param x raster, brick or stack
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
#' b <- brick(r, r*1.5)
#' psf <- qm_rasterToPolygons(r)
#' #psp <- qm_rasterToPolygons_sp(r)
#' #pspr <- rasterToPolygons(r)
#' #library(rbenchmark)
#' #benchmark(qm_rasterToPolygons(r), qm_rasterToPolygons_sp(r), rasterToPolygons(r), replications = 2)
#' #                        test replications elapsed relative user.self sys.self user.child sys.child
#' # 1    qm_rasterToPolygons(r)            2   0.476    1.000     0.476    0.000          0         0
#' # 2 qm_rasterToPolygons_sp(r)            2   4.012    8.429     3.964    0.048          0         0
#' # 3       rasterToPolygons(r)            2   2.274    4.777     2.268    0.008          0         0
#' @importFrom raster as.data.frame
#' @importFrom sf st_as_sf st_sfc 
#' @importFrom quadmesh quadmesh
qm_rasterToPolygons <- function(x) {
  ## create dense mesh of cell corner coordinates
  qm <- quadmesh::quadmesh(x)
  ## split the mesh and construct simple features POLYGONS (without checking them)
  l <- lapply(split(t(qm$vb[1:2, qm$ib]), rep(seq_len(ncol(qm$ib)), each = 4)), function(x) structure(list(matrix(x, ncol = 2)[c(1, 2, 3, 4, 1), ]), 
                                                                                                      class = c("XY", "POLYGON", "sfg")))
  ## get all the layers off the raster
  sf1 <- as.data.frame(x)
  ## add the geometry column
  sf1[["geometry"]] <- sf::st_sfc(l)
  ## cast as simple features object
  sf::st_as_sf(sf1)
}

#' @name qm_rasterToPolygons
qm_rasterToPolygons_sp <- function(x) {
  as(qm_rasterToPolygons(x), "Spatial")
}



