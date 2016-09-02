
<!-- README.md is generated from README.Rmd. Please edit that file -->
spex
----

Spatial extent with projection metadata.

Create a fully-fledged SpatialPolygonsDataFrame *extent* from any object understood by the 'raster' package function 'extent()'. If the input has projection metadata it will be carried through to the output.

There is also a method to put an extent and a crs together.

Examples
--------

``` r
library(spex)
#> No methods found in "raster" for requests: as
library(raster)
#> Loading required package: sp
data(lux)
(exlux <- spex(lux))
#> class       : SpatialPolygonsDataFrame 
#> features    : 1 
#> extent      : 5.74414, 6.528252, 49.44781, 50.18162  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
#> variables   : 1
#> names       : lux 
#> min values  :   1 
#> max values  :   1

plot(lux)
plot(exlux, add = TRUE)
title(projection(exlux), cex.main = 0.7)
```

![](README-unnamed-chunk-2-1.png)

``` r
## put an extent and a CRS together
spex(extent(0, 1, 0, 1), crs = "+proj=laea +ellps=WGS84")
#> class       : SpatialPolygons 
#> features    : 1 
#> extent      : 0, 1, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=laea +ellps=WGS84
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
