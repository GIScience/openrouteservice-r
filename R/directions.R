#' Openrouteservice Directions
#'
#' Get directions for different modes of transport.
#'
#' @param coordinates List of `longitude, latitude` coordinate pairs visited in
#'   order.
#' @param profile Route profile, defaults to `driving-car`.
#' @template dotsargs
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
                           ...) {
  if (missing(coordinates))
    stop('Missing argument "coordinates"')

  profile = match.arg(profile)

  query = list(coordinates = coordinates, profile = profile, ...)

  api_call("directions", "GET", query)
}
