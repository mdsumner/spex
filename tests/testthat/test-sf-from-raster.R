context("sf-from-raster")

## TODO: Rename context
## TODO: Add more tests

library(raster)
r <- aggregate(raster(volcano), 4)
b <- brick(r, r /2)
test_that("creation of polygons from raster works", {
  expect_that(qm_rasterToPolygons(b), is_a("sf"))
  expect_that(qm_rasterToPolygons(b), is_a("sf"))
  expect_that(qm_rasterToPolygons(r), is_a("sf"))
  expect_that(qm_rasterToPolygons(r), is_a("sf"))
  
   expect_that(qm_rasterToPolygons_sp(b), is_a("SpatialPolygonsDataFrame"))
   expect_that(qm_rasterToPolygons_sp(b), is_a("SpatialPolygonsDataFrame"))
   expect_that(qm_rasterToPolygons_sp(r), is_a("SpatialPolygonsDataFrame"))
  # expect_that(qm_rasterToPolygons_sp(r), is_a("SpatialPolygonsDataFrame"))
  # 
  
})

d <- raster::rasterize(lux, raster::raster(lux, res = 0.01))
test_that("we can also qm_raster here", {
  pd <- polygonize(d) %>% 
    expect_named(c("layer", "geometry")) %>% 
    expect_s3_class("sf")
  expect_equal(nrow(pd), 5694)
  pnad <- polygonize(d, na.rm = TRUE)
  expect_equal(nrow(pnad), 3195)
})
