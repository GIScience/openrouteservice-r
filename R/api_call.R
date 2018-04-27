#' @importFrom jsonlite toJSON
api_query <- function(query, collapse) {
  # limit precision of numeric parametrs to 6 decimal places
  query = rapply(query, how="replace", f = function(x) {
    if (is.numeric(x))
      round(x, digits=6L)
    else
      x
  })

  # encode longitude and latitude as comma-separated pairs
  coordinatesQuery <- function(x) {
    ul = unlist(x)
    v = c(TRUE, FALSE)
    paste(ul[v], ul[!v], sep=",")
  }
  if ( !is.null(query$locations) )
    query$locations = coordinatesQuery(query$locations)
  if ( !is.null(query$coordinates) )
    query$coordinates = coordinatesQuery(query$coordinates)

  if ( !is.null(query$options) )
    query$options = toJSON(query$options, auto_unbox=TRUE)

  query = rapply(query, how="replace", f = function(x) {
    if (length(x) > 1L)
      paste(x, collapse=collapse)
    else
      x
  })

  if ( !is.null(query$options) )
    query$options = toJSON(query$options, auto_unbox=TRUE)

  c(api_key = ors_api_key(), query)
}

#' @importFrom httr content http_error http_type modify_url status_code
#' @importFrom httr GET POST accept user_agent
#' @importFrom jsonlite fromJSON
#' @importFrom geojson as.geojson
#' @importFrom geojsonlint geojson_validate
#' @importFrom xml2 read_xml
api_call <- function(path, method, query = list(), ...,
                     response_format = c("json", "xml"),
                     parse_output = NULL, simplifyMatrix = TRUE) {

  response_format <- match.arg(response_format)
  type <- sprintf("application/%s", response_format)

  collapse = ifelse (startsWith(path, 'geocode'), ',', '|')

  url <- modify_url(url = getOption('openrouteservice.url'),
                    path = path,
                    query = api_query(query, collapse=collapse))

  res <- do.call(method, list(url, accept(type), user_agent("openrouteservice-r"), ...))

  if (http_type(res) != type)
    stop(sprintf("API did not return %s", response_format), call. = FALSE)

  if (http_error(res))
    stop(
      sprintf(
        "openrouteservice API request failed [%s]:\n%s",
        status_code(res),
        fromJSON(content(res, "text"), simplifyVector=TRUE)$error
      ),
      call. = FALSE
    )

  if (is.null(parse_output))
    parse_output <- getOption("penrouteservice.parse_output", TRUE)
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
      ## TODO: validate against the GPX schema
      read_xml(chr)
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
#' `print.ors_api` uses [str][utils::str()] to compactly display the structure of the openrouteservice API response object.
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
