p <- list(x = 19454710.6021716, y = -4421930.85102171)  ## i.e. locator
merc <- "+proj=merc +a=6378137 +b=6378137"
library(sf)
.buf <- st_buffer(st_sfc(st_point(do.call(cbind, p)), crs = merc), 150)

usethis::use_data(.buf, internal = TRUE)
