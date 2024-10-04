#' Openrouteservice POIs
#'
#' Search for points of interest around points or in geometries.
#'
#' There are three different request types: `pois`, `stats` and `list`.
#'
#' `pois` returns a GeoJSON FeatureCollection in the bounding box specified in
#' `geometry$bbox` or a GeoJSON geometry provided in `geometry$geojson`. `stats`
#' does the same but groups by categories, ultimately returning a JSON object
#' with the absolute numbers of POIs of a certain group.
#'
#' `list` returns a list of category groups and their ids.
#' @param request One of the following: `"pois"`, `"stats"` or `"list"`
#' @param geometry named list containing either a `geojson` geometry object
#'   (GeoJSON Point, LineString or Polygon) or a `bbox`, optionally buffered by
#'   a value provided  `buffer`
#' @template param-common
#' @templateVar dotsargs request attributes
#' @templateVar endpoint pois
#' @template return
#' @templateVar return A list of points of interest in the area specified in `geometry`
#' @template return-text
#' @template return-parsed
#' @template return-sf
#' @templateVar valid_for `request = "pois"`
#' @examples
#' \donttest{# POI categories list
#' ors_pois('list')
#'
#' # POIs around a buffered point
#' geometry <- list(geojson = list(type = "Point",
#'                                 coordinates = c(8.8034, 53.0756)),
#'                 buffer = 100)
#' ors_pois(geometry = geometry)
#'
#' # alternative specification via bounding box
#' ors_pois(geometry = list(bbox = list(c(8.8034, 53.0756), c(8.8034, 53.0756)),
#'                          buffer = 100))
#'
#' # POIs of given categories
#' ors_pois(geometry = geometry,
#'          limit = 200,
#'          sortby = "distance",
#'          filters = list(
#'            category_ids = c(180, 245)
#'          ))
#'
#' # POIs of given category groups
#' ors_pois(geometry = geometry,
#'          limit = 200,
#'          sortby = "distance",
#'          filters = list(
#'            category_group_ids = 160
#'          ))
#'
#' # POI Statistics
#' ors_pois("stats", geometry = geometry)}
#' @template author
#' @export
ors_pois <- function(request = c('pois', 'stats', 'list'),
                     geometry,
                     ...,
                     api_key = ors_api_key(),
                     output = c("parsed", "text", "sf")) {
  request <- match.arg(request)
  output <- match.arg(output)

  if (request!="pois" && output=="sf")
    stop('"sf" output available only for request type "pois"')

  dots <- list(...)

  if (!is.null(dots[["filters"]]))
    dots[["filters"]] <- protect(dots[["filters"]])

  body <- c(request = request, dots)

  if (request!="list") {
    if (missing(geometry))
      stop('Missing argument "geometry"')
    else
      body$geometry <- geometry
  }

  api_call(
    "pois",
    api_key = api_key,
    body = body,
    encode = "json",
    output = output
  )
}
