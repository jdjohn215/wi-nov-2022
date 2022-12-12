rm(list = ls())

library(tidyverse)

rep.unit.districts <- read_csv("clean-election-returns/ReportingUnitsWithDistricts.csv")

read_senate_sheet <- function(sheetnum){
  raw.senate <- readxl::read_excel("raw-election-returns/Ward by Ward Report_State Senator.xlsx",
                                     sheet = sheetnum, col_names = F)
  
  district <- raw.senate %>% filter(str_detect(...1, "STATE SENATOR")) %>% pull(...1)
  
  party.row <- which(str_detect(raw.senate$...3, "Total Votes Cast"))
  
  colnames <- raw.senate[party.row:(party.row + 1),] %>%
    mutate(rownum = paste0("r", row_number())) %>%
    pivot_longer(cols = -rownum, names_to = "colnum") %>%
    pivot_wider(names_from = rownum, values_from = value) %>%
    mutate(colname = case_when(
      colnum == "...1" ~ "county",
      colnum == "...2" ~ "rep_unit",
      r1 == "Total Votes Cast" ~ "total",
      is.na(r2) ~ r1,
      is.na(r1) ~ r2,
      TRUE ~ paste(r1, r2, sep = "_")
    )) %>%
    pull(colname)
  readxl::read_excel("raw-election-returns/Ward by Ward Report_State Senator.xlsx",
                     sheet = sheetnum, col_names = colnames, skip = (party.row + 1)) %>%
    filter(str_detect(rep_unit, "Totals:", negate = T)) %>%
    mutate(county = zoo::na.locf(county)) %>%
    mutate(district = district) %>%
    select(district, everything()) %>%
    pivot_longer(cols = -c(district, county, rep_unit, total), names_to = "candidate", values_to = "votes") %>%
    mutate(district = as.numeric(word(district, -1))) %>%
    separate(candidate, into = c("party", "candidate"), sep = "_") %>%
    group_by(district, county, rep_unit, party) %>%
    mutate(partycount = row_number()) %>%
    ungroup() %>%
    mutate(party = case_when(
      str_detect(candidate, "write-in") ~ paste0(party, "2"),
      partycount > 1 ~ paste0(party, partycount),
      TRUE ~ party
    ))
}

senate <- map_df(2:18, read_senate_sheet) %>%
  select(-partycount)

# test
senate %>%
  group_by(rep_unit, county, party) %>%
  filter(n() > 1)

# add district codes
senate2 <- senate %>%
  select(-district) %>%
  inner_join(rep.unit.districts)

write_csv(senate2, "clean-election-returns/StateSenate.csv")
