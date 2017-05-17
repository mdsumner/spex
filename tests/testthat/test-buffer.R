context("buffer")

test_that("whole grain buffers work", {
  expect_identical(buffer_extent(extent(lux), 10) %>% as_double(), c(0, 10, 40, 60))
  expect_equal(buffer_extent(extent(lux), 10) %>% as_integer(), c(0, 10, 40, 60))
  
})
