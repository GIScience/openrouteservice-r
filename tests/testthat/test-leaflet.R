context("Leaflet fitBBox")

library("leaflet")

m <- leaflet()

lng1 <- 8
lat1 <- 49
lng2 <- 9
lat2 <- 50

test_that("Equivalent to fitBounds", {
  expect_identical(fitBBox(m, c(lng1, lat1, lng2, lat2)),
                   fitBounds(m, lng1, lat1, lng2, lat2))
})

test_that("Returns unaltered map when no bbox provided", {
  expect_identical(fitBBox(m, NULL), m)
})
