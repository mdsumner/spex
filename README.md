
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/mdsumner/spex.svg?branch=master)](https://travis-ci.org/mdsumner/spex) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mdsumner/spex?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/spex) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/spex)](https://cran.r-project.org/package=spex) [![Coverage Status](https://img.shields.io/codecov/c/github/mdsumner/spex/master.svg)](https://codecov.io/github/mdsumner/spex?branch=master) [![](http://www.r-pkg.org/badges/version/spex)](http://cran.rstudio.com/web/packages/spex/index.html)

spex
----

Spatial extent with projection metadata.

Create a fully-fledged SpatialPolygonsDataFrame *extent* from any object understood by the 'raster' package function 'extent()'. If the input has projection metadata it will be carried through to the output.

There is also a method to put an extent and a crs together.

Installation
------------

Install 'spex' from CRAN.

``` r
install.packages("spex")
```

Examples
--------

``` r
library(spex)
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

## put an extent and a CRS together
spex(extent(0, 1, 0, 1), crs = "+proj=laea +ellps=WGS84")
#> class       : SpatialPolygonsDataFrame 
#> features    : 1 
#> extent      : 0, 1, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=laea +ellps=WGS84 
#> variables   : 1
#> names       : p 
#> min values  : 1 
#> max values  : 1
```

TODO
----

-   'byid' for multi-objects
-   by-group for multi objects
-   raster edge extent with pixel corner vertices
-   max segment length densification, in crs or by great-circle

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
