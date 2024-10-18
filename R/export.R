#' Openrouteservice Export
#'
#' Export the base graph for different modes of transport.
#'
#' @template param-coordinates
#' @templateVar argname bbox
#' @templateVar suffix defining the SW and NE corners of a rectangular area of interest
#' @template param-profile
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint export
#' @template return
#' @templateVar return Lists of graph nodes and edges contained in the provided bounding box and relevant for the given routing profile. The edge property `weight` represents travel time in seconds. The response is 
#' @template return-text
#' @template return-parsed
#' @examples
#' \dontrun{
#' bbox <- list(
#'   c(8.681495, 49.41461),
#'   c(8.686507, 49.41943)
#' )
#' 
#' res <- ors_export(bbox)
#' }
#' @template author
#' @export
ors_export <- function(bbox,
                       profile = ors_profile(),
                       ...,
                       api_key = ors_api_key(),
                       output = c("parsed", "text")) {
  ## required arguments with no default value
  if (missing(bbox))
    stop('Missing argument "bbox"')
  
  ## required arguments with defaults
  profile <- match.arg(profile)
  output <- match.arg(output)
  
  ## request parameters
  body <- list(bbox = bbox, ...)
  
  api_call(
    path = c("v2/export", profile),
    api_key = api_key,
    body = body,
    encode = "json",
    output = output
  )
}
