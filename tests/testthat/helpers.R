sys_name <- function() tolower(Sys.info()[["sysname"]])

on_os <- function(name) isTRUE(tolower(name) == sys_name())

mock_response <- function(status = 200L, ...) {
  structure(
    list(
      status_code = as.integer(status),
      ...
    ),
   class = "response"
  )
}

counter <- list()

mock_method <- function(..., timeframe = 2, n = 1) {
  cur_time <- Sys.time()
  if ( length(counter) )
    counter <<- counter[-sapply(counter, difftime, cur_time, units="sec") < timeframe]

  counter <<- c(counter, as.list(cur_time))

  if ( length(counter) > n)
    mock_response(429L)
  else
    mock_response(200L)
}
