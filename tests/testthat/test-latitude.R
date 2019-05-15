context("test-latitude.R")
library(raster)  ## values()
lat1 <- latitudecircle(-70)
lat2 <- latitudecircle(70, crs = "+proj=stere +lat_0=90")
#dput(extent(lat2))

## these are the difference between proj4::project and reproj::reproj (ptransform)
#ex1 <- round(c(xmin = -2194493.41107854, xmax = 2194493.41107854, 
#ymin = -2194494.24760918, ymax = 2194490.90148727))
#ex2 <- round(c(xmin = -2246756.47377231, xmax = 2246756.47377231, 
#ymin = -2246753.90441374, ymax = 2246757.33022538))
ex1 <- round(c(xmin = -2194493.41107854, xmax = 2194493.41107854, 
    ymin = -2194494.24760918, ymax = 2194490.90148727))
ex2 <- round(c(xmin = -2255924.46099292, xmax = 2255924.46099292, 
    ymin = -2255921.88114997, ymax = 2255925.32094078))
test_that("latitude circle works", {
  expect_equal(ex1, c(xmin = round(xmin(lat1)), 
                      xmax = round(xmax(lat1)), 
                      ymin = round(ymin(lat1)), 
                      ymax = round(ymax(lat1))))
  
  expect_equal(ex2, c(xmin = round(xmin(lat2)), 
                      xmax = round(xmax(lat2)), 
                      ymin = round(ymin(lat2)), 
                      ymax = round(ymax(lat2))))
})


ice2 <- latmask(ice)
ice3 <- latmask(ice, -70)
test_that("latmask works", {
  expect_equal(extent(ice), extent(ice2))
  expect_true(sum(is.na(values(ice))) < sum(is.na(values(ice3))))
})

