#' Openrouteservice Optimization
#'
#' Optimize a fleet of vehicles on a number of jobs. For more information, see
#' the
#' \href{https://github.com/VROOM-Project/vroom/blob/master/docs/API.md}{Vroom
#' project API documentation}.
#' @param jobs `data.frame` describing the places to visit
#' @param vehicles `data.frame` describing the available vehicles
#' @param matrix Optional two-dimensional array describing a custom travel-time
#'   matrix
#' @template param-common
#' @templateVar dotsargs parameters
#' @templateVar endpoint optimization
#' @template return
#' @templateVar return Solution computed by the optimization endpoint formatted as described \href{https://github.com/VROOM-Project/vroom/blob/master/docs/API.md#output}{here} and
#' @template return-text
#' @template return-parsed
#' @examples
#' \donttest{home_base <- c(2.35044, 48.71764)
#'
#' vehicles <- vehicles(
#'   id = 1:2,
#'   profile = "driving-car",
#'   start = home_base,
#'   end = home_base,
#'   capacity = 4,
#'   skills = list(c(1, 14), c(2, 14)),
#'   time_window = c(28800, 43200)
#' )
#'
#' locations <- list(
#'   c(1.98935, 48.701),
#'   c(2.03655, 48.61128),
#'   c(2.39719, 49.07611),
#'   c(2.41808, 49.22619),
#'   c(2.28325, 48.5958),
#'   c(2.89357, 48.90736)
#' )
#'
#' jobs <- jobs(
#'   id = 1:6,
#'   service = 300,
#'   amount = 1,
#'   location = locations,
#'   skills = list(1, 1, 2, 2, 14, 14)
#' )
#'
#' ors_optimization(jobs, vehicles)}
#' @template author
#' @export
ors_optimization <- function(jobs,
                             vehicles,
                             matrix = NULL,
                             ...,
                             api_key = ors_api_key(),
                             output = c("parsed", "text")) {
  ## required arguments with no default value
  if (missing(jobs))
    stop('Missing required argument "jobs"')
  if (missing(vehicles))
    stop('Missing required argument "vehicles"')

  ## required arguments with defaults
  output <- match.arg(output)

  if (!is.null(matrix))
    matrix <- apply(matrix, c(1,2), as.integer)

  ## request parameters
  body <- protect(
    list(jobs = as_list(jobs), vehicles = as_list(vehicles), matrix = matrix, ...),
    arrays = c(
      "location",
      "amount",
      "skills",
      "time_windows",
      "start",
      "end",
      "capacity",
      "time_window"
    )
  )

  api_call(
    path = "optimization",
    api_key = api_key,
    body = body,
    encode = "json",
    output = output
  )
}

#' @rdname ors_optimization
#' @description The helper functions `jobs()` and `vehicles()` create
#'   data.frames which can be used as arguments to `ors_optimization()`.
#' @param id An integer used as unique identifier
#' @param location Coordinates array
#' @param location_index Index of relevant row and column in custom matrix
#' @param service Job service duration (defaults to 0)
#' @param amount An array of integers describing multidimensional quantities
#' @param skills An array of integers defining skills
#' @param priority An integer in the \[0, 10\] range describing priority level
#'   (defaults to 0)
#' @param time_windows An array of time_window objects describing valid slots
#'   for job service start
#' @export
jobs <- function(id, location, location_index, service, amount, skills, priority, time_windows) {
  n <- length(id)
  args <- list(
    id = id,
    location = if (!missing(location)) expand(location, n, TRUE),
    location_index = if (!missing(location_index)) expand(location_index, n, FALSE),
    service = if (!missing(service)) expand(service, n, FALSE),
    amount = if (!missing(amount)) expand(amount, n, TRUE),
    skills = if (!missing(skills)) expand(skills, n, TRUE),
    priority = if (!missing(priority)) expand(priority, n, FALSE),
    time_windows = if (!missing(time_windows)) expand(time_windows, n, TRUE)
  )
  construct_df(args)
}

#' @rdname ors_optimization
#' @param profile routing profile (defaults to car)
#' @param start coordinates array
#' @param start_index index of relevant row and column in custom matrix
#' @param end coordinates array
#' @param end_index index of relevant row and column in custom matrix
#' @param capacity an array of integers describing multidimensional quantities
#' @param time_window a time_window object describing working hours
#' @export
vehicles <- function(id, profile, start, start_index, end, end_index, capacity, skills, time_window) {
  n <- length(id)
  args <- list(
    id = id,
    profile = if (!missing(profile)) expand(profile, n, FALSE),
    start = if (!missing(start)) expand(start, n, TRUE),
    start_index = if (!missing(start_index)) expand(start_index, n, FALSE),
    end = if (!missing(end)) expand(end, n, TRUE),
    end_index = if (!missing(end_index)) expand(end_index, n, FALSE),
    capacity = if (!missing(capacity)) expand(capacity, n, TRUE),
    skills = if (!missing(skills)) expand(skills, n, TRUE),
    time_window = if (!missing(time_window)) expand(time_window, n, TRUE)
  )
  construct_df(args)
}
