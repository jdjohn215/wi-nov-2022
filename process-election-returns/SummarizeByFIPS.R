library(tidyverse)
library(sf)

# This file summarizes results to various geographic levels by the FIPS codes
#   assigned to each reporting unit by joining with ward polygons

rep.units.polygons <- st_read("wards-to-rep-units/ReportingUnitPolygons.geojson") %>%
  st_set_geometry(NULL) %>%
  mutate(CNTY_FIPS = str_sub(MCD_FIPS, 3, 5),
         municipality_fips = str_sub(MCD_FIPS, -5)) %>%
  tibble()

by.county <- rep.units.polygons %>%
  group_by(CNTY_NAME, CNTY_FIPS) %>%
  summarise(across(contains("22"), sum, na.rm = T))

by.municipality <- rep.units.polygons %>%
  group_by(MCD_NAME, CTV, municipality_fips) %>%
  summarise(across(contains("22"), sum, na.rm = T)) %>%
  ungroup()

by.mcd <- rep.units.polygons %>%
  group_by(CNTY_NAME, MCD_NAME, CTV, MCD_FIPS) %>%
  summarise(across(contains("22"), sum, na.rm = T)) %>%
  ungroup()

write_csv(by.county, "clean-election-returns/AllRacesByCounty.csv")
write_csv(by.municipality, "clean-election-returns/AllRacesByMunicipality.csv")
write_csv(by.mcd, "clean-election-returns/AllRacesByMinorCivilDivision.csv")

