test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("returns a URL that starts right", {
  expect_match(get_ntd_url(), regexp = "^https://www.transit.dot.gov/sites/fta.dot.gov/files/")
})

test_that("URL contains the right terms for different data_types", {
  expect_match(get_ntd_url("raw"), regexp = "Raw")
  expect_match(get_ntd_url("adjusted"), regexp = "Adjusted")
})

test_that("function returns error for invalid parameter values", {
  expect_error(get_ntd_url("nonsense"))
})
