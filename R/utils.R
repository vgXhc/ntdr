#function that checks if URL works and fails gracefully if not
gracefully_fail <- function(remote_file) {
  try_GET <- function(x, ...) {
    tryCatch(
      httr::GET(url = x, httr::timeout(10), ...),
      error = function(e) conditionMessage(e),
      warning = function(w) conditionMessage(w)
    )
  }
  is_response <- function(x) {
    class(x) == "response"
  }

  # First check internet connection
  if (!curl::has_internet()) {
    message("No internet connection. The package needs an internet connection to retrieve data.")
    return(invisible(NULL))
  }
  # Then try for timeout problems
  resp <- try_GET(remote_file)
  if (!is_response(resp)) {
    message(resp)
    return(invisible(NULL))
  }
  # Then stop if status > 400
  if (httr::http_error(resp)) {
    httr::message_for_status(resp)
    return(invisible(NULL))
  }

  # If you are using rvest as I do you can easily read_html in the response
  rvest::read_html(resp)

  # If none of the tests fail, return "OK" response
  return("OK")
}

#tests for functioning internet connection
test_1 <- gracefully_fail("https://www.transit.dot.gov/ntd/data-product/monthly-module-raw-data-release")
if (is.null(test_1)) {
  return(invisible(NULL))
}
