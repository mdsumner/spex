# spex dev

* Fixed tests. 

* Added sfc method, and now using crsmeta. 

* Ensure projargs is character, not logical. 

# spex 0.6.0

* Wrap previous proj4 code with reproj, proj4 is no longer imported by spex. 

* Add new features for basic list, data frame or matrix input. 

* New `spex(clipboard = TRUE/FALSE)` argument to take advantage of leafem copy extent (WIP). 


# spex 0.5.0

* New latitude functions `latitudecircle` to build a polar circle. 

* Now return all cells as polygons if raster has no values. 

* Improved handling of `na.rm`, also now TRUE by default. #13 Thanks to Adriano Fantini.

* A modest speed-up (up to 2X) for `polygonize` by more careful use of R. 

* better column name for resulting Spatial data frame

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



