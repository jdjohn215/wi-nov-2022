rm(list = ls())

library(tidyverse)

rep.unit.districts <- read_csv("clean-election-returns/ReportingUnitsWithDistricts.csv")

treasurer <- readxl::read_excel("raw-election-returns/ward by Ward Report_State treasurer.xlsx",
                             sheet = 2, skip = 10) %>%
  rename(county = 1, rep_unit = 2, total = 3, richardson = 4, leiber = 5,
         zuelke = 6) %>%
  mutate(county = zoo::na.locf(county)) %>%
  filter(rep_unit != "County Totals:") %>%
  inner_join(rep.unit.districts)

write_csv(treasurer, "clean-election-returns/Treasurer.csv")
