#' @title Geographical outline of Norway with 500 m buffer.
#'
#' @description A special features object describing a polygon with the geographical
#'     outline of Norway mainland with a buffer of 500 meter.
#' @details The polygon is used as input to `is_it_in_Norway` to check if a geo
#'     location is situated on land in Norway. The outline of Norway mainland has
#'     been increased with a buffer of 500 m to ensure that that minor inaccuracies
#'     in the geo locations do not invalidate the geo coordinates. A test using
#'     farmer locations in Norway shows that for this purpose, a buffer of 500 m
#'     is suited to differentiate between farmers with geo coordinates on
#'     Norwegian mainland or outside.
#'
#' The outline of Norway is constructed by combining  the country border and
#'     the coast line into a polygon. The resolution of the source files is based
#'     on the N500 series.
#'
#' @source "./data-raw/generate_Norway_with_buffer" in package `NVIspatial`.
"Norway_with_buffer_500"
