#' API key management
#'
#' Get/set the API key to openrouteservice.
#'
#' To set the key provide it in the `key` argument. To retrieve the current value call the function with `key` unset.
#'
#' @return API Key value when called without `key`.
#' @param key API key value provided as a character scalar
#' @importFrom keyring key_list key_get key_list key_set_with_value
#' @inheritParams keyring::key_set
#' @template author
#' @export
ors_api_key <- function (key, service = 'openrouteservice', username = NULL, keyring = NULL) {
  if ( missing(key) )
    if ( toString(username) %in% key_list(service, keyring)$username )
      key_get(service, username, keyring)
    else
      stop("API key not set. Use `ors_api_key('<your-api-key>')` to set it first.", call. = FALSE)
  else
    key_set_with_value(service, username, key, keyring)
}
