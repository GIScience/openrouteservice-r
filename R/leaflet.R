#' Set Bounds of a Map Widget
#'
#' Helper function to set the bounds of a leaflet map widget.
#'
#' @inherit leaflet::fitBounds params return
#' @param bbox A vector `c(lng1, lat1, lng2, lat2)` specifying the bounding box
#'   coordinates
#' @importFrom leaflet fitBounds
#' @template author
#' @export
fitBBox <- function(map, bbox) {
  if (is.null(bbox))
    return(map)
  do.call(fitBounds, c(list(map), bbox))
}
