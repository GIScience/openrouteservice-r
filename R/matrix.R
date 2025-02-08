#' Openrouteservice Matrix
#'
#' Obtain one-to-many, many-to-one and many-to-many matrices for time and
#' distance.
#'
#' @template param-coordinates
#' @templateVar argname locations
#' @template param-profile
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint matrix
#' @template return
#' @templateVar return Duration or distance matrix for multiple source and destination
#'   points
#' @template return-text
#' @template return-parsed
#' @examples
#' # These examples might require interaction to query the local keyring, or
#' # might fail due to network issues, so they are not run by default
#' \dontrun{
#' coordinates <- list(
#'   c(9.970093, 48.477473),
#'   c(9.207916, 49.153868),
#'   c(37.573242, 55.801281),
#'   c(115.663757,38.106467)
#' )
#'
#' # query for duration and distance in km
#' res <- ors_matrix(coordinates, metrics = c("duration", "distance"), units = "km")
#'
#' # duration in hours
#' res$durations / 3600
#'
#' # distance in km
#' res$distances
#' }
#' @template author
#' @export
ors_matrix <- function(locations,
                       profile = ors_profile(),
                       ...,
                       api_key = ors_api_key(),
                       output = c("parsed", "text")) {

  ## required arguments with no default value
  if (missing(locations))
    stop('Missing argument "locations"')

  ## required arguments with defaults
  profile <- match.arg(profile)
  output <- match.arg(output)

  names(locations) <- NULL

  ## request parameters
  body <- protect(list(locations = locations, ...),
                  arrays = c("destinations", "metrics", "sources"))

  api_call(
    path = c("v2/matrix", profile),
    api_key = api_key,
    body = body,
    encode = "json",
    output = output
  )
}
