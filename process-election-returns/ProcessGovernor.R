rm(list = ls())

library(tidyverse)

rep.unit.districts <- read_csv("clean-election-returns/ReportingUnitsWithDistricts.csv")

gov <- readxl::read_excel("raw-election-returns/ward by Ward Report_Governor.xlsx",
                          sheet = 2, skip = 10) %>%
  rename(county = 1, rep_unit = 2, total = 3, evers = 4, michels = 5,
         beglinger = 6, haskin = 7) %>%
  select(-...8) %>%
  mutate(county = zoo::na.locf(county)) %>%
  filter(rep_unit != "County Totals:") %>%
  inner_join(rep.unit.districts)

write_csv(gov, "clean-election-returns/Governor.csv")
