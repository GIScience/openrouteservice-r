#' Openrouteservice Directions
#'
#' Get directions for different modes of transport.
#'
#' @template param-coordinates
#' @templateVar argname coordinates
#' @templateVar suffix visited in order
#' @template param-profile
#' @param format Response format, defaults to `"geojson"`
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint directions
#' @template return
#' @templateVar return Route between two or more locations in the selected `format`
#' @template return-text
#' @template return-parsed
#' @template return-sf
#' @examples
#' # These examples might require interaction to query the local keyring, or
#' # might fail due to network issues, so they are not run by default
#' \dontrun{
#' coordinates <- list(c(8.34234, 48.23424), c(8.34423, 48.26424))
#'
#' # simple call
#' try( ors_directions(coordinates, preference="fastest") )
#'
#' # customized options
#' try( ors_directions(coordinates, profile="cycling-mountain", elevation=TRUE) )
#'
#' # list of locations as `data.frame` output as simple features `sf` object
#' locations <- data.frame(lng = c(8.34234, 8.327807, 8.34423),
#'                         lat = c(48.23424, 48.239368, 48.26424))
#' try( ors_directions(locations, output = "sf") )
#' }
#' @template author
#' @export
ors_directions <- function(coordinates,
                           profile = ors_profile(),
                           format = c('geojson', 'json', 'gpx'),
                           ...,
                           api_key = ors_api_key(),
                           output = c("parsed", "text", "sf")) {

  ## required arguments with no default value
  if (missing(coordinates))
    stop('Missing argument "coordinates"')

  ## required arguments with defaults
  profile <- match.arg(profile)
  format <- match.arg(format)
  output <- match.arg(output)

  ## request parameters
  names(coordinates) <- NULL
  body <- protect(
    list(coordinates = coordinates, ...),
    arrays = c(
      "attributes",
      "bearings",
      "extra_info",
      "radiuses",
      "skip_segments",
      "avoid_countries",
      "avoid_features"
    )
  )

  api_call(
    path = c("v2/directions", profile, format),
    api_key = api_key,
    body = body,
    encode = "json",
    response_format = format,
    output = output
  )
}
