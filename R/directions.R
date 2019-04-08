#' Openrouteservice Directions
#'
#' Get directions for different modes of transport.
#'
#' @param coordinates List of `longitude, latitude` coordinate pairs visited in
#'   order.
#' @template param-profile
#' @param format Response format, defaults to `"geojson"`
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
#' # customized options
#' ors_directions(coordinates, profile="cycling-mountain", elevation=TRUE)
#' @template author
#' @export
ors_directions <- function(coordinates,
                           profile = ors_profile(),
                           format = c('geojson', 'json', 'gpx'),
                           ...,
                           api_key = ors_api_key(),
                           parse_output = NULL) {

  ## required arguments with no default value
  if (missing(coordinates))
    stop('Missing argument "coordinates"')

  ## required arguments with defaults
  profile <- match.arg(profile)
  format <- match.arg(format)

  ## request parameters
  if (is.data.frame(coordinates))
    coordinates <- as.matrix(coordinates)

  body <- list(coordinates = coordinates, ...)

  api_call(method = "POST",
           path = c("v2/directions", profile, format),
           query = NULL,
           add_headers(Authorization = api_key),
           body = body,
           encode = "json",
           response_format = format,
           parse_output = parse_output)
}
