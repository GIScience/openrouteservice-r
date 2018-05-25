mock_response <- function(status = 200L, ...) {
  res <- list(status_code = as.integer(status), ...)
  class(res) <- "response"
  res
}

mock_method <- function(..., timeframe = 2, n = 1) {
  cur_time <- Sys.time()
  if ( !exists("counter") )
    counter <<- list()
  else
    counter <<- counter[-sapply(counter, difftime, cur_time, units="sec") < timeframe]

  counter <<- c(counter, as.list(cur_time))

  if ( length(counter) > n)
    mock_response(429L)
  else
    mock_response(200L)
}
