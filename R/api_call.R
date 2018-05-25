collapse_vector <- function(x, collapse = "|") {
  if (!is.list(x) && length(x) > 1L)
    paste(x, collapse=collapse)
  else
    x
}

# encode pairs as comma-separated strings
encode_pairs <- function(x) {
  x = unlist(x)
  if ( length(x) %% 2L )
    stop("Failed to encode pairs, odd number of elements")
  v = c(TRUE, FALSE)
  paste(x[v], x[!v], sep=",")
}

#' @importFrom jsonlite toJSON
api_query <- function(api_key, params = list(), collapse = "|") {
  ## process parameters
  if ( length(params) ) {
    # limit precision of numeric parameters to 6 decimal places
    params = rapply(params, how="replace", f = function(x) {
      if (is.numeric(x))
        round(x, digits=6L)
      else
        x
    })

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
      params$options = toJSON(params$options, auto_unbox=TRUE)
  }

  c(api_key = api_key, params)
}


#' @importFrom httr GET POST accept modify_url user_agent status_code
call_api <- function (method, url, response_format, ...) {
  method <- match.fun(method)
  type <- sprintf("application/%s", response_format)
  args <- list(url, accept(type), user_agent("openrouteservice-r"), ...)

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


api_call <- function(path, method, query, ...,
                     response_format = c("json", "xml"),
                     parse_output = NULL, simplifyMatrix = TRUE) {

  response_format <- match.arg(response_format)

  url <- construct_url(path, query)

  res <- call_api(method, url, response_format, ...)

  process_response(res, path, response_format, parse_output, simplifyMatrix)
}

#' @importFrom httr modify_url
construct_url <- function(path, query) {
  url <- getOption('openrouteservice.url', "https://api.openrouteservice.org")
  modify_url(url, path = path, query = query)
}

#' @importFrom httr content http_error http_type status_code
#' @importFrom jsonlite fromJSON
#' @importFrom geojson as.geojson
#' @importFrom geojsonlint geojson_validate
#' @importFrom xml2 read_xml xml_validate
process_response <- function(res, path, response_format, parse_output, simplifyMatrix) {
  if (http_error(res))
    stop(
      sprintf(
        "openrouteservice API request failed\n[%s] %s",
        status_code(res),
        fromJSON(content(res, "text"), simplifyVector=TRUE)$error
      ),
      call. = FALSE
    )

  if (http_type(res) != sprintf("application/%s", response_format))
    stop(sprintf("API did not return %s", response_format), call. = FALSE)

  if (is.null(parse_output))
    parse_output <- getOption("openrouteservice.parse_output", TRUE)
  parse_output <- isTRUE(parse_output)

  chr <- content(res, "text")

  if (parse_output) {
    if (response_format=="json") {
      parsed <- fromJSON(chr,
                         simplifyVector = TRUE,
                         simplifyDataFrame = FALSE,
                         simplifyMatrix = simplifyMatrix)
      structure(parsed, class = c(sprintf("ors_%s", path), "ors_api", class(parsed)))

    }
    else {
      xml <- read_xml(chr)
      gpx_xsd = getOption("openrouteservice.gpx_xsd", "https://raw.githubusercontent.com/GIScience/openrouteservice-schema/master/gpx/v1/ors-gpx.xsd")
      xsd <- read_xml(gpx_xsd)
      if (!xml_validate(xml, xsd))
        stop("Failed to validate GPX response")
      xml
    }
  }
  else {
    if (response_format=="json") {
      class(chr) <- "json"
      if ( isTRUE(geojson_validate(chr)) )
        chr <- as.geojson(chr)
    }
    chr
  }
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
