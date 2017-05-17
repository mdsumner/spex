context("spex-extent")

test_that("extent and crs works", {
  expect_that(spex(raster::extent(lux), raster::crs(lux)), is_a("SpatialPolygonsDataFrame"))
})


test_that("by id is not implemented", {
  expect_that(spex(lux, byid = TRUE), throws_error("implemented"))
})


