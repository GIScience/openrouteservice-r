#' Openrouteservice Snapping
#'
#' Snap coordinates to road network
#'
#' @template param-coordinates
#' @templateVar argname locations
#' @template param-profile
#' @param radius Maximum radius in meters around given coordinates to search for graph edges
#' @param format Response format, defaults to `"geojson"`
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint snap
#' @template return
#' @templateVar return Coordinates of snapped location(s) and distance to the original point(s)
#' @template return-text
#' @template return-parsed
#' @template return-sf
#' @examples
#' \donttest{locations <- list(
#'   c(8.669629, 49.413025),
#'   c(8.675841, 49.418532),
#'   c(8.665144, 49.415594)
#' )
#'
#' # query for locations snapped onto the OpenStreetMap road network
#' res <- ors_snap(locations, radius = 350)}
#' @template author
#' @export
ors_snap <- function(locations,
                     profile = ors_profile(),
                     radius,
                     format = c('geojson', 'json'),
                     ...,
                     api_key = ors_api_key(),
                     output = c("parsed", "text", "sf")) {
  ## required arguments with no default value
  if (missing(locations))
    stop('Missing argument "locations"')
  if (missing(radius))
    stop('Missing argument "radius"')

  ## required arguments with defaults
  profile <- match.arg(profile)
  format <- match.arg(format)
  output <- match.arg(output)

  names(locations) <- NULL

  ## request parameters
  body <- list(locations = locations, radius = radius, ...)

  api_call(
    path = c("v2/snap", profile, format),
    api_key = api_key,
    body = body,
    encode = "json",
    output = output
  )}
