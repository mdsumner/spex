
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Travis-CI Build
Status](https://travis-ci.org/mdsumner/spex.svg?branch=master&env=BUILD_NAME=xenial_release&label=linux)](https://travis-ci.org/mdsumner/spex)
[![Build
Status](https://travis-ci.org/mdsumner/spex.svg?branch=master&env=BUILD_NAME=osx_release&label=osx)](https://travis-ci.org/mdsumner/spex)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/mdsumner/spex?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/spex)
[![Coverage
status](https://codecov.io/gh/mdsumner/spex/branch/master/graph/badge.svg)](https://codecov.io/github/mdsumner/spex?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/spex)](https://cran.r-project.org/package=spex)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/spex)](https://cran.r-project.org/package=spex)
<!-- badges: end -->

## spex

Spex provides a small set of functions for working with spatial data.
These are

  - `spex()` - a spatial extent with projection metadata
  - `polygonize()` - a fast quadmesh-based pixel-to-polygon translation
  - `buffer_extent` - a convenience function for tidy extents
  - `xlim`, `ylim` - convenience functions for the axes of an extent
  - `extent` - convenience functions for sf objects

Create a fully-fledged SpatialPolygonsDataFrame *extent* from any object
understood by the ‘raster’ package function ‘extent()’. If the input has
projection metadata it will be carried through to the output. The
intention is to support any object from packages `sp`, `raster` and
`sf`. If you want this to work on other types, [create an issue and get
in touch to discuss\!](https://github.com/mdsumner/spex/issues).

The polygonization approach is faster than `rasterToPolygons`, and
multi-layer rasters are converted to multi-column spatial data frames.
This only does the pixel-to-polygon case. It provides an `sf` POLYGON
data frame, but there is a version `qm_rasterToPolygons_sp` that returns
a Spatial version.

The “buffered extent” is used to create cleanly aligned extents, useful
for generating exacting grid structures as raster or vector.

## Installation

Install ‘spex’ from CRAN.

``` r
install.packages("spex")
```

## Examples

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
#> names       : SpatialPolygonsDataFrame_extent 
#> value       :                               1

## put an extent and a CRS together
spex(extent(0, 1, 0, 1), crs = "+proj=laea +ellps=WGS84")
#> class       : SpatialPolygonsDataFrame 
#> features    : 1 
#> extent      : 0, 1, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=laea +ellps=WGS84 
#> variables   : 1
#> names       : SpatialPolygons_extent 
#> value       :                      1
```

Create a simple features POLYGON data frame from a raster.

``` r
library(spex)
library(raster)
r <- raster(volcano)
tm <- system.time(p <- qm_rasterToPolygons(r))

p1 <- polygonize(r)

identical(p, p1)
#> [1] TRUE
 
p3 <- qm_rasterToPolygons_sp(r)
class(p3)
#> [1] "SpatialPolygonsDataFrame"
#> attr(,"package")
#> [1] "sp"

nrow(p)
#> [1] 5307

class(p)
#> [1] "sf"         "data.frame"

class(p$geometry)
#> [1] "sfc_POLYGON" "sfc"

print(tm)
#>    user  system elapsed 
#>   0.256   0.000   0.256
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

There are convenience functions for sf objects.

``` r
class(psf)
#> [1] "sf"         "data.frame"
extent(psf)
#> class       : Extent 
#> xmin        : 0 
#> xmax        : 1.23 
#> ymin        : 0 
#> ymax        : 1
spex(psf)
#> class       : SpatialPolygonsDataFrame 
#> features    : 1 
#> extent      : 0, 1.23, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : NA 
#> variables   : 1
#> names       : SpatialPolygons_extent 
#> value       :                      1
spex(sf::st_set_crs(psf, 3031))
#> class       : SpatialPolygonsDataFrame 
#> features    : 1 
#> extent      : 0, 1.23, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
#> variables   : 1
#> names       : SpatialPolygons_extent 
#> value       :                      1
```

-----

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
