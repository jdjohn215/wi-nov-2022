rm(list = ls())

library(tidyverse)

rep.unit.districts <- read_csv("clean-election-returns/ReportingUnitsWithDistricts.csv")

attngeneral <- readxl::read_excel("raw-election-returns/ward by Ward Report_Attorney General.xlsx",
                             sheet = 2, skip = 10) %>%
  rename(county = 1, rep_unit = 2, total = 3, kaul = 4, toney = 5) %>%
  mutate(county = zoo::na.locf(county)) %>%
  filter(rep_unit != "County Totals:") %>%
  inner_join(rep.unit.districts)

write_csv(attngeneral, "clean-election-returns/AttorneyGeneral.csv")
