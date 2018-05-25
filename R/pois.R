#' Openrouteservice POIs
#'
#' Search for points of interest around points or in geometries.
#'
#' There are three different request types: `pois`, `stats` and `list`.
#'
#' `pois` returns a GeoJSON FeatureCollection in the specified bounding box or
#' geometry. `stats` does the same but groups by categories, ultimately
#' returning a JSON object with the absolute numbers of POIs of a certain group.
#'
#' `list` returns a list of category groups and their ids.
#' @param request One of the following: `"pois"`, `"stats"` or `"list"`
#' @param geometry GeoJSON geometry object (Point, Linestring or Polygon)
#' @template param-common
#' @templateVar dotsargs request attributes
#' @templateVar endpoint pois
#' @return A list of points of interest in the area specified in `geometry`.
#' @examples
#' ors_pois('list')
#' @template author
#' @export
ors_pois <- function(request = c('pois', 'stats', 'list'),
                     geometry,
                     ...,
                     api_key = ors_api_key(),
                     parse_output = NULL) {
  request = match.arg(request)

  query = api_query(api_key)

  body = list(request = request, ...)

  if ( request!="list") {
    if ( missing(geometry) )
      stop('Missing argument "geometry"')
    else
      body$geometry = geometry
  }

  api_call("pois", "POST", query, body = body, encode = "json", parse_output = parse_output)
}
