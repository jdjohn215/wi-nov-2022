rm(list = ls())

library(tidyverse)
library(sf)

# This script extracts the individual wards listed in each reporting unit string

all.races.orig <- read_csv("clean-election-returns/AllRaces.csv")

all.races <- all.races.orig

# expand a list of numbers including dashes into full list
expand_dash <- function(wardstring){
  wardstring.elements <- unlist(str_split(wardstring, ","))
  wardstring.list <- lapply(
    X = wardstring.elements,
    FUN = function(text){
      if(str_detect(text, "-")){
        limits <- as.numeric(unlist(strsplit(text, '-')))
        paste(seq(limits[1], limits[2]), collapse = ", ")
      } else {
        text
      }
    }
  )
  str_remove_all(paste(wardstring.list, collapse = ","), " ")
}

# identify wards in each reporting unit
rep.units.to.wards <- all.races %>%
  select(county, rep_unit) %>%
  separate(rep_unit, into = c("mcd", "wards"), sep = "\\bWard\\b|\\bWards\\b",
           remove = F) %>%
  mutate(across(where(is.character), str_squish)) %>%
  # munge
  mutate(wards = case_when(
    rep_unit == "Town of WOLF RIVER Wards 1-2A" ~ "1, 2A",
    TRUE ~ wards)
  ) %>%
  rowwise() %>%
  mutate(wards = expand_dash(wards)) %>%
  ungroup() %>%
  separate(wards, into = c("w1", "w2", "w3", "w4", "w5", "w6", "w7", "w8", "w9",
                           "w10", "w11", "w12", "w13", "w14", "w15", "w16", "w17"),
           sep = ",") %>%
  pivot_longer(cols = c("w1", "w2", "w3", "w4", "w5", "w6", "w7", "w8", "w9", "w10",
                        "w11", "w12", "w13", "w14", "w15", "w16", "w17"),
               values_to = "ward") %>%
  mutate(ward = str_squish(ward)) %>%
  filter(!is.na(ward)) %>%
  select(-name) %>%
  mutate(rep_unit_id = row_number())
write_csv(rep.units.to.wards, "wards-to-rep-units/WardsInRepUnits.csv")

