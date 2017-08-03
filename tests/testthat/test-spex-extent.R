context("spex-extent")

test_that("extent and crs works", {
  expect_that(spex(raster::extent(lux), raster::crs(lux)), is_a("SpatialPolygonsDataFrame"))
})


test_that("by id is not implemented", {
  expect_that(spex(lux, byid = TRUE), throws_error("implemented"))
})



test_that("extent of anything", {
  library(raster)
  raster::extent(psf)
  expect_equal(raster::xmin(spex(psf, "+")), 0)
  expect_equal(raster::xmax(spex(psf, "+")), 1.23)
  
  graphics.off()
  expect_equal(raster::extent(spex()) , raster::extent(0, 1, 0, 1))
})