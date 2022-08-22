library(NVIspatial)
library(testthat)
library(tibble)

test_that("is_it_in_Norway Mark geolocations outside Norway", {
  geolocations <- data.frame(
    "eier_lokalitetnr" = c("1", "2", "3"),
    "geo_eu89_o" = c("5.3105549", "0.3105549", NA),
    "geo_eu89_n" = c("60.3551767", "60.3551767", NA))

  correct_result <- cbind(geolocations,
                          "valid_coordinate" = c(1, 0, 0))

  expect_identical(is_it_in_Norway(data = geolocations,
                                   coordinates = c("geo_eu89_o", "geo_eu89_n"),
                                   polygon = Norway_with_buffer_500,
                                   valid = TRUE,
                                   set_to_NA = FALSE),
                   correct_result)


  correct_result <- cbind(geolocations,
                          "valid_coordinate_500" = c(1, 0, 0))

  geolocations <- is_it_in_Norway(data = geolocations,
                                  coordinates = c("geo_eu89_o", "geo_eu89_n"),
                                  polygon = Norway_with_buffer_500,
                                  valid = "valid_coordinate_500",
                                  set_to_NA = FALSE)

  expect_identical(geolocations, correct_result)

  expect_identical(is_it_in_Norway(data = geolocations,
                                   coordinates = c("geo_eu89_o", "geo_eu89_n"),
                                   polygon = Norway_with_buffer_500,
                                   valid = "valid_coordinate_500",
                                   set_to_NA = FALSE),
                   correct_result)
})

test_that("is_it_in_Norway Set to NA for geolocations outside Norway", {
  geolocations <- data.frame("eier_lokalitetnr" = c("1", "2", "3"),
                             "geo_eu89_o" = c("5.3105549", "0.3105549", NA),
                             "geo_eu89_n" = c("60.3551767", "60.3551767", NA))

  correct_result <- data.frame("eier_lokalitetnr" = c("1", "2", "3"),
                               "geo_eu89_o" = c("5.3105549", NA, NA),
                               "geo_eu89_n" = c("60.3551767", NA, NA))

  expect_identical(is_it_in_Norway(data = geolocations,
                                   coordinates = c("geo_eu89_o", "geo_eu89_n"),
                                   polygon = Norway_with_buffer_500,
                                   valid = FALSE,
                                   set_to_NA = TRUE),
                   correct_result)
})


test_that("is_it_in_Norway data as tibble", {
  geolocations <- tibble("eier_lokalitetnr" = c("1", "2", "3"),
                         "geo_eu89_o" = c("5.3105549", "0.3105549", NA),
                         "geo_eu89_n" = c("60.3551767", "60.3551767", NA))

  correct_result <- tibble("eier_lokalitetnr" = c("1", "2", "3"),
                           "geo_eu89_o" = c("5.3105549", NA, NA),
                           "geo_eu89_n" = c("60.3551767", NA, NA))

  expect_identical(is_it_in_Norway(data = geolocations,
                                   coordinates = c("geo_eu89_o", "geo_eu89_n"),
                                   polygon = Norway_with_buffer_500,
                                   valid = FALSE,
                                   set_to_NA = TRUE),
                   correct_result)
})


test_that("is_it_in_Norway error testing", {
  linewidth <- options("width")
  options(width = 80)

  geolocations <- c("eier_lokalitetnr" = c("1", "2", "3"),
                    "geo_eu89_o" = c("5.3105549", "0.3105549", NA),
                    "geo_eu89_n" = c("60.3551767", "60.3551767", NA))


  expect_error(is_it_in_Norway(data = geolocations,
                               coordinates = c("geo_eu89_o", "geo_eu89_n"),
                               polygon = Norway_with_buffer_500,
                               valid = FALSE,
                               set_to_NA = TRUE),
               regexp = "Must be of type 'data.frame'")

  geolocations <- data.frame("eier_lokalitetnr" = c("1", "2", "3"),
                             "geo_eu89_o" = c("5.3105549", "0.3105549", NA),
                             "geo_eu89_n" = c("60.3551767", "60.3551767", NA))
  expect_error(is_it_in_Norway(data = geolocations,
                               coordinates = c("x", "y"),
                               polygon = Norway_with_buffer_500,
                               valid = FALSE,
                               set_to_NA = TRUE),
               regexp = "'coordinates': Must be a subset of", fixed = TRUE)

  expect_error(is_it_in_Norway(data = geolocations,
                               coordinates = c("geo_eu89_o", "geo_eu89_n"),
                               polygon = "Norway_with_buffer_500",
                               valid = FALSE,
                               set_to_NA = TRUE),
               regexp = "Must be of type 'data.frame'")

  expect_error(is_it_in_Norway(data = geolocations,
                               coordinates = c("geo_eu89_o", "geo_eu89_n"),
                               polygon = Norway_with_buffer_500,
                               valid = geolocations,
                               set_to_NA = TRUE),
               regexp = "'valid': One of the following must apply:", fixed = TRUE)

  expect_error(is_it_in_Norway(data = geolocations,
                               coordinates = c("geo_eu89_o", "geo_eu89_n"),
                               polygon = Norway_with_buffer_500,
                               valid = FALSE,
                               set_to_NA = "TRUE"),
               regexp = "'set_to_NA': Must be of type 'logical flag'", fixed = TRUE)

  options(width = unlist(linewidth))
})
