library(magrittr)
library(NVIdb)

filename <- "" # fill in pathname
Norway <- sf::st_read(filename)

proj_str <- 'PROJCS["ETRS89 / UTM zone 33N",GEOGCS["ETRS89",
                            DATUM["European_Terrestrial_Reference_System_1989",
                            SPHEROID["GRS 1980",6378137,298.257222101,
                            AUTHORITY["EPSG","7019"]],
                            TOWGS84[0,0,0,0,0,0,0],
                            AUTHORITY["EPSG","6258"]],
                            PRIMEM["Greenwich",0,
                            AUTHORITY["EPSG","8901"]],
                            UNIT["degree",0.0174532925199433,
                            AUTHORITY["EPSG","9122"]],
                            AUTHORITY["EPSG","4258"]],
                            PROJECTION["Transverse_Mercator"],
                            PARAMETER["latitude_of_origin",0],
                            PARAMETER["central_meridian",15],
                            PARAMETER["scale_factor",0.9996],
                            PARAMETER["false_easting",500000],
                            PARAMETER["false_northing",0],
                            UNIT["metre",1,
                            AUTHORITY["EPSG","9001"]],
                            AXIS["Easting",EAST],
                            AXIS["Northing",NORTH],
                            AUTHORITY["EPSG","25833"]]'

Norway_with_buffer_500 = Norway %>%
  sf::st_transform(crs = proj_str) %>%
  sf::st_buffer(500)

# SAVE IN PACKAGE DATA ----
usethis::use_data(name = Norway_with_buffer_500, overwrite = TRUE, internal = FALSE, compress = "xz")
