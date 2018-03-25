# spex dev

* A modest speed (~5X) up by careful use of R. 

* better column name for resulting sp data frame

# spex 0.4.0

* new functions `xlim` and `ylim`, supporting anything understandable by `spex`

* new `extent` method for sf objects, otherwise missing in the core packages

* new `spex` support for sf objects

* `spex()` with no input argument will return the extents of the current par 'usr' setting (if only graphics devices had metadata registration for the space in use ...)

* `polygonize`, `qm_rasterToPolygons`, and `qm_rasterToPolygons_sp` gain `na.rm` 
 argument to optionally remove any cells that are `NA` (in the first layer)

# spex 0.3.0

* new function `buffer_extent` for whole-grain expansion

* added S3 generic `polygonize`, alias of `qm_rasterToPolygons`

# spex 0.2.0

* Added function `qm_rasterToPolygons`.



