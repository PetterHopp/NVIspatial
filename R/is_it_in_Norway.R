#' @title Checks if the geo-location is within Norway
#' @description Checks if the geo location of a pair of geo coordinates, is within Norway.
#'
#' @details AS default, the check is performed towards a polygon with the shape
#'     of the Norwegian land area with buffer of 500 m. The polygon is based on
#'     the Norwegian country borders and coastline in N500. This should be sufficient
#'     accurate for checking farms, but will not be sufficient for checking all
#'     kinds of buildings, in particular buildings that can be expected to be
#'     situated on small islands.
#'
#' The check is intended for geo-locations on land, not in the sea. However,
#'     by changing the input to polygon, the check can be performed towards other
#'     areas. The input needs to be a special features object.
#'
#' To return a data frame with the invalid geo coordinates
#'     set to NA, use `valid = FALSE` and `set_to_NA = TRUE`. If you
#'     would like to inspect the invalid geo coordinates, use `valid = TRUE`
#'     and `set_to_NA = FALSE`.
#'
#' @param data \[\code{data.frame}\]\cr
#' Input data with location information that should be checked.
#' @param coordinates \[\code{character}\]\cr
#' Vector with the column names or the position numbers of the columns with the
#'     geo coordinates in data. The order of the geo coordinates should be given
#'     as c("longitude", "latitude").
#' @param input_projection the projection of the geo locations that should be checked.
#' @param polygon \[\code{sf}\]\cr
#' The polygon that you want to check if the geo locations are
#'     within. The polygon must be given as a special feature object. Defaults to
#'     `Norway_with_buffer_500`.
#' @param polygon_projection Projection of the data defining the polygon. Defaults
#'     to the projection of `Norway_with_buffer_500`.
#' @param valid \[\code{logical} or \code{character}\]\cr
#' Should the results include a variable with information on whether the
#'     geo location were within the polygon? Defaults to `FALSE`. The name of the
#'     new column defaults to "valid_coordinate". If another name is wanted, you
#'     can use the preferred column name as input argument.
#' @param set_to_NA \[\code{logical}\]\cr
#' Should the invalid geo coordinates be set to `NA`? Defaults to `TRUE`.
#'
#' @return A data frame. If `set_to_NA = TRUE` the geo coordinates that is
#'     outside Norway is set to `NA`. If `valid = TRUE`, a column named
#'     "valid_coordinate" (or the name you choose), is added and the observations
#'     are given the value 1 if the coordinate is within Norway and 0 if not.
#'
#' @export
#' @examples
#' \dontrun{
#' library(NVIspatial)
#' library(dplyr)
#' library(sf)
#'
#' geolocations <- data.frame(
#'   "eier_lokalitetnr" = c("1", "2", "3"),
#'   "geo_eu89_o" = c("5.3105549", "0.3105549", NA),
#'   "geo_eu89_n" = c("60.3551767", "60.3551767", NA))
#'
#' geolocations <- is_it_in_Norway(data = geolocations,
#'                                 coordinates = c("geo_eu89_o", "geo_eu89_n"),
#'                                 polygon = Norway_with_buffer_500,
#'                                 valid = TRUE,
#'                                 set_to_NA = FALSE)
#'
#' geolocations <- is_it_in_Norway(data = geolocations,
#'                                 coordinates = c("geo_eu89_o", "geo_eu89_n"),
#'                                 polygon = Norway_with_buffer_500,
#'                                 valid = "valid_coordinate_500",
#'                                 set_to_NA = FALSE)
#' }
#'
is_it_in_Norway <- function(data,
                            coordinates,
                            input_projection = 4326,
                            polygon = NVIspatial::Norway_with_buffer_500,
                            polygon_projection = paste('PROJCS["ETRS89 / UTM zone 33N",GEOGCS["ETRS89",',
                                                       'DATUM["European_Terrestrial_Reference_System_1989",',
                                                       'SPHEROID["GRS 1980",6378137,298.257222101,',
                                                       'AUTHORITY["EPSG","7019"]],',
                                                       'TOWGS84[0,0,0,0,0,0,0],',
                                                       'AUTHORITY["EPSG","6258"]],',
                                                       'PRIMEM["Greenwich",0,',
                                                       'AUTHORITY["EPSG","8901"]],',
                                                       'UNIT["degree",0.0174532925199433,',
                                                       'AUTHORITY["EPSG","9122"]],',
                                                       'AUTHORITY["EPSG","4258"]],',
                                                       'PROJECTION["Transverse_Mercator"],',
                                                       'PARAMETER["latitude_of_origin",0],',
                                                       'PARAMETER["central_meridian",15],',
                                                       'PARAMETER["scale_factor",0.9996],',
                                                       'PARAMETER["false_easting",500000],',
                                                       'PARAMETER["false_northing",0],',
                                                       'UNIT["metre",1,',
                                                       'AUTHORITY["EPSG","9001"]],',
                                                       'AXIS["Easting",EAST],',
                                                       'AXIS["Northing",NORTH],',
                                                       'AUTHORITY["EPSG","25833"]]'),
                            valid = FALSE,
                            set_to_NA = TRUE) {

  # ARGUMENT CHECKING ----
  # Object to store check-results
  checks <- checkmate::makeAssertCollection()
  # Perform checks

  # data
  checkmate::assert_data_frame(data, null.ok = FALSE, add = checks)
  # coordinates
  checkmate::assert_subset(coordinates, choices = colnames(data), empty.ok = FALSE, add = checks)
  # input_projection
  checkmate::assert(checkmate::check_integerish(input_projection, lower = 0, upper = 999999, len = 1, any.missing = FALSE),
                    checkmate::check_string(input_projection),
                    combine = "or",
                    add = checks)
  # shape
  checkmate::assert_data_frame(polygon, null.ok = FALSE, add = checks)
  # shape_projection
  checkmate::assert(checkmate::check_integerish(polygon_projection, lower = 0, upper = 999999, len = 1, any.missing = FALSE),
                    checkmate::check_string(polygon_projection),
                    combine = "or",
                    add = checks)
  # valid
  checkmate::assert(checkmate::check_flag(valid),
                    checkmate::check_character(valid, min.chars = 1, len = 1, any.missing = FALSE),
                    combine = "or",
                    add = checks)
  # set_to_NA
  checkmate::assert_flag(set_to_NA, add = checks)

  # Report check-results
  checkmate::reportAssertions(checks)

  valid_name <- "valid_coordinate"
  if (class(valid) == "character") {
    valid_name <- valid
    valid <- TRUE
  }
  # FIND GEO-LOCATIONS WITHIN NORWAY ----
  # Make new data frame with geo-coordinates to generate spatial information, transform missing to 0
  xydata <- as.data.frame(data[, coordinates])
  xydata[which(is.na(xydata[, 1])), 1] <- 0
  xydata[which(is.na(xydata[, 2])), 2] <- 0

  # Transform points to geographical information
  xydata <- sf::st_as_sf(xydata, coords = c(1, 2), crs = sf::st_crs(input_projection))
  xydata <- sf::st_transform(xydata, crs = polygon_projection)

  # Check if points within polygon
  xydata$valid_coordinate <- sf::st_intersects(xydata, polygon)
  xydata$valid_coordinate <- lengths(xydata$valid_coordinate)
  xydata[which(xydata$valid_coordinate > 0), "valid_coordinate"] <- 1
  ## in case the polygon file should include geo-location (0, 0)
  xydata[which(is.na(data[, coordinates[1]]) | is.na(data[, coordinates[2]])), "valid_coordinate"] <- 0

  # REPORTS RESULT IN ACCORD WITH INPUT ----
  if (set_to_NA == TRUE) {
    data[which(xydata$valid_coordinate == 0), coordinates[1]] <- NA
    data[which(xydata$valid_coordinate == 0), coordinates[2]] <- NA
  }

  if (isTRUE(valid)) {
    data[, valid_name] <- xydata$valid_coordinate
  }

  return(data)
}
