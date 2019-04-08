#' Openrouteservice Matrix
#'
#' Obtain one-to-many, many-to-one and many-to-many matrices for time and
#' distance.
#'
#' @param locations A list of `longitude, latitude` coordinate pairs, or a two column `data.frame`
#' @template param-profile
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint matrix
#' @return Duration or distance matrix for multiple source and destination
#'   points.
#' @examples
#' coordinates = list(
#'   c(9.970093, 48.477473),
#'   c(9.207916, 49.153868),
#'   c(37.573242, 55.801281),
#'   c(115.663757,38.106467)
#' )
#'
#' # query for duration and distance in km
#' res = ors_matrix(coordinates, metrics = c("duration", "distance"), units = "km")
#'
#' # duration in hours
#' res$durations / 3600
#'
#' # distance in km
#' res$distances
#' @template author
#' @export
ors_matrix <- function(locations,
                       profile = ors_profile(),
                       ...,
                       api_key = ors_api_key(),
                       parse_output = NULL) {

  ## required arguments with no default value
  if (missing(locations))
    stop('Missing argument "locations"')

  ## required arguments with defaults
  profile = match.arg(profile)

  names(locations) <- NULL

  ## request parameters
  body = list(locations = locations, profile = profile, ...)

  api_call(method = "POST",
           path = c("v2/matrix", profile),
           query = NULL,
           add_headers(Authorization = api_key),
           body = body,
           encode = "json",
           parse_output = parse_output)
}
