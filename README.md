
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/mdsumner/spex.svg?branch=master)](https://travis-ci.org/mdsumner/spex) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mdsumner/spex?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/spex) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/spex)](https://cran.r-project.org/package=spex) [![Coverage Status](https://img.shields.io/codecov/c/github/mdsumner/spex/master.svg)](https://codecov.io/github/mdsumner/spex?branch=master) [![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/spex)](https://CRAN.R-project.org/package=spex)

spex
----

Spex provides a small set of functions for working with spatial data. These are

-   `spex()` - a spatial extent with projection metadata
-   `polygonize()` - a fast quadmesh-based pixel-to-polygon translation
-   `buffer_extent` - a convenience function for tidy extents

Create a fully-fledged SpatialPolygonsDataFrame *extent* from any object understood by the 'raster' package function 'extent()'. If the input has projection metadata it will be carried through to the output.

The polygonization approach is faster than `rasterToPolygons`, and multi-layer rasters are converted to multi-column spatial data frames. This only does the pixel-to-polygon case. It provides an `sf` POLYGON data frame, but there is a version `qm_rasterToPolygons_sp` that returns a Spatial version.

The "buffered extent" is used to create cleanly aligned extents, useful for generating exacting grid structures as raster or vector.

Installation
------------

Install 'spex' from CRAN.

``` r
install.packages("spex")
```

Examples
--------

Create a Spatial object as a single extent polygon from a raster.

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

Create a simple features POLYGON data frame from a raster.

``` r
library(spex)
library(raster)
r <- raster(volcano)
tm <- system.time(p <- qm_rasterToPolygons(r))

nrow(p)
#> [1] 5307

class(p)
#> [1] "sf"         "data.frame"

class(p$geometry)
#> [1] "sfc_POLYGON" "sfc"

print(tm)
#>    user  system elapsed 
#>   0.276   0.028   0.307
```

Create a buffered extent with whole-number aligned edges.

``` r
library(spex)

(ex <- extent(lux))
#> class       : Extent 
#> xmin        : 5.74414 
#> xmax        : 6.528252 
#> ymin        : 49.44781 
#> ymax        : 50.18162

buffer_extent(ex, 10)
#> class       : Extent 
#> xmin        : 0 
#> xmax        : 10 
#> ymin        : 40 
#> ymax        : 60

buffer_extent(ex, 2)
#> class       : Extent 
#> xmin        : 4 
#> xmax        : 8 
#> ymin        : 48 
#> ymax        : 52
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
