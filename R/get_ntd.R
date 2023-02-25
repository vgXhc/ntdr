Agency <- month <- NULL

#' Get NTD data
#'
#' @param data_type Type of NTD data. Either "raw" for data released without adjustments or "adjusted" for data with adjustments.
#' @param ntd_variable Which variable to return. `UPT` for unlinked passenger trips, `VRM` for vehicle revenue miles, `VRH` for vehicle revenue hours, or `VOMS` for vehicles operated in maximum service.
#' @param agency Name of the transit agency to retrieve.
#' @param modes Transit mode to retrieve. Common modes include `MB` (bus), `CR` (commuter rail), `HR` (heavy rail), `LR` (light rail)
#'
#' @return A data frame of monthly NTD data with the requested ntd_variable in the `value` column
#' @export
#'
#' @examples get_ntd(agency = "City of Madison", modes = c("MB", "DR"))

get_ntd <- function(data_type = "adjusted", ntd_variable = "UPT", agency, modes = "MB") {
  sheet <- dplyr::case_when(
    ntd_variable == "UPT" ~ 3,
    ntd_variable == "VRM" ~ 4,
    ntd_variable == "VRH" ~ 5,
    ntd_variable == "VOMS" ~ 6
  )
  ntd_temp <- tempfile()
  utils::download.file(get_ntd_url(data_type), ntd_temp, mode = "wb")

  all_data <- readxl::read_excel(ntd_temp, sheet = sheet)
  all_data |>
    dplyr::filter(Agency %in% agency & modes %in% modes) |>
    tidyr::pivot_longer(cols = 10:ncol(all_data), names_to = "month", values_to = "value") |>
    dplyr::mutate(date = lubridate::my(month))
}
