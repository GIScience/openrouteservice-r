context("Key management")

## record current state before starting any tests
env <- Sys.getenv("ORS_API_KEY", NA);

## restore initial state
on.exit({
  if ( !is.na(env) ) Sys.setenv(ORS_API_KEY = env)
}, add = TRUE)

Sys.unsetenv("ORS_API_KEY")

api_key_val <- "my_api_key_value"

test_that("Get API key from environment variable", {
  Sys.setenv(ORS_API_KEY = api_key_val)
  expect_identical(ors_api_key(), api_key_val)
})

test_that("Use non-default environment variable for api key", {
  options(openrouteservice.api_key_env = "MY_API_KEY")
  Sys.setenv(MY_API_KEY = api_key_val)
  expect_identical(ors_api_key(), api_key_val)
  Sys.unsetenv("MY_API_KEY")
})
