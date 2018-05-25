context("Print method")

source("helpers.R")

l <- list(x = 1:3, y = letters[1:3])
obj <- structure(l, class = c("endpoint", "ors_api", class(l)))

test_that("Print", {
  expect_known_output(obj, "print.txt", print = TRUE)
  ## test for print return value?
})
