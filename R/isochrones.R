#' Openrouteservice Isochrones
#'
#' Obtain areas of reachability from given locations.
#'
#' The Isochrone Service supports time and distance analyses for one single or
#' multiple locations. You may also specify the isochrone interval or provide
#' multiple exact isochrone range values.
#'
#' @param locations List of `longitude, latitude` coordinate pairs
#' @template param-profile
#' @param range Maximum range value of the analysis in seconds for time and
#'   meters for distance. Alternatively a comma separated list of specific
#'   single range values.
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint isochrones
#' @return A GeoJSON object containing a FeatureCollection of Polygons
#'   corresponding to the accessible area.
#' @examples
#' ors_isochrones(c(8.34234, 48.23424), interval=20)
#' @template author
#' @export
ors_isochrones <- function(locations,
                           profile = c('driving-car', 'driving-hgv', 'cycling-regular', 'cycling-road', 'cycling-safe', 'cycling-mountain', 'cycling-tour', 'foot-walking', 'foot-hiking'),
                           range = 60,
                           service = "openrouteservice", username = NULL, keyring = NULL,
                           ...,
                           parse_output = NULL) {
  if (missing(locations))
    stop('Missing argument "locations"')

  profile = match.arg(profile)

  query = list(locations = locations, profile = profile, range = range, ...)

  res = api_call("isochrones", "GET", query, simplifyMatrix=FALSE, parse_output = parse_output,
                 service=service, username=username, keyring=keyring)

  if (inherits(res, "ors_api"))
    res$info$query$ranges = as.numeric(unlist(strsplit(res$info$query$ranges, ",")))

  res
}
