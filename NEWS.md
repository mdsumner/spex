# spex dev

* `spex()` with no input argument will return the extents of the current par 'usr' setting

* `polygonize`, `qm_rasterToPolygons`, and `qm_rasterToPolygons_sp` gain `na.rm` 
 argument to optionally remove any cells that are `NA` (in the first layer)

# spex 0.3.0

* new function `buffer_extent` for whole-grain expansion

* added S3 generic `polygonize`, alias of `qm_rasterToPolygons`

# spex 0.2.0

* Added function `qm_rasterToPolygons`.



