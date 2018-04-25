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
#' @importFrom httr GET POST accept_json user_agent
#' @importFrom jsonlite fromJSON
api_call <- function(path, method, query = list(), ..., simplifyMatrix = TRUE) {
  collapse = ifelse (startsWith(path, 'geocode'), ',', '|')

  url <- modify_url(url = getOption('openrouteservice.url'),
                    path = path,
                    query = api_query(query, collapse=collapse))

  res <- do.call(method, list(url, accept_json(), user_agent("openrouteservice-r"), ...))

  if (http_type(res) != 'application/json')
    stop("API did not return json", call. = FALSE)

  parsed <- fromJSON(content(res, "text"),
                     simplifyVector = TRUE,
                     simplifyDataFrame = FALSE,
                     simplifyMatrix = simplifyMatrix)

  if (http_error(res))
    stop(
      sprintf(
        "openrouteservice API request failed [%s]:\n%s",
        status_code(res),
        parsed$error$message
      ),
      call. = FALSE
    )

  structure(parsed, class = c(sprintf("ors_%s", path), "ors_api", class(parsed)))
}

#' Print a Compact Summary of the API Response
#'
#' `print.ors_api`` uses [str][utils::str()] to compactly display the structure of the openrouteservice API response object.
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
