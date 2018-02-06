read_extent_sp <- function(x, layer = 1L, ...) {
  layers <- vapour::vapour_layer_names(x)
  if (is.numeric(layer)) one_layer <- layers[layer]
  if (is.character(layer)) one_layer <- layer
  if (!one_layer %in% layers) warning("layer not found!")
  out <- do.call(rbind, purrr::map(vapour::vapour_read_extent(x),
                                   ~spex::spex(raster::extent(.x), crs = "+init=epsg:4326")))
  out$dsn <- x
  fids <- as.integer(seq_len(dim(out)[1L]))
  out$sql <- sprintf("SELECT * FROM %s WHERE FID = %i", one_layer,
                     fids)
  out$fid <- fids
  out$layer <- one_layer
  out
}

extent_sf <- function(x, model) {
  out <- model
  out[[1]][[1]] <- matrix(x[c(1, 1, 2, 2, 1,
                              3, 4, 4, 3, 3)], ncol = 2);
  attr(out, "bbox") <- structure(setNames(x[c(1, 3,2, 4)], c("xmin", "ymin", "xmax", "ymax")), class = "bbox")
  out
}


#' Extents
#'
#' @param x 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
#' extents(wrld_simpl) %>% st_as_sfc() %>% plot()
extents <- function(x, ...) {
  UseMethod("extents")
}
extents.character <- function(x, ...) {
  make_extents(vapour::vapour_read_extent(x, ...))
}
geometry_geometry <- function(x, ...) {
  if(inherits(x, "SpatialPolygons")) return(x@polygons)
  if(inherits(x, "SpatialLines")) return(x@lines)
  if (inherits(x, "SpatialMultiPoints")) return(x@coords)
}
extents.Spatial <- function(x, ...) {
  
  make_extents(lapply(geometry_geometry(x), function(obj) as.vector(t(sp::bbox(obj)))))
}
make_extents <- function(x, ...) {
  UseMethod("make_extents")
}
make_extents.default <- function(x, ...) {
  xx <- do.call(rbind, x)
  colnames(xx) <- c("xmin", "xmax", "ymin", "ymax")
  structure(xx, class = "extents")
}

print.extents <- function(x, ...) {
  print(tibble::as_tibble(unclass(x)))
}
st_as_sfc.extents <- function(x, ...) {
  xx <- split(as.vector(t(unclass(x))), rep(seq_len(dim(x)[1]), each = 4))
  modl <- sf::st_as_sfc(spex::spex(raster::extent(xx[[1]]), crs = NA_character_))
  do.call(c, purrr::map(xx, extent_sf, model = modl))
}

