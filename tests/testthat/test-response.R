context("Process response")

mock_error <- mock_response(
  status = 400L,
  headers = list("Content-Type" = "application/json;charset=UTF-8"),
  content = charToRaw(toJSON(list(error = list(code = 123L, message = "Error message"))))
)

test_that("Error response", {
  expect_error(process_response(mock_error))
})

mock_gpx <- paste(readLines("mock_gpx.xml"), collapse = "\n")

mock_xml <- mock_response(
  headers = list("Content-Type" = "application/xml;charset=UTF-8"),
  request = list(headers = list(Accept = "application/xml")),
  content = charToRaw(mock_gpx)
)

test_that("Parsed GPX response", {
  expect_equal(process_response(mock_xml, parse_output = TRUE), read_xml(mock_gpx))
})

test_that("Unparsed GPX response", {
  expect_identical(process_response(mock_xml, parse_output = FALSE), mock_gpx)
})
