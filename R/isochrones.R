#' Openrouteservice Isochrones
#'
#' Obtain areas of reachability from given locations.
#'
#' The Isochrone Service supports time and distance analyses for one single or
#' multiple locations. You may also specify the isochrone interval or provide
#' multiple exact isochrone range values.
#'
#' @template param-coordinates
#' @templateVar argname locations
#' @template param-profile
#' @param range Maximum range value of the analysis in seconds for time and
#'   meters for distance. Alternatively a comma separated list of specific
#'   single range values.
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint isochrones
#' @template return
#' @templateVar return A GeoJSON object containing a FeatureCollection of Polygons
#'   corresponding to the accessible area,
#' @template return-text
#' @template return-parsed
#' @template return-sf
#' @examples
#' \donttest{ors_isochrones(c(8.34234, 48.23424), interval=20)
#'
#' locations <- list(c(8.681495, 49.41461), c(8.686507,49.41943))
#' ors_isochrones(locations, range=c(300, 200))}
#' @template author
#' @export
ors_isochrones <- function(locations,
                           profile = ors_profile(),
                           range = 60,
                           ...,
                           api_key = ors_api_key(),
                           output = c("parsed", "text", "sf")) {

  ## required arguments with no default value
  if (missing(locations))
    stop('Missing argument "locations"')

  ## required arguments with defaults
  profile <- match.arg(profile)
  output <- match.arg(output)

  ## wrap single point coordinate pairs into list
  if (is.vector(locations) && is.atomic(locations))
    locations <- list(locations)

  names(locations) <- NULL

  ## request parameters
  body <- protect(list(locations = locations, range = range, ...),
                  arrays = c("attributes", "range"))

  api_call(
    path = c("v2/isochrones", profile),
    api_key = api_key,
    body = body,
    encode = "json",
    response_format = "geojson",
    output = output,
    simplifyMatrix = FALSE
  )
}
