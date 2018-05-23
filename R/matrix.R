#' Openrouteservice Matrix
#'
#' Obtain one-to-many, many-to-one and many-to-many matrices for time and
#' distance.
#'
#' @param locations List of `longitude, latitude` coordinate pairs
#' @template param-profile
#' @param metrics Returned metrics. Use `"distance"` for distance matrix in
#'   defined `units`, and/or `duration`` for time matrix in seconds.
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
                       profile = c('driving-car', 'driving-hgv', 'cycling-regular', 'cycling-road', 'cycling-safe', 'cycling-mountain', 'cycling-tour', 'cycling-electric', 'foot-walking', 'foot-hiking', 'wheelchair'),
                       metrics = c('distance', 'duration'),
                       service = "openrouteservice", username = NULL, keyring = NULL,
                       ...,
                       parse_output = NULL) {
  if (missing(locations))
    stop('Missing argument "locations"')

  profile = match.arg(profile)

  metrics = match.arg(metrics, several.ok=TRUE)
  metrics = collapse_vector(metrics)

  body = list(locations = locations, profile = profile, metrics = metrics, ...)

  api_call("matrix", "POST", body = body, encode = "json", parse_output = parse_output,
           service=service, username=username, keyring=keyring)
}
