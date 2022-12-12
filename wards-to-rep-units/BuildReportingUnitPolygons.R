library(tidyverse)
library(sf)

rep.units.to.wards <- read_csv("wards-to-rep-units/ReportingUnitsWithWardIDs.csv")

ward.polygons <- st_read("wards-to-rep-units/WI_Municipal_Wards_November_2022.geojson")

rep.unit.polygons <- rep.units.to.wards %>%
  # separate wards
  separate(ward_list, into = paste0("w", 1:(max(str_count(rep.units.to.wards$ward_list, ","))+1)),
           sep = ",") %>%
  # convert to long format - 1 row per ward-in-rep-unit
  pivot_longer(cols = starts_with("w"), names_to = "drop", values_to = "WARD_FIPS") %>%
  select(-drop) %>%
  filter(!is.na(WARD_FIPS)) %>%
  mutate(WARD_FIPS = str_squish(WARD_FIPS)) %>%
  # join with ward polygons
  inner_join(ward.polygons) %>%
  st_as_sf() %>%
  # summarize all wards in rep unit into a single polygon
  group_by(CNTY_NAME, MCD_FIPS, MCD_NAME, CTV, rep_unit) %>%
  summarise() %>%
  ungroup()

# add vote totals
all.votes <- read_csv("clean-election-returns/AllRaces.csv") %>%
  mutate(rep_unit = str_to_upper(rep_unit)) %>%
  rename(CNTY_NAME = county)

all.votes.sf <- rep.unit.polygons %>%
  inner_join(all.votes)

# test that all votes are accounted for after spatial join
inner_join(
  all.votes.sf %>%
    st_set_geometry(NULL) %>%
    select(contains("TOT")) %>%
    summarise(across(where(is.numeric), sum, na.rm = T)) %>%
    pivot_longer(cols = everything(), names_to = "race", values_to = "after_spatial_join"),
  all.votes %>%
    select(contains("TOT")) %>%
    summarise(across(where(is.numeric), sum, na.rm = T)) %>%
    pivot_longer(cols = everything(), names_to = "race", values_to = "before_spatial_join")
) %>%
  mutate(match = after_spatial_join == before_spatial_join)

st_write(all.votes.sf, "wards-to-rep-units/ReportingUnitPolygons.geojson", delete_dsn = T)
