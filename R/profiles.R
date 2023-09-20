#' Openrouteservice Profiles
#'
#' List of available modes of transport.
#'
#' Convenience function for specifying the profile in [ors_directions()],
#' [ors_isochrones()] and [ors_matrix()].
#'
#' @param mode Profile label.
#' @return Profile name, or named vector of available profiles.
#' @examples
#' # list availbale profiles
#' ors_profile()
#'
#' # retrieve full profile name based on label
#' ors_profile("car")
#' @seealso [ors_directions()], [ors_isochrones()], [ors_matrix()]
#' @template author
#' @export
ors_profile <- function(mode = c("car", "hgv", "bike", "roadbike", "mtb", "e-bike", "walking", "hiking", "wheelchair")) {
  profiles <- c(
    `car` = 'driving-car',
    `hgv` = 'driving-hgv',
    `bike` = 'cycling-regular',
    `roadbike` = 'cycling-road',
    `mtb` = 'cycling-mountain',
    `e-bike` = 'cycling-electric',
    `walking` = 'foot-walking',
    `hiking`= 'foot-hiking',
    `wheelchair` = 'wheelchair'
  )

  if (missing(mode))
   profiles
  else
   profiles[[match.arg(mode)]]
}
