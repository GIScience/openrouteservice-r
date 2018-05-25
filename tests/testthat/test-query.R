context("Construct query")

## record current state before starting any tests
opts <- options()

## restore initial state
on.exit(options(opts), add = TRUE)

test_that("Encode pairs", {
  expect_identical(encode_pairs(list(1:2, 3:4)), c("1,2", "3,4"))
  expect_error(encode_pairs(1:3))
})

test_that("Collapse vectors but not lists", {
  x = 1:3
  expect_identical(collapse_vector(x, ","), "1,2,3")
  x = as.list(x)
  expect_identical(collapse_vector(x), x)
})

x <- 0.123456789
y <- 123.456789
z <- 123456789L

obj <- list(x, y, list(c(x, y), list(z)))

xx <- 0.123457

res <- list(xx, y, list(c(xx, y), list(z)))

test_that("Limit numerical precision of non-integer numbers", {
  expect_identical(limit_precision(obj), res)
})

