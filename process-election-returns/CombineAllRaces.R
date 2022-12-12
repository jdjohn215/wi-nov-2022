library(tidyverse)

# This script combines all the reporting-unit level races and summarizes them in various ways

assembly <- read_csv("clean-election-returns/Assembly.csv")
attorneygeneral <- read_csv("clean-election-returns/AttorneyGeneral.csv")
congress <- read_csv("clean-election-returns/Congress.csv")
governor <- read_csv("clean-election-returns/Governor.csv")
sos <- read_csv("clean-election-returns/SecretaryOfState.csv")
senate <- read_csv("clean-election-returns/Senate.csv")
statesenate <- read_csv("clean-election-returns/StateSenate.csv")
treasurer <- read_csv("clean-election-returns/Treasurer.csv")

d.assembly <- assembly %>%
  select(-c(candidate)) %>%
  pivot_wider(names_from = party, values_from = votes, values_fill = 0) %>%
  select(assembly_district = district, county, rep_unit, WSATOT22 = total,
         WSADEM22 = DEM, WSAREP22 = REP)
d.attorneygeneral <- attorneygeneral %>%
  select(county, rep_unit, WAGTOT22 = total, WAGDEM22 = kaul, WAGREP22 = toney)
d.congress <- congress %>%
  select(-c(candidate)) %>%
  pivot_wider(names_from = party, values_from = votes, values_fill = 0) %>%
  select(congress_district = district, county, rep_unit, 
         USHTOT22 = total, USHDEM22 = DEM, USHREP22 = REP)
d.governor <- governor %>%
  select(county, rep_unit, GOVTOT22 = total, GOVDEM22 = evers, GOVREP22 = michels)
d.sos <- sos %>%
  select(county, rep_unit, SOSTOT22 = total, SOSDEM22 = lafollete, SOSREP22 = loudenbeck)
d.senate <- senate %>%
  select(county, rep_unit, USSTOT22 = total, USSDEM22 = barnes, USSREP22 = johnson)
d.statesenate <- statesenate %>%
  select(-c(candidate)) %>%
  pivot_wider(names_from = party, values_from = votes, values_fill = 0) %>%
  select(senate_district, county, rep_unit, 
         WSSTOT22 = total, WSSDEM22 = DEM, WSSREP22 = REP)
d.treasurer <- treasurer %>%
  select(county, rep_unit, WSTTOT22 = total, WSTDEM22 = richardson, WSTREP22 = leiber)

d.all <- d.governor %>%
  inner_join(d.assembly) %>%
  inner_join(d.attorneygeneral) %>%
  inner_join(d.congress) %>%
  inner_join(d.sos) %>%
  inner_join(d.senate) %>%
  left_join(d.statesenate) %>%
  inner_join(d.treasurer) %>%
  select(county, rep_unit, contains("district"), everything())


d.all %>%
  select(-contains(c("WSS", "WSA"))) %>%
  summarise(across(contains("TOT"), sum))

write_csv(d.all, "clean-election-returns/AllRaces.csv")

# all results by assembly
all.by.assembly <- d.all %>%
  select(-senate_district, -congress_district) %>%
  group_by(assembly_district) %>%
  summarise(across(where(is.numeric), sum))
write_csv(all.by.assembly, "clean-election-returns/AllRacesByAssemblyDistrict.csv")

# all results by senate
all.by.senate <- d.all %>%
  select(-congress_district) %>%
  group_by(assembly_district, senate_district) %>%
  summarise(across(where(is.numeric), sum)) %>%
  ungroup() %>%
  mutate(senate_district = rep(1:33, each = 3)) %>%
  select(-assembly_district) %>%
  group_by(senate_district) %>%
  summarise(across(where(is.numeric), sum)) %>%
  ungroup()
write_csv(all.by.senate, "clean-election-returns/AllRacesBySenateDistrict.csv")

# all results by congressional district
all.by.congress <- d.all %>%
  select(-senate_district, -assembly_district) %>%
  group_by(congress_district) %>%
  summarise(across(where(is.numeric), sum))
write_csv(all.by.congress, "clean-election-returns/AllRacesByCongressionalDistrict.csv")

# all results by mcd
all.by.mcd <- d.all %>%
  separate(rep_unit, into = c("municipality", "wards"), sep = "\\bWard\\b|\\bWards\\b") %>%
  select(-contains("district")) %>%
  group_by(county, municipality) %>%
  summarise(across(where(is.numeric), sum)) %>%
  mutate(across(where(is.character), str_squish)) %>%
  ungroup()
write_csv(all.by.mcd, "clean-election-returns/AllRacesByMCD.csv")
