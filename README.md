
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ntdr: Retrieve data from the National Transit Database

<!-- badges: start -->

[![R-CMD-check](https://github.com/vgXhc/ntdr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/vgXhc/ntdr/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/ntdr)](https://cran.r-project.org/package=ntdr)
<!-- badges: end -->

The `ntdr` package provides a convenient interface to retrieve monthly
data from the National Transit Database (NTD). Without this package,
getting NTD data involves going to the NTD website and downloading and
processing a complex Excel workbook.

The NTD data returned by this package has many quirks. Please use it
with care and [report any issues](https://github.com/vgXhc/ntdr/issues).

To learn more about the package, visit the package website:
<https://vgxhc.github.io/ntdr/>.

## Installation

``` r
# The latest stable version can be installed from CRAN:
install.packages("ntdr")


# Alternatively, install the latest development version from GitHub:
remotes::install_github("vgXhc/ntdr")
```

## Example

Basic usage:

``` r
library(ntdr)
#> Warning: package 'ntdr' was built under R version 4.2.3
ntd_madison <- get_ntd(data_type = "adjusted", ntd_variable = "UPT", agency = "City of Madison", modes = "MB")
#> New names:
#> • `22526` -> `22526...34`
#> • `22523` -> `22523...71`
#> • `22526` -> `22526...95`
#> • `23344` -> `23344...100`
#> • `22523` -> `22523...102`
#> • `23344` -> `23344...139`
#> • `19423` -> `19423...147`
#> • `19423` -> `19423...187`
head(ntd_madison)
#> # A tibble: 6 × 12
#>   ntd_id_5 ntd_id_4 agency       active reporter_type   uza uza_name modes tos  
#>   <chr>    <chr>    <chr>        <chr>  <chr>         <dbl> <chr>    <chr> <chr>
#> 1 50005    5005     City of Mad… Active Full Reporte…    92 Madison… MB    DO   
#> 2 50005    5005     City of Mad… Active Full Reporte…    92 Madison… MB    DO   
#> 3 50005    5005     City of Mad… Active Full Reporte…    92 Madison… MB    DO   
#> 4 50005    5005     City of Mad… Active Full Reporte…    92 Madison… MB    DO   
#> 5 50005    5005     City of Mad… Active Full Reporte…    92 Madison… MB    DO   
#> 6 50005    5005     City of Mad… Active Full Reporte…    92 Madison… MB    DO   
#> # ℹ 3 more variables: month <date>, value <dbl>, ntd_variable <chr>
```
