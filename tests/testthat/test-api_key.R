context("API key management")

## record current state before starting any tests
env <- Sys.getenv("ORS_API_KEY", NA);
key <- tryCatch(keyring::key_get("openrouteservice"), error = function(e) NA)

Sys.unsetenv("ORS_API_KEY")
api_key_val <- "key_stored_in_keyring"

test_that("Set key in keyring", {
  expect_silent(ors_api_key(api_key_val))
})

test_that("Get key from keyring", {
  expect_identical(ors_api_key(), api_key_val)
})

test_that("Environment variable takes precedance over keyring", {
  ors_api_key <- Sys.getenv("ORS_API_KEY", NA)
  on.exit(
    if ( is.na(ors_api_key) )
      Sys.unsetenv("ORS_API_KEY")
    else
      Sys.setenv(ORS_API_KEY = ors_api_key)
  )
  api_key_val <- "key_stored_in_env_var"
  Sys.setenv(ORS_API_KEY = api_key_val)
  expect_identical(ors_api_key(), api_key_val)
})

test_that("Use non-default environment variable for api key", {
  options(openrouteservice.api_key_env = "MY_API_KEY")
  api_key_val <- "my_api_key_value"
  Sys.setenv(MY_API_KEY = api_key_val)
  expect_identical(ors_api_key(), api_key_val)
  Sys.unsetenv("MY_API_KEY")
})

## restore initial state
if ( !is.na(env) ) Sys.setenv(ORS_API_KEY = env)
if ( !is.na(key) ) keyring::key_set_with_value("openrouteservice", NULL, key)
