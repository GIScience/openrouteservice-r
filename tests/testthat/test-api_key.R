context("api_key")

test_that("running CI", {
  Sys.setenv(CI="true")
  expect_true(runningCI())
  Sys.unsetenv("CI")
  expect_false(runningCI())
})
