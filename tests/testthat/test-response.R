context("Process response")

mock_error <- mock_response(
  status = 400L,
  headers = list("Content-Type" = "application/json;charset=UTF-8"),
  content = charToRaw(toJSON(list(error = list(code = 123L, message = "Error message"))))
)

test_that("Error response", {
  expect_error(process_response(mock_error))
})
