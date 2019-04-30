# collapse vectors to (pipe-separated) strings
collapse_vector <- function(x, collapse = "|") {
  if (!is.list(x) && length(x) > 1L)
    paste(x, collapse=collapse)
  else
    x
}

# encode pairs as comma-separated strings
encode_pairs <- function(x) {
  x = unlist(x, use.names = FALSE)
  if ( length(x) %% 2L )
    stop("Failed to encode pairs, odd number of elements")
  v = c(TRUE, FALSE)
  paste(x[v], x[!v], sep=",")
}

# reduce precision of numeric parameters to 6 decimal places
limit_precision <- function(l, digits) {
  rapply(l, how="replace", f = function(x) {
    if ( is.numeric(x) && !is.integer(x) )
      round(x, digits=digits)
    else
      x
  })
}

#' @importFrom jsonlite toJSON
api_query <- function(api_key, params = list(), collapse = "|") {
  ## process parameters
  if ( length(params) ) {
    digits <- getOption('openrouteservice.digits', 6L)

    params <- limit_precision(params, digits)

    # encode lists of pairs
    pair_params = c("locations", "coordinates", "bearings")
    pair_params = pair_params[pair_params %in% names(params)]

    if ( length(pair_params)>0L )
      params[pair_params] = lapply(params[pair_params], encode_pairs)

    # store polygon coordinates to preserve their original structure
    avoid_polygons = params$options$avoid_polygons

    params = rapply(params, collapse_vector, how="replace", collapse=collapse)

    if ( !is.null(avoid_polygons) )
      params$options$avoid_polygons = avoid_polygons

    if ( !is.null(params$options) )
      params$options = toJSON(params$options, auto_unbox=TRUE, digits=digits)
  }

  c(api_key = api_key, params)
}


#' @importFrom httr GET POST accept modify_url user_agent status_code
call_api <- function (method, args) {
  method <- match.fun(method)
  sleep_time <- 1L
  while (TRUE) {
    res <- do.call(method, args)
    if ( status_code(res) == 429L )
      Sys.sleep( (sleep_time <- sleep_time * 2L) )
    else
      break
  }
  res
}

ors_url <- function() {
  getOption('openrouteservice.url', "https://api.openrouteservice.org")
}

ors_path <- function(endpoint) {
  default_paths <- list (
    directions = "v2/directions",
    isochrones = "v2/isochrones",
    matrix = "v2/matrix",
    geocode = "geocode",
    pois = "pois",
    elevation = "elevation"
  )
  if (missing(endpoint))
    return(default_paths)

  ## path from options overrides the default
  path <- getOption('openrouteservice.paths')[[endpoint]]
  if (!is.null(path))
    path
  else
   default_paths[[endpoint]]
}

#' @importFrom httr modify_url parse_url verbose
api_call <- function(method, path, query, ...,
                     response_format = c("json", "geojson", "gpx"),
                     output, simplifyMatrix = TRUE) {

  response_format <- match.arg(response_format)

  endpoint <- basename(path[1L])
  path[1L] <- ors_path(endpoint)

  ## extract base path from url in order to retain it in modify_url(), see #46
  path <- paste0(parse_url(ors_url())$path, path, collapse="/")

  url <- modify_url(ors_url(), path = path, query = query)

  type <- sprintf("application/%s", switch(response_format, "json", geojson="geo+json", gpx="gpx+xml"))

  args <- list(url = url,
               accept(type),
               user_agent("openrouteservice-r"),
               ...,
               if (isTRUE(getOption('openrouteservice.verbose'))) verbose())

  res <- call_api(method, args)

  process_response(res, endpoint, output, simplifyMatrix)
}

#' @importFrom httr content http_error http_type status_code
process_response <- function(res, endpoint, output, simplifyMatrix) {
  if (http_error(res)) {
    err <- fromJSON(content(res, "text"), simplifyVector=TRUE)
    if (!is.null(err$error))
      err <- err$error
    tmp <- "openrouteservice API request failed\n[%s] %s"
    msg <-
    if ( length(err)==1L )
      sprintf(tmp, status_code(res), err)
    else
      sprintf(tmp, status_code(err$code), err$message)
    stop(msg, call. = FALSE)
  }

  format <- res$request$headers[["Accept"]]

  if (http_type(res) != format)
    stop(sprintf("API did not return %s", format), call. = FALSE)

  query_time <- unname(res$times["total"])

  format <- switch(format, "application/gpx+xml"="xml", "json")

  res <- parse_content(content(res, "text"), format, output, endpoint, simplifyMatrix)

  attr(res, "query_time") <- query_time

  res
}

#' @importFrom geojson as.geojson
#' @importFrom geojsonlint geojson_validate
#' @importFrom geojsonsf geojson_sf
#' @importFrom jsonlite fromJSON
#' @importFrom xml2 read_xml xml_validate
parse_content <- function (content,
                           format = c("json", "xml"),
                           output = c("parsed", "text", "sf"),
                           endpoint, simplifyMatrix) {
  format <- match.arg(format)
  output <- match.arg(output)

  parseJSON <- function(txt,
                        simplifyVector = TRUE,
                        simplifyDataFrame = FALSE,
                        simplifyMatrix = TRUE,
                        ...)
    fromJSON(txt,
             simplifyVector = simplifyVector,
             simplifyDataFrame = simplifyDataFrame,
             simplifyMatrix = simplifyMatrix,
             ...)

  ## raw text output
  if (output=="text") {
    if (format=="json") {
      content <- structure(content, class = "json")
      if ( isTRUE(geojson_validate(content)) )
        content <- as.geojson(content)
    }
    return(content)
  }

  ## parsed R list
  if (output=="parsed") {
    if (format=="json") {
      content <- parseJSON(content, simplifyMatrix = simplifyMatrix)
      class <- c(sprintf("ors_%s", endpoint), "ors_api", class(content))
      content <- structure(content, class = class)
      return(content)
    }
    if (format=="xml") {
      content <- read_xml(content)
      gpx_xsd = getOption("openrouteservice.gpx_xsd", "https://raw.githubusercontent.com/GIScience/openrouteservice-schema/master/gpx/v2/ors-gpx.xsd")
      xsd <- read_xml(gpx_xsd)
      if (!xml_validate(content, xsd))
        stop("Failed to validate GPX response")
      return(content)
    }
  }

  if (format=="json" && output=="sf") {
    if (endpoint=="elevation")
      content <- content$geometry

    ## convert parsed properties to sf compatible data.frame
    properties <- lapply(parseJSON(content)$features, function(feature) {
      prop_list <- lapply(feature[['properties']],
                          function(x) if (length(x) > 1L) list(x) else x)
      structure(prop_list, class = "data.frame", row.names = 1L)
    })

    properties = do.call(rbind, properties)
    content <- geojson_sf(content)
    content[names(properties)] <- properties

    return(content)
  }

  stop(sprintf("Unsupported %s output for %s format.", output, format))
}

#' Print a Compact Summary of the API Response
#'
#' `print.ors_api` uses [str][utils::str()] to compactly display the structure
#' of the openrouteservice API response object.
#'
#' @param x object of class `ors_api`.
#' @inheritParams utils::str
#' @param ... further arguments passed to [str][utils::str()].
#' @return `print.ors_api` prints its argument and returns it _invisibly_.
#' @importFrom utils str
#' @export
print.ors_api <- function(x, give.attr = FALSE, list.len = 6L, ...) {
  cat(sprintf("<%s>\n", class(x)[1L]))
  str(x, list.len = list.len, give.attr = give.attr, ...)
  invisible(x)
}
