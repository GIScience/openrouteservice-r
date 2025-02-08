#' API key management
#'
#' Get/set openrouteservice API key.
#'
#' To set the key provide it in the `key` argument. To retrieve the current
#' value call the function with `key` unset.
#'
#' Typically the key is saved in the system credential store. Once the key is
#' defined, it persists in the keyring store of the operating system so it
#' doesn't need to be set again in a new R session.
#'
#' Internally the function uses `\link[keyring]{key_set}` and
#' `\link[keyring]{key_get}`. The use of keyring package can be bypassed by
#' providing the key in the environment variable ORS_API_KEY. The value from the
#' environment variable takes precedence over the value stored in the system
#' credential store. The default environment variable name used to retrieve the
#' openrouteservice api key can be overridden by specifying it in
#' `options("openrouteservice.api_key_env")`.
#'
#' @param key API key value provided as a character scalar
#' @inheritParams keyring::key_set
#' @return API Key value when called without `key`.
#' @template author
#' @importFrom keyring key_list key_get key_list key_set_with_value
#' @export
ors_api_key <- function (key, service = 'openrouteservice', username = NULL, keyring = NULL) {
  ## get key
  if ( missing(key) ) {
    api_key_env <- getOption("openrouteservice.api_key_env", "ORS_API_KEY")
    api_key_val <- Sys.getenv(api_key_env)
    ## api key set in environment variable takes precedence over keyring
    if ( nchar(api_key_val) )
      api_key_val
    else if ( on_cran() )
      NA
    else if ( isTRUE(grepl("^https?://api.openrouteservice.org$", ors_url())) )
      tryCatch(
        key_get(service, username, keyring),
        error = function(e)
          stop(sprintf("API key not set.\n  Get your free key at %s\n  Use `ors_api_key('<your-api-key>')` to set it", signup_url()), call. = FALSE))
  }
  ## set key
  else
    key_set_with_value(service, username, key, keyring)
}
