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
                     response_format = c("json", "geojson", "xml"),
                     parse_output = NULL, simplifyMatrix = TRUE) {

  response_format <- match.arg(response_format)

  endpoint <- basename(path[1L])
  path[1L] <- ors_path(endpoint)

  ## extract base path from url in order to retain it in modify_url(), see #46
  path <- paste0(parse_url(ors_url())$path, path, collapse="/")

  url <- modify_url(ors_url(), path = path, query = query)

  type <- sprintf("application/%s", switch(response_format, "json", geojson="geo+json", gpx="xml"))

  args <- list(url = url,
               accept(type),
               user_agent("openrouteservice-r"),
               ...,
               if (isTRUE(getOption('openrouteservice.verbose'))) verbose())

  res <- call_api(method, args)

  process_response(res, endpoint, parse_output, simplifyMatrix)
}


#' @importFrom httr content http_error http_type status_code
#' @importFrom jsonlite fromJSON
#' @importFrom geojson as.geojson
#' @importFrom geojsonlint geojson_validate
#' @importFrom xml2 read_xml xml_validate
process_response <- function(res, endpoint, parse_output, simplifyMatrix) {
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

  if (is.null(parse_output))
    parse_output <- getOption("openrouteservice.parse_output", TRUE)
  parse_output <- isTRUE(parse_output)

  query_time <- unname(res$times["total"])
  res <- content(res, "text")

  format <- switch(format, "application/xml"="xml", "json")

  if (parse_output) {
    if (format=="json") {
      res <- fromJSON(res,
                      simplifyVector = TRUE,
                      simplifyDataFrame = FALSE,
                      simplifyMatrix = simplifyMatrix)
      res <- structure(res, class = c(sprintf("ors_%s", endpoint), "ors_api", class(res)))
    }
    else if (format=="xml"){
      res <- read_xml(res)
      gpx_xsd = getOption("openrouteservice.gpx_xsd", "https://raw.githubusercontent.com/GIScience/openrouteservice-schema/master/gpx/v1/ors-gpx.xsd")
      xsd <- read_xml(gpx_xsd)
      if (!xml_validate(res, xsd))
        stop("Failed to validate GPX response")
    }
  }
  else if (format=="json") {
    res <- structure(res, class = "json")
    if ( isTRUE(geojson_validate(res)) )
      res <- as.geojson(res)
  }

  attr(res, "query_time") <- query_time

  res
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
