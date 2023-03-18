#' Create NTD download URL
#'
#' `get_ntd_url()` returns a URL needed to download to data from the NTD website
#'
#' @param data_type Type of NTD data. Either "raw" for data released without adjustments or "adjusted" for data with adjustments.
#'
#' @return A string containing the URL to download the Excel file of the NTD data.
#' @export
#'
#' @examples
#' get_ntd_url()
get_ntd_url <- function(data_type = "adjusted") {
  # check for invalid parameters
  if (!data_type %in% c("raw", "adjusted")) {
    stop("Invalid parameter for data_type. Only `raw` and `adjusted` are allowed.")
  }
  if (data_type == "raw") {
    page_url <-
      "https://www.transit.dot.gov/ntd/data-product/monthly-module-raw-data-release"
  }
  if (data_type == "adjusted") {
    page_url <-
      "https://www.transit.dot.gov/ntd/data-product/monthly-module-adjusted-data-release"
  }
  ntd_page <- rvest::read_html(page_url)
  ntd_url <- ntd_page |>
    rvest::html_element(".file--x-office-spreadsheet a") |>
    rvest::html_attr("href")
  paste0("https://www.transit.dot.gov", ntd_url)
}
