test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("agency accepts character vector of length > 1 as input",
          {expect_no_error(
            get_ntd(agency = c("City of Madison",
                               "Capital Area Transportation Authority")
            )
          )})

test_that("column names are correct",
          {expect_equal(colnames(get_ntd()),

                        c(
                          "ntd_id_5",
                          "ntd_id_4",
                          "agency",
                          "active",
                          "reporter_type",
                          "uza",
                          "uza_name",
                          "modes",
                          "tos",
                          "month",
                          "value"
                        ))})
