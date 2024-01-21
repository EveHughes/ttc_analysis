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
write_csv(cleaned_bus_delay_data, 'inputs/data/cleaned_bus_delay_statistics.csv')

### SUBWAY DATA ###

# Read in subway codes
subway_codes <-
  read_csv(
    file = "inputs/data/subway_delay_codes.csv",
    show_col_types = FALSE
  )

# Section codes into incident groups
cleaned_subway_codes <- 
  cleaned_subway_codes |>
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
write_csv(cleaned_subway_codes, 'inputs/data/cleaned_subway_codes.csv')


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
  ) |>
  

cleaned_subway_delay_data <- 
  cleaned_subway_delay_data[
    order(
      cleaned_subway_delay_data$date, 
      cleaned_subway_delay_data$time, 
      decreasing = FALSE
    ),]

# Save cleaned subway data
write_csv(cleaned_subway_delay_data, 'inputs/data/cleaned_subway_delay_statistics.csv')


