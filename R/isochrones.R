#' Openrouteservice Isochrones
#'
#' Obtain areas of reachability from given locations.
#'
#' The Isochrone Service supports time and distance analyses for one single or
#' multiple locations. You may also specify the isochrone interval or provide
#' multiple exact isochrone range values.
#'
#' @param locations List of `longitude, latitude` coordinate pairs
#' @param profile Route profile, defaults to `driving-car`.
#' @param range Maximum range value of the analysis in seconds for time and
#'   meters for distance. Alternatively a comma separated list of specific
#'   single range values.
#' @template dotsargs
#' @templateVar dotsargs parameters
#' @templateVar endpoint isochrones
#' @return Duration or distance matrix for mutliple source and destination
#'   points.
#' @examples
#' ors_isochrones(c(8.34234, 48.23424), interval=20)
#' @template author
#' @export
ors_isochrones <- function(locations,
                           profile = c('driving-car', 'driving-hgv', 'cycling-regular', 'cycling-road', 'cycling-safe', 'cycling-mountain', 'cycling-tour', 'foot-walking', 'foot-hiking'),
                           range = 60,
                           ...) {
  if (missing(locations))
    stop('Missing argument "locations"')

  profile = match.arg(profile)

  query = list(locations = locations, profile = profile, range = range, ...)

  res = api_call("isochrones", "GET", query, simplifyMatrix=FALSE)

  res$info$query$ranges = as.numeric(unlist(strsplit(res$info$query$ranges, ",")))

  res
}
