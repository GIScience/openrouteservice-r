# protect vectors of length 1 from unboxing when converting to JSON
protect <- function(args, arrays) {
  names <- names(args)
  if (missing(arrays))
    arrays <- names

  array_args <-
    if (is.null(names))
      rep_len(FALSE, length(args))
    else
      names %in% arrays

  if (any(array_args)) {
    args[array_args] <- lapply(args[array_args], I)
    arrays <- arrays[!(arrays %in% names)]
  }

  # call recursively
  lists <- !array_args & vapply(args, is.list, logical(1L), USE.NAMES = FALSE)

  if (any(lists) && length(arrays)>0L)
    args[lists] <- lapply(args[lists], protect, arrays)

  args
}

# convert a data frame to list-based representation to be serialized to JSON
as_list <- function(x) {
  if (is.data.frame(x)) {
    # go from data frame to nested list
    json <- toJSON(x, auto_unbox = FALSE, digits = 16)
    list <- fromJSON(json, simplifyDataFrame = FALSE)
    # remove any missing values
    x <- lapply(list, compact)
  }
  x
}

construct_df <- function(args) {
  args <- compact(args)
  structure(
    args,
    names = names(args),
    class = "data.frame",
    row.names = 1:length(args[[1]])
  )
}

expand <- function(x, n, is_vector) {
  if (is_vector) {
    if (!is.list(x))
      x <- list(x)
    else if (is.data.frame(x)) {
      x <- as.matrix(x)
      x <- lapply(1:nrow(x), function(i) unname(x[i,]))
    }
  }
  rep_len(x, n)
}

compact <- function (x) {
  empty <- vapply(x, is_empty, logical(1L))
  x[!empty]
}

is_empty <- function(x) {
  length(x) == 0
}
