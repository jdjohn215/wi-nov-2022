rm(list = ls())

library(tidyverse)

rep.unit.districts <- read_csv("clean-election-returns/ReportingUnitsWithDistricts.csv")

senate <- readxl::read_excel("raw-election-returns/ward by Ward Report_US Senate.xlsx",
                          sheet = 2, skip = 10) %>%
  rename(county = 1, rep_unit = 2, total = 3, barnes = 4, johnson = 5,
         paul = 6) %>%
  mutate(county = zoo::na.locf(county)) %>%
  filter(rep_unit != "County Totals:")

write_csv(senate, "clean-election-returns/Senate.csv")
