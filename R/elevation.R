#' Openrouteservice Elevation
#'
#' Get elevation data for points or lines
#'
#' A GeoJSON based service to query SRTM elevation for Point or LineString 2D
#' geometries and return 3D geometries in various formats.
#'
#' @param geometry `longitude, latitude` coordinate pairs
#' @param format_in input format
#' @param format_out output format
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint elevation
#' @template return
#' @templateVar return 3D point or line geometry
#' @template return-text
#' @template return-parsed
#' @template return-sf
#' @examples
#' \donttest{# point coordinates
#' coordinates <- c(13.349762, 38.11295)
#' ors_elevation("point", coordinates)
#'
#' # geojson as input
#' point <- '{ "type": "Point", "coordinates": [13.349762, 38.11295] }'
#' ors_elevation("geojson", point)
#'
#' # line geometry returned as encoded polyline
#' coordinates <- list(
#'   c(13.349762, 38.11295),
#'   c(12.638397, 37.645772)
#' )
#' ors_elevation("polyline", coordinates, format_out = "encodedpolyline")}
#' @template author
#' @importFrom httr add_headers
#' @export
ors_elevation <- function(format_in = c("geojson", "point", "polyline", "encodedpolyline", "encodedpolyline6"),
                          geometry,
                          format_out = format_in,
                          ...,
                          api_key = ors_api_key(),
                          output = c("parsed", "text", "sf")) {

  ## required arguments with no default value
  if (missing(format_in))
    stop('Missing input format specification')
  if (missing(geometry))
    stop('geometry')

  format_in <- match.arg(format_in)

  ## check whether geojson is a point or a line
  if (format_in == "geojson") {
    geometry <- fromJSON(geometry)
    input <- geometry$type
  } else {
    names(geometry) <- NULL
    if (format_in=="point")
      geometry <- as.vector(geometry)
    input <- format_in
  }

  endpoint <- switch(tolower(input),
                     point = "point",
                     polyline =, encodedpolyline =, encodedpolyline6 = "line")

  ## required arguments with defaults
  valid_formats <- switch (endpoint,
                           point = c("point"),
                           line = c("polyline", "encodedpolyline", "encodedpolyline6"))
  format_out <- match.arg(format_out, c("geojson", valid_formats))
  output <- match.arg(output)

  body <- list(format_in = format_in,
               geometry = geometry,
               format_out = format_out,
               ...)

  api_call(path = c("elevation", endpoint),
           api_key = api_key,
           body = body,
           encode = "json",
           output = output)
}
