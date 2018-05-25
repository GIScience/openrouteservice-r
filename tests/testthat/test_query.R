context("Construct query")

## record current state before starting any tests
opts <- options()

## restore initial state
on.exit(options(opts), add = TRUE)

test_that("Encode pairs", {
  expect_error(encode_pairs(1:3))
  expect_identical(encode_pairs(list(1:2, 3:4)), c("1,2", "3,4"))
})

test_that("Collapse vectors", {
  x = 1:3
  expect_identical(collapse_vector(x), "1|2|3")
  expect_identical(collapse_vector(x, ","), "1,2,3")
  x = as.list(x)
  expect_identical(collapse_vector(x), x)
})

collapse_vector <- function(x, collapse = "|") {
  if (!is.list(x) && length(x) > 1L)
    paste(x, collapse=collapse)
  else
    x
}
