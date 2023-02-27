Agency <- month <- TOS <- Modes <- NULL

#' Get NTD data
#'
#' @param agency Name of the transit agency to retrieve. Defaults to `all` agencies
#' @param data_type Type of NTD data. Either "raw" for data released without adjustments or "adjusted" for data with adjustments.
#' @param ntd_variable Which variable to return. `UPT` for unlinked passenger trips, `VRM` for vehicle revenue miles, `VRH` for vehicle revenue hours, or `VOMS` for vehicles operated in maximum service.
#' @param modes Transit mode to retrieve. Common modes include `MB` (bus), `CR` (commuter rail), `HR` (heavy rail), `LR` (light rail). Defaults to `all` modes.
#' @param cache Cache downloaded data. Defaults to `FALSE`.
#'
#' @return A data frame of monthly NTD data with the requested ntd_variable in the `value` column
#' @export
#'
#' @examples get_ntd(agency = "City of Madison", modes = c("MB", "DR"))

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
      } else
        all_data
    }
    ntd_tempfile_name <- "ntd_download.xlsx"
    ntd_tempfile_path <- paste0(tempdir(), "/", ntd_tempfile_name)

    # logic for caching files
    if (cache == TRUE) {
      # check if cache file doesn't exist
      if (!file.exists(ntd_tempfile_path) ) {
        utils::download.file(get_ntd_url(data_type), ntd_tempfile_path, mode = "wb")
      }
        #else do nothing

    } else { #if cache isn't set to TRUE
      utils::download.file(get_ntd_url(data_type), ntd_tempfile_path, mode = "wb")
    }



    all_data <- readxl::read_excel(ntd_tempfile_path, sheet = sheet)

    #filter data to agency if agency parameter is provided
    all_data <- filter_all_data(filter_var = "Agency", filter_param = agency)
    all_data <- filter_all_data(filter_var = "Modes", filter_param = modes)

    #filter and pivot data
    all_data |>
      tidyr::pivot_longer(
        cols = 10:ncol(all_data),
        names_to = "month",
        values_to = "value"
      ) |>
      dplyr::mutate(date = lubridate::my(month))
  }


