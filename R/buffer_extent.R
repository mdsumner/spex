#' Whole grain buffers
#'
#' Ensure a raster extent aligns to a clean divisor.
#' 
#' This function is used to generate extents that have tidy boundaries, 
#' i.e. extents that align to a clean whole number like "10000". 
#' 
#' (We can't to S4 group generic because raster has set that specifically for use with '+' and '-'.) 
#' @param e1 input \code{\link[raster]{extent}}
#' @param e2 grain size
#' @examples
#' library(raster)
#' buffer_extent(extent(0.1, 2.2, 0, 3), 2)
#' @importFrom raster extent xmin xmax ymin ymax
#' @export
buffer_extent <- function(e1, e2) {
  e1 <- extent(e1)
  if (e2 == 0) return(e1)
  num0 <- as_double(e1)
  extent((num0 %/% e2) * e2 + c(0, e2, 0, e2))
}


#' Atomic vector extent
#'
#' Coerce a \code{\link[raster]{extent}} to an atomic vector of \code{c(xmin(x), xmax(x), ymin(x), ymax(x))}.
#'
#' Note that \code{as_integer} results in truncation, see rasterOps for positive buffering.
#' @param x a \code{\link[raster]{extent}}
#' @param ... unused
#' @keywords internal
#' @return numeric vector
#' @seealso base::as.double
# examples
# library(raster)
# as_double(extent(0, 1, 0, 1))
# as_numeric(extent(0, 1, 0, 1))
# as_integer(extent(0, 1, 0, 1) + c(2.5, 27.877, 100, 999.1))
as_double <- function(x, ...) UseMethod("as_double")
#' @name as_double
#' @export
as_double.Extent <- function(x, ...) {
  c(xmin(x), xmax(x), ymin(x), ymax(x))
}

#' @name as_double
as_integer <- function(x, ...) UseMethod("as_integer")
#' @name as_double
as_integer.Extent <- function(x, ...) {
  as.integer(as_double(x))
}
