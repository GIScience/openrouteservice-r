context("Rate limit")

test_that("Call API", {
  expect_identical(status_code(mock_method()), 200L)
  expect_identical(status_code(mock_method()), 429L)
  expect_identical(status_code(call_api(mock_method, list())), 200L)
  expect_identical(status_code(mock_method()), 429L)
})
