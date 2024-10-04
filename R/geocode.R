#' Openrouteservice Geocoding
#'
#' Resolve input coordinates to addresses and vice versa.
#'
#' This endpoint can be used for geocoding (specified `query`) and reverse
#' geocoding requests (specified `location`). Either `query` or `location` has
#' to be specified for a valid request. If both parameters are specified
#' location takes precedence.
#'
#' @param query Name of location, street address or postal code. For a
#'   structured geocoding request a named list of parameters.
#' @param location Coordinates to be inquired provided in the form `c(longitude,
#'   latitude)`
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint geocode
#' @return Geocoding: a JSON formatted list of objects corresponding to the
#'   search input. Reverse geocoding: the next enclosing object with an address
#'   tag which surrounds the given coordinate.
#' @template author
#' @examples
#' \donttest{## locations of Heidelberg around the globe
#' x <- ors_geocode("Heidelberg")
#'
#' ## set the number of results returned
#' x <- ors_geocode("Heidelberg", size = 1)
#'
#' ## search within a particular country
#' ors_geocode("Heidelberg", boundary.country = "DE")
#'
#' ## structured geocoding
#' x <- ors_geocode(list(locality="Heidelberg", county="Heidelberg"))
#'
#' ## reverse geocoding
#' location <- x$features[[1L]]$geometry$coordinates
#' y <- ors_geocode(location = location, layers = "locality", size = 1)}
#' @export
ors_geocode <- function(query,
                        location,
                        ...,
                        api_key = ors_api_key(),
                        output = c("parsed", "text", "sf")) {
  endpoint <-
    if ( missing(query) ) {
      if ( missing(location) )
        stop('Specify at least one of the arguments "query/location"')
      params <- list(point.lon = location[1L], point.lat = location[2L], ...)
      "reverse"
    }
    else {
      if ( length(query) > 1L ) {
        if ( !is.list(query) )
          query <- as.list(query)
        params <- c(query, ...)
        "search/structured"
      }
      else {
        params <- list(text = query, ...)
        "search"
      }
    }

  output <- match.arg(output)

  api_call(c("geocode", endpoint),
           api_key = api_key,
           query = params,
           output = output)
}
