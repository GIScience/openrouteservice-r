collapse_vector <- function(x, collapse = "|") {
  if (!is.list(x) && length(x) > 1L)
    paste(x, collapse=collapse)
  else
    x
}

# encode pairs as comma-separated strings
encode_pairs <- function(x) {
  ul = unlist(x)
  v = c(TRUE, FALSE)
  paste(ul[v], ul[!v], sep=",")
}

#' @importFrom jsonlite toJSON
api_query <- function(query, collapse, 
                      service = "openrouteservice", username = NULL, keyring = NULL) {
  # limit precision of numeric parameters to 6 decimal places
  query = rapply(query, how="replace", f = function(x) {
    if (is.numeric(x))
      round(x, digits=6L)
    else
      x
  })

  # encode lists of pairs
  pair_params = c("locations", "coordinates", "bearings")
  pair_params = pair_params[pair_params %in% names(query)]

  if ( length(pair_params)>0L )
    query[pair_params] = lapply(query[pair_params], encode_pairs)

  # store polygon coordinates to preserve their original structure
  avoid_polygons = query$options$avoid_polygons

  query = rapply(query, collapse_vector, how="replace", collapse=collapse)

  if ( !is.null(avoid_polygons) )
    query$options$avoid_polygons = avoid_polygons

  if ( !is.null(query$options) )
    query$options = toJSON(query$options, auto_unbox=TRUE)

  c(api_key = ors_api_key(service=service, username=username, keyring=keyring), query)
}

#' @importFrom httr status_code
rate_limited_call <- function (method, args) {
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

#' @importFrom httr content http_error http_type modify_url status_code
#' @importFrom httr GET POST accept user_agent
#' @importFrom jsonlite fromJSON
#' @importFrom geojson as.geojson
#' @importFrom geojsonlint geojson_validate
#' @importFrom xml2 read_xml xml_validate
api_call <- function(path, method, query = list(), ...,
                     response_format = c("json", "xml"),
                     parse_output = NULL, simplifyMatrix = TRUE, 
                     service = "openrouteservice", username = NULL, keyring = NULL) {

  method <- match.fun(method)
  response_format <- match.arg(response_format)
  type <- sprintf("application/%s", response_format)

  collapse = ifelse (startsWith(path, 'geocode'), ',', '|')

  url <- getOption('openrouteservice.url', "https://api.openrouteservice.org")
  url <- modify_url(url, path = path, query = api_query(query, collapse=collapse, 
                                                        service=service, username=username, keyring=keyring))

  res <- rate_limited_call(method, list(url, accept(type), user_agent("openrouteservice-r"), ...))

  if (http_error(res))
    stop(
      sprintf(
        "openrouteservice API request failed\n[%s] %s",
        status_code(res),
        fromJSON(content(res, "text"), simplifyVector=TRUE)$error
      ),
      call. = FALSE
    )

  if (http_type(res) != type)
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
