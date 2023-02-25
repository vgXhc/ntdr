
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ntdr: Retrieve data from the National Transit Database

<!-- badges: start -->
<!-- badges: end -->

The `ntdr` package provides a convenient interface to retrieve monthly
data from the National Transit Database (NTD). Without this package,
getting NTD data involves going to the NTD website and downloading and
processing a complex Excel workbook.

## Installation

You can install the development version of ntdr from Github:

``` r
devtools::install_github()
```

## Example

Basic usage:

``` r
library(ntdr)
ntd_madison <- get_ntd(data_type = "adjusted", ntd_variable = "UPT", agency = "City of Madison", modes = "MB")
head(ntd_madison)
#> # A tibble: 6 × 12
#>   5 digit…¹ 4 dig…² Agency Active Repor…³   UZA UZA N…⁴ Modes TOS   month  value
#>       <dbl> <chr>   <chr>  <chr>  <chr>   <dbl> <chr>   <chr> <chr> <chr>  <dbl>
#> 1     50005 5005    City … Active Full R…    92 Madiso… MB    DO    JAN02 8.66e5
#> 2     50005 5005    City … Active Full R…    92 Madiso… MB    DO    FEB02 1.05e6
#> 3     50005 5005    City … Active Full R…    92 Madiso… MB    DO    MAR02 9.63e5
#> 4     50005 5005    City … Active Full R…    92 Madiso… MB    DO    APR02 1.03e6
#> 5     50005 5005    City … Active Full R…    92 Madiso… MB    DO    MAY02 8.56e5
#> 6     50005 5005    City … Active Full R…    92 Madiso… MB    DO    JUN02 6.25e5
#> # … with 1 more variable: date <date>, and abbreviated variable names
#> #   ¹​`5 digit NTD ID`, ²​`4 digit NTD ID`, ³​`Reporter Type`, ⁴​`UZA Name`
```

The data are returned in a long format, which makes it easy to create
plots and do other cool things:

``` r
library(ggplot2)
get_ntd(agency = c("City of Madison", "Capital Area Transportation Authority"), modes = "MB") |> 
  dplyr::filter(TOS == "DO") |> 
  ggplot(aes(date, value, color = Agency)) +
  geom_line() +
  labs(title = "Monthly unlinked passenger trips in Madison and Lansing")
```

<img src="man/figures/README-ridership-chart-1.png" width="100%" />

This package is still heavily under development and not ready for
production use. NTD data has many quirks, and so please use it with
care.
