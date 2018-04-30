#' Openrouteservice Matrix
#'
#' Obtain one-to-many, many-to-one and many-to-many matrices for time and distance.
#'
#' @param locations List of `longitude, latitude` coordinate pairs
#' @param profile Route profile, defaults to `driving-car`.
#' @template args
#' @templateVar dotsargs parameters
#' @templateVar endpoint matrix
#' @return Duration or distance matrix for mutliple source and destination points.
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
                       ...,
                       parse_output = NULL) {
  if (missing(locations))
    stop('Missing argument "locations"')

  profile = match.arg(profile)

  query = list(locations = locations, profile = profile, ...)

  api_call("matrix", "GET", query, parse_output = parse_output)
}
