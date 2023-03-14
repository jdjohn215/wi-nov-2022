rm(list = ls())

library(tidyverse)

all.races.orig <- read_csv("clean-election-returns/AllRaces.csv")

# list of wards in each reporting unit
rep.units.to.wards <- read_csv("wards-to-rep-units/WardsInRepUnits.csv")

# ward polygons
wards.orig <- st_read("~/dropbox/projects/2022/november/electionresults/wards/WI_Municipal_Wards_November_2022.geojson") %>%
  st_set_geometry(NULL) %>%
  tibble()

# clean up and edit the reporting unit wards as necessary
rep.units.to.wards2 <- rep.units.to.wards %>%
  mutate(CTV = str_sub(mcd, 1, 1),
         MCD_NAME = word(mcd, 3, -1),
         WARDID = str_pad(ward, width = 4, side = "left", pad = "0")) %>%
  # munge
  mutate(MCD_NAME = str_replace(MCD_NAME, "MT. STERLING", "MOUNT STERLING"),
         MCD_NAME = str_replace(MCD_NAME, "GRAND VIEW", "GRANDVIEW"),
         MCD_NAME = str_replace(MCD_NAME, "FONTANA", "FONTANA-ON-GENEVA LAKE"),
         MCD_NAME = str_replace(MCD_NAME, "LAND O-LAKES", "LAND O'LAKES"),
         MCD_NAME = str_replace(MCD_NAME, "LAVALLE", "LA VALLE"),
         MCD_NAME = str_replace(MCD_NAME, "SAINT LAWRENCE", "ST. LAWRENCE"),
         WARDID = replace(WARDID, rep_unit_id == 704, "0001"),
         WARDID = replace(WARDID, rep_unit_id == 4538, "0001"),
         # case of Rock Count CITY OF BRODHEAD WARDS 7-8 reporting unit really just corresponding to Rock County ward 1
         WARDID = replace(WARDID, rep_unit_id %in% c("5027", "5028"), "0001")) %>%
  select(rep_unit_id, CNTY_NAME = county, rep_unit, MCD_NAME, CTV, WARDID) %>%
  mutate(across(where(is.character), str_to_upper))

# try joining the reporting unit wards to the ward polygons
join1 <- rep.units.to.wards2 %>%
  inner_join(wards.orig)

# all matches unique?
n_distinct(join1$rep_unit_id) == nrow(join1)

# reporting unit wards taht failed to join
failed.join <- rep.units.to.wards2 %>%
  anti_join(wards.orig)

# ward polygons that failed to join
unjoined.wards <- wards.orig %>%
  filter(! WARD_FIPS %in% join1$WARD_FIPS)

# all joined reporting units
joined.rep.units <- join1 %>%
  group_by(CNTY_NAME, rep_unit) %>%
  summarise(ward_list = paste(unique(WARD_FIPS), collapse = ", ")) %>%
  ungroup()

# reporting units with no ward matches
#   all should be 0 vote wards
all.races.orig %>%
  mutate(rep_unit = str_to_upper(rep_unit)) %>%
  rename(CNTY_NAME = county) %>%
  anti_join(joined.rep.units)

write_csv(joined.rep.units, "wards-to-rep-units/ReportingUnitsWithWardIDs.csv")


orig.wards.with.reporting.unit <- st_read("~/dropbox/projects/2022/november/electionresults/wards/WI_Municipal_Wards_November_2022.geojson") %>%
  left_join(
    joined.rep.units %>%
      separate_rows(ward_list) %>%
      select(rep_unit, WARD_FIPS = ward_list)
  )
st_write(orig.wards.with.reporting.unit, "wards-to-rep-units/WI_Municipal_Wards_November_2022.geojson",
         delete_dsn = T)
