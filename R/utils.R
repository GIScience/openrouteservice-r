# protect vectors of length 1 from unboxing when converting to JSON
protect <- function(args, arrays) {
  names <- names(args)
  if (missing(arrays))
    arrays <- names
  array_args <- names %in% arrays
  if (any(array_args))
    args[array_args] <- lapply(args[array_args], I)

  # call recursively
  lists <- !array_args & vapply(args, is.list, logical(1L), USE.NAMES = FALSE)
  arrays <- arrays[!(arrays %in% names)]
  if (any(lists) && length(arrays)>0L)
    args[lists] <- lapply(args[lists], protect, arrays)

  args
}
