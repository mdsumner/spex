library(raster)
library(rgdal)
lux <- shapefile(system.file("external/lux.shp", package="raster"))
devtools::use_data(lux, compress = "xz")
