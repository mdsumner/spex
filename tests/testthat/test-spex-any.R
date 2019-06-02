context("spex-any")
library(testthat)
test_that("it's polygons with crs", {
  expect_that(spex(lux), is_a("SpatialPolygonsDataFrame"))
  expect_false(sp::is.projected(spex(lux)))
  expect_that(names(spex(lux, .id = "thing")), equals("thing"))
  expect_equal(spex(cbind(c(0, 10), c(10, 0)))@polygons, 
               spex(data.frame(c(0, 10), c(10, 0)))@polygons)
  expect_equal(spex(list(c(0, 10), c(10, 0)))@polygons, 
               spex(data.frame(c(0, 10), c(10, 0)))@polygons)
  
  })
