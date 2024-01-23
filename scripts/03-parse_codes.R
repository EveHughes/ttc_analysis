#### Preamble ####
# Purpose: Group delay data into similar sets of incidents
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01-download_data, 02-clean_data

#### Workspace setup ####
library(tidyverse)
library(janitor)

### Bus data ###

# Load in non-grouped data
bus_delay_data <- 
  read_csv(
    file = "inputs/data/bus_delay_statistics.csv",
    show_col_types = FALSE
  )

# Group bus incidents
cleaned_bus_delay_data <- 
  bus_delay_data |>
  mutate(
    incident =
      case_match(
        incident,
        "Diversion" ~ "Miscellaneous",
        "Security" ~ "Security/Safety",
        "Cleaning - Unsanitary" ~ "Security/Safety",
        "Emergency Services" ~ "Security/Safety",
        "Collision - TTC" ~ "Operator",
        "Mechanical" ~ "Equipment/Mechanical",
        "Operations - Operator" ~ "Operator",
        "Investigation" ~ "Security/Safety",
        "Utilized Off Route" ~ "Miscellaneous",
        "General Delay" ~ "Miscellaneous",
        "Road Blocked - NON-TTC Collision" ~ "Miscellaneous",
        "Held By" ~ "Miscellaneous",
        "Vision" ~ "Security/Safety"
      )
  )

# Save cleaned data
write_csv(cleaned_bus_delay_data, 'outputs/data/cleaned_bus_delay_statistics.csv')

### SUBWAY DATA ###

# Read in subway codes
subway_codes <-
  read_csv(
    file = "inputs/data/subway_delay_codes.csv",
    show_col_types = FALSE
  )


# Section codes into incident groups
cleaned_subway_codes <- 
  subway_codes |>
  mutate(
    incident = case_when(
      startsWith(code, "E") ~ "Equipment/Mechanical",
      startsWith(code, "M") ~ "Miscellaneous",
      startsWith(code, "P") ~ "Equipment/Mechanical",
      startsWith(code, "S") ~ "Security/Safety",
      startsWith(code, "T") ~ "Operator"
    )
  )

# Save cleaned codes
write_csv(cleaned_subway_codes, 'outputs/data/cleaned_subway_codes.csv')


# Read in subway data
subway_delay_data <-
  read_csv(
    file = "inputs/data/subway_delay_statistics.csv",
    show_col_types = FALSE
  )

# Using cleaned_subway_codes, parse the incident code 
# for the delay and set incident to be that type of incident
# e.g. MUSC -> "Miscellaneous"
cleaned_subway_delay_data <-
  merge(subway_delay_data, cleaned_subway_codes, by = "code", all = FALSE) |> 
  select(
    date,
    time,
    day,
    incident,
    min_delay,
    min_gap
  )
  

cleaned_subway_delay_data <- 
  cleaned_subway_delay_data[
    order(
      cleaned_subway_delay_data$date, 
      cleaned_subway_delay_data$time, 
      decreasing = FALSE
    ),]

# Save cleaned subway data
write_csv(cleaned_subway_delay_data, 'outputs/data/cleaned_subway_delay_statistics.csv')


#### Data Validation ####

# Test that the incident types are limited to the set
cleaned_subway_delay_data$incident |> 
  unique() |>
  setequal(c("Equipment/Mechanical", "Miscellaneous", "Operator", "Security/Safety"))

cleaned_bus_delay_data$incident |> 
  unique() |>
  setequal(c("Equipment/Mechanical", "Miscellaneous", "Operator", "Security/Safety"))


# Test that there are only 7 unique days
cleaned_subway_delay_data$day |>
  unique() |>
  length() == 7

cleaned_bus_delay_data$day |>
  unique() |>
  length() == 7

# Test that delay times are non-negative
cleaned_subway_delay_data$min_delay |>
  min() >= 0

cleaned_bus_delay_data$min_delay |>
  min() >= 0

# Verify datatypes
class(cleaned_subway_delay_data$day) == "character"
class(cleaned_subway_delay_data$incident) == "character"
class(cleaned_subway_delay_data$min_delay) == "numeric"
class(cleaned_subway_delay_data$min_gap) == "numeric"

class(cleaned_bus_delay_data$day) == "character"
class(cleaned_bus_delay_data$incident) == "character"
class(cleaned_bus_delay_data$min_delay) == "numeric"
class(cleaned_bus_delay_data$min_gap) == "numeric"

# Clean up workspace
rm(list = ls())