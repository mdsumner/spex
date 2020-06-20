## spex 0.7.1

* Resubmit 0.7.1 as 0.7.0 with file-anchored links to raster Extent-class. 

* Fixes errors on CRAN due to lib upgrades. 


## Test environments

* local ubuntu (release)
* winbuilder (devel)

## R CMD check results

0 errors | 0 warnings | 0 notes

I *did* see this warning, so I anchored to the '-class' file. 

* checking Rd cross-references ... WARNING
Non-file package-anchored link(s) in documentation object 'lux.Rd':
  ‘[sp]{SpatialPolygonsDataFrame}’

Non-file package-anchored link(s) in documentation object 'spex.Rd':
  ‘[raster]{Extent}’ ‘[sp]{SpatialPolygonsDataFrame}’




