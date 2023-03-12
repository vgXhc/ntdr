
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ntdr: Retrieve data from the National Transit Database

<!-- badges: start -->
<!-- badges: end -->

The `ntdr` package provides a convenient interface to retrieve monthly
data from the National Transit Database (NTD). Without this package,
getting NTD data involves going to the NTD website and downloading and
processing a complex Excel workbook.

This package was mainly written for my own use, is still under
development and NTD data has many quirks. Please use it with care and
feel report to [report any
issues](https://github.com/vgXhc/ntdr/issues).

To learn more about the package, visit the package website:
<https://vgxhc.github.io/ntdr/>.

## Installation

You can install the development version of ntdr from Github:

``` r
remotes::install_github("https://github.com/vgXhc/ntdr")
```

## Example

Basic usage:

``` r
library(ntdr)
ntd_madison <- get_ntd(data_type = "adjusted", ntd_variable = "UPT", agency = "City of Madison", modes = "MB")
#> New names:
#> • `2033379` -> `2033379...24`
#> • `2033379` -> `2033379...26`
head(ntd_madison)
#> # A tibble: 6 × 11
#>   ntd_id_5 ntd_id_4 agency   active repor…¹   uza uza_n…² modes tos   month     
#>   <chr>    <chr>    <chr>    <chr>  <chr>   <dbl> <chr>   <chr> <chr> <date>    
#> 1 50005    5005     City of… Inact… Full R…    92 Madiso… MB    DO    2002-01-01
#> 2 50005    5005     City of… Inact… Full R…    92 Madiso… MB    DO    2002-02-01
#> 3 50005    5005     City of… Inact… Full R…    92 Madiso… MB    DO    2002-03-01
#> 4 50005    5005     City of… Inact… Full R…    92 Madiso… MB    DO    2002-04-01
#> 5 50005    5005     City of… Inact… Full R…    92 Madiso… MB    DO    2002-05-01
#> 6 50005    5005     City of… Inact… Full R…    92 Madiso… MB    DO    2002-06-01
#> # … with 1 more variable: value <dbl>, and abbreviated variable names
#> #   ¹​reporter_type, ²​uza_name
```
