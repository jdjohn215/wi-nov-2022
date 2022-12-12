library(tidyverse)


# run this script *after* building assembly and congressional results

assembly <- read_csv("clean-election-returns/Assembly.csv")
congress <- read_csv("clean-election-returns/Congress.csv")


assembly.dist <- assembly %>%
  group_by(assembly_district = district, county, rep_unit) %>%
  summarise() %>%
  ungroup()

congress.dist <- congress %>%
  group_by(congress_district = district, county, rep_unit) %>%
  summarise() %>%
  ungroup()

senate.dist <- tibble(assembly_district = 1:99,
                      senate_district = rep(1:33, each = 3))

all.districts <- assembly.dist %>%
  inner_join(congress.dist) %>%
  inner_join(senate.dist) %>%
  select(county, rep_unit, assembly_district, senate_district, congress_district)

write_csv(all.districts, "clean-election-returns/ReportingUnitsWithDistricts.csv")
