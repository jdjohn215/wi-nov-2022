rm(list = ls())

library(tidyverse)

rep.unit.districts <- read_csv("clean-election-returns/ReportingUnitsWithDistricts.csv")

sos <- readxl::read_excel("raw-election-returns/ward by Ward Report_Secretary of State.xlsx",
                             sheet = 2, skip = 10) %>%
  rename(county = 1, rep_unit = 2, total = 3, lafollete = 4, loudenbeck = 5,
         harmon = 6, mcfarland = 7) %>%
  mutate(county = zoo::na.locf(county)) %>%
  filter(rep_unit != "County Totals:") %>%
  select(-...8)

write_csv(sos, "clean-election-returns/SecretaryOfState.csv")
