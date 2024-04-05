agency <- month <- ntd_id_5 <- NULL

#' Get NTD data
#'
#' @param agency Name of the transit agency to retrieve. Defaults to `all` agencies
#' @param data_type Type of NTD data. Either "raw" for data released without adjustments or "adjusted" for data with adjustments and estimates
#' @param ntd_variable Which variable to return. `UPT` for unlinked passenger trips, `VRM` for vehicle revenue miles, `VRH` for vehicle revenue hours, or `VOMS` for vehicles operated in maximum service.
#' @param modes Transit mode to retrieve. Common modes include `MB` (bus), `CR` (commuter rail), `HR` (heavy rail), `LR` (light rail). Defaults to `all` modes.
#' @param cache Cache downloaded data. Defaults to `FALSE`.
#'
#' @return A data frame of monthly NTD data with the requested ntd_variable in the `value` column
#' @export
#'
#' @examplesIf interactive()
#' get_ntd(agency = "City of Madison", modes = c("MB", "DR"))
get_ntd <-
  function(agency = "all",
           data_type = "adjusted",
           ntd_variable = "UPT",
           modes = "all",
           cache = FALSE) {
    sheet <- dplyr::case_when(
      ntd_variable == "UPT" ~ 3,
      ntd_variable == "VRM" ~ 4,
      ntd_variable == "VRH" ~ 5,
      ntd_variable == "VOMS" ~ 6
    )
    # function to filter data depending on parameters
    filter_all_data <- function(filter_var, filter_param) {
      # if someone provided multiple values with "all" not being the first one, this wouldn't return all values. Maybe fix later
      if (filter_param[1] != "all") {
        filter_var <- as.symbol(filter_var)
        all_data |>
          dplyr::filter(!!filter_var %in% filter_param)
      } else {
        all_data
      }
    }
    ntd_tempfile_name <- paste0("ntd_download_", data_type, ".xlsx")
    ntd_tempfile_path <- paste0(tempdir(), "/", ntd_tempfile_name)

    # logic for caching files
    if (cache == TRUE) {
      # check if cache file doesn't exist
      if (!file.exists(ntd_tempfile_path)) {
        utils::download.file(get_ntd_url(data_type), ntd_tempfile_path, method = "curl")
      }
      # else do nothing
    } else {
      # if cache isn't set to TRUE
      utils::download.file(get_ntd_url(data_type), ntd_tempfile_path, method = "curl")
    }

    # to read in spreadsheet we need to determine its number of columns
    get_spreadsheet_ncol <- function(ntd_tempfile_path,
                                     sheet) {
      dummy_sheet <- readxl::read_xlsx(ntd_tempfile_path,
                                       sheet = sheet,
                                       skip = 9,
                                       n_max = 1
      )
      ncol(dummy_sheet) - 10 # subtract first 12 columns
    }

    # adds a month to a date and returns data as character vector
    add_a_month <- function(x) {
      start_date <- lubridate::ymd("2002-01-01") # first date reported in NTD
      lubridate::month(start_date) <- x
      as.character(start_date)
    }

    # column names for monthly values
    monthly_col_names <-
      purrr::map_chr(
        1:get_spreadsheet_ncol(ntd_tempfile_path, sheet),
        add_a_month
      )

    ntd_cols <- c(
      "ntd_id_5",
      "ntd_id_4",
      "agency",
      "active",
      "reporter_type",
      "uace",
      "uza_name",
      "modes",
      "tos",
      "modes_simplified",
      monthly_col_names
    )

    all_data <- readxl::read_excel(
      ntd_tempfile_path,
      sheet = sheet,
      skip = 1,
      col_names = ntd_cols
    ) |>
      dplyr::filter(!is.na(ntd_id_5)) #remove summary rows at end of sheet


    # filter data to agency if agency parameter is provided
    all_data <-
      filter_all_data(filter_var = "agency", filter_param = agency)
    all_data <-
      filter_all_data(filter_var = "modes", filter_param = modes)

    # pivot data
    all_data <- all_data |>
      tidyr::pivot_longer(
        cols = 11:ncol(all_data),
        names_to = "month",
        values_to = "value"
      ) |>
      dplyr::mutate(
        month = lubridate::ymd(month),
        ntd_variable = ntd_variable
      )

    all_data
  }



# retrieve URL for downloading NTD data
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

  #tests for functioning internet connection
  can_ntd_be_reached <- gracefully_fail("https://www.transit.dot.gov/ntd/data-product/monthly-module-raw-data-release")
  if (is.null(can_ntd_be_reached)) {
    stop()
  }
  ntd_page <- httr::GET(page_url) |>
    rvest::read_html()
  ntd_url <- ntd_page |>
    rvest::html_element(".file--x-office-spreadsheet a") |>
    rvest::html_attr("href")
  paste0("https://www.transit.dot.gov", ntd_url)
}

# retrieve archived NTD data pin from board
# # for future version
# retrieve_pin <- function(ntd_variable, data_type){
#   stopifnot("The archived data cannot be reached. Check your internet connection, try again later, or set `cache = FALSE`." = check_board_status())
#   ntdr_board <- pins::board_url("https://ntdr-pins.s3.us-west-2.amazonaws.com/")
# }
