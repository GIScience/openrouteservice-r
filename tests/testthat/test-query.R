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

ref <- list(xx, y, list(c(xx, y), list(z)))

test_that("Limit numerical precision of non-integer numbers", {
  expect_identical(limit_precision(obj, 6L), ref)
})

v <- c(0.123456789, 0.987654321)

api_key <- "api_key"

obj <- list(
  locations = list(v),
  vector = v,
  options = list(
    scalar = "a",
    vector = v,
    avoid_polygons = list(
      type = "Polygon",
      coordinates = list(list(v, v, v))
    )
  )
)

ref <- list(
  api_key = api_key,
  locations = "0.123457,0.987654",
  vector = "0.123457|0.987654",
  options = structure('{"scalar":"a","vector":"0.123457|0.987654","avoid_polygons":{"type":"Polygon","coordinates":[[[0.123457,0.987654],[0.123457,0.987654],[0.123457,0.987654]]]}}', class = "json")
)

res <- openrouteservice:::api_query(api_key, obj)

test_that("API key is prepended to the original parameters", {
  expect_identical(names(res), c("api_key", names(obj)))
})

test_that("API key value matches", {
  expect_identical(res$api_key, api_key)
})

test_that("Coordinate pairs and vectors are properly encoded", {
  expect_identical(res$locations, ref$locations)
  expect_identical(res$vector, ref$vector)
})

test_that("Options are encoded as json", {
  expect_identical(res$options, ref$options)
})
