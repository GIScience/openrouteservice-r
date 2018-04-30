#' Openrouteservice Directions
#'
#' Get directions for different modes of transport.
#'
#' @param coordinates List of `longitude, latitude` coordinate pairs visited in
#'   order.
#' @template param-profile
#' @param format Response format, defaults to `"json"`
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint directions
#' @return Route between two or more locations for a selected profile and its
#'   settings as GeoJSON response.
#' @examples
#' coordinates = list(c(8.34234, 48.23424), c(8.34423, 48.26424))
#'
#' # simple call
#' ors_directions(coordinates, preference="fastest")
#'
#' #customized options
#' ors_directions(coordinates, profile="cycling-mountain", elevation=TRUE, format="geojson")
#' @template author
#' @export
ors_directions <- function(coordinates,
                           profile = c('driving-car', 'driving-hgv', 'cycling-regular', 'cycling-road', 'cycling-safe', 'cycling-mountain', 'cycling-tour', 'cycling-electric', 'foot-walking', 'foot-hiking', 'wheelchair'),
                           format = c('json', 'geojson', 'gpx'),
                           ...,
                           parse_output = NULL) {
  if (missing(coordinates))
    stop('Missing argument "coordinates"')

  profile = match.arg(profile)

  format = match.arg(format)
  response_format = switch(format, 'gpx'='xml', 'json')

  if (format=='gpx')
    parse_output = FALSE

  query = list(coordinates = coordinates, profile = profile, format = format, ...)

  api_call("directions", "GET", query, response_format = response_format, parse_output = parse_output)
}
