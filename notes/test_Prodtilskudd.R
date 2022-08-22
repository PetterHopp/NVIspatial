#### SET UP OF R-ENVIRONMENT ----
# Packages
library(NVIbatch)
# use_pkg("plyr")
use_pkg(pkg = c("dplyr", "geosphere", "openxlsx", "sf", "tmap"))
use_NVIverse(pkg = c("NVIdb", "NVIspatial"))

# GLOBAL VARIABLES
# Todays date in the  format yyyymmdd to be used in filenames
today<-format(Sys.Date(),"%Y%m%d")

# Load data.frame exported from PJS if not already in memory
load(file = paste0(set_dir_NVI("Prodregister"),"Radata/PJSprodusenter.Rdata") )
prodnr_2_current_prodnr <- read_prodnr_2_current_prodnr()
PTdata <- read_Prodtilskudd()
PTprodusent <- PTdata[, c("gjeldende_prodnr8", "Orgnavn")]
PTprodusent <- unique(PTprodusent)

#### SELECT ONE SET OF COORDINATES FOR Prodnr8 WHEN < 1 m DIFFERENCE IN DISTANCE BETWEEN POINTS ----
# Generates table with unique combinations of Prodnr8 and coordinates, only
Koordinater <- PJSprodusenter %>%
  select(identifikator, geo_eu89_o, geo_eu89_n) %>%
  mutate(identifikator = substr(identifikator, 1, 8)) %>%
  arrange(identifikator) %>%
  distinct()

Koordinater <- is_it_in_Norway(data = Koordinater,
                               shape = Norway_with_buffer_100,
                               coordinates = c("geo_eu89_o", "geo_eu89_n"),
                               valid = "valid_buffer_100",
                               set_to_NA = FALSE)

Koordinater <- is_it_in_Norway(data = Koordinater,
                               shape = Norway_with_buffer_500,
                               coordinates = c("geo_eu89_o", "geo_eu89_n"),
                               valid = "valid_buffer_500",
                               set_to_NA = FALSE)

ktr1 <- subset(Koordinater, Koordinater$valid_buffer_500 == 0)
ktr2 <- subset(ktr1, !is.na(ktr1$geo_eu89_o) & ktr1$geo_eu89_o >1 &
                 !is.na(ktr1$geo_eu89_n) & ktr1$geo_eu89_n >1)

ktr3 <- ktr2 %>%
  add_produsent_properties(translation_table = prodnr_2_current_prodnr,
                           code_column = c("identifikator" = "prodnr8"),
                           new_column = "gjeldende_prodnr8",
                           impute_old_when_missing = TRUE) %>%
  left_join(PTprodusent, by = "gjeldende_prodnr8") %>%
  filter(!is.na(Orgnavn)) %>%
    st_as_sf(coords = c("geo_eu89_o", "geo_eu89_n"), crs = 4326)

tmap_mode("view")
tm_shape(Norway_with_buffer_500) +
  tm_borders() +
  tm_shape(ktr3) +
  tm_dots(col = "blue")


