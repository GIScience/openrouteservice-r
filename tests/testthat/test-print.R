context("Print method")

l <- list(x = 1:3, y = letters[1:3])
obj <- structure(l, class = c("endpoint", "ors_api", class(l)))

test_that("Output has expected formatting", {
  expect_known_output(obj, "print.txt", print = TRUE)
})

null_dev <- function() if (on_os("windows")) "NUL" else "/dev/null"

test_that("Print invisibly returns its argument", {
  sink(null_dev())
  x <- withVisible(print(obj))
  sink()
  expect_identical(x$value, obj)
  expect_false(x$visible)
})
