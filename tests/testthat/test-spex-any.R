context("spex-any")
library(testthat)
test_that("it's polygons with crs", {
  expect_that(spex(lux), is_a("SpatialPolygonsDataFrame"))
  expect_false(sp::is.projected(spex(lux)))
  expect_that(names(spex(lux, .id = "thing")), equals("thing"))
  })
