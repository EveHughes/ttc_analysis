#### Preamble ####
# Purpose: Clean raw datasets
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01-download_data

#### Workspace setup ####
library(tidyverse)
library(janitor)

#### Read and clean raw data ####

## Read in Bus data
raw_bus_data <- 
  read_csv(
     file = "inputs/data/raw_bus_delay_statistics.csv",
     show_col_types = FALSE
  )

# Clean names
cleaned_bus_data <-
  clean_names(raw_bus_data)

# Select only relevant columns
cleaned_bus_data <-
  cleaned_bus_data |>
  select(
    date,
    time,
    day,
    incident,
    min_delay,
    min_gap
  )

# Filter out situations in which the delay is 0, meaning the incident that
# occurred didn't affect service
cleaned_bus_data <-
  cleaned_bus_data |>
  filter(min_gap > 0)

# Save cleaned bus data
write_csv(cleaned_bus_data, 'inputs/data/bus_delay_statistics.csv')

## SUBWAY DATA

# Read in subway statistics
raw_subway_data <-
  read_csv(
    file = "inputs/data/raw_subway_delay_statistics.csv",
    show_col_types = FALSE
  )

# Clean names
cleaned_subway_data <-
  clean_names(raw_subway_data)

# Select only relevant columns
cleaned_subway_data <- 
  cleaned_subway_data |>
  select(
    date,
    time,
    day,
    code,
    min_delay,
    min_gap,
    line # additional for subway (no similar grouping for buses)
  )

# Save cleaned subway data
write_csv(cleaned_subway_data, 'inputs/data/subway_delay_statistics.csv')

# The reason 2 different .csv files are stored is that the vast majority
# of rows had a delay of 0 minutes. It seems as if a delay of 0 minutes
# means a delay of < 1 minute which is reasonable for a subway system.
# However, since this is an assumption, I also kept the filtered 
# dataset for reference.

# Filter out situations in which the delay is 0, meaning the incident that
# occurred didn't affect service
cleaned_subway_data <-
  cleaned_subway_data |>
  filter(min_delay > 0)

# Save cleaned and filtered subway data
write_csv(cleaned_subway_data, 'inputs/data/filtered_subway_delay_statistics.csv')

# Read in subway codes
raw_subway_codes <-
  read_csv(
    file = "inputs/data/raw_subway_delay_codes.csv",
    show_col_types = FALSE
  )

# Clean names
cleaned_subway_codes <-
  clean_names(raw_subway_codes)

# Select sub_rmenu_code columns
sub_rmenu_codes <- 
  cleaned_subway_codes |>
  select(
    sub_rmenu_code, 
    code_description_3
  )

# Rename in perperation for merge
sub_rmenu_codes <-
  sub_rmenu_codes |>
  rename(
    code = sub_rmenu_code, 
    code_description = code_description_3
  )

# Select srt_rmenu_code columns (Scarborough RT)
srt_rmenu_codes <-
  cleaned_subway_codes |>
  select(
    srt_rmenu_code,
    code_description_7
  )

# Filter out N/A values
srt_rmenu_codes <-
  srt_rmenu_codes |> filter(!is.na(srt_rmenu_code))

# Rename in perperation for merge
srt_rmenu_codes <-
  srt_rmenu_codes |>
  rename(
    code = srt_rmenu_code, 
    code_description = code_description_7
  )

# Merge back in the 2 sets of codes
cleaned_subway_codes <- 
  union(sub_rmenu_codes, srt_rmenu_codes)

# Save cleaned code mappings
write_csv(cleaned_subway_codes, 'inputs/data/subway_delay_codes.csv')

#### Data Validation ####

# Test that there are only 7 unique days
cleaned_subway_data$day |>
  unique() |>
  length() == 7

cleaned_bus_data$day |>
  unique() |>
  length() == 7

# Test that delay times are positive
cleaned_subway_data$min_delay |>
  min() >= 0

cleaned_bus_data$min_delay |>
  min() >= 0

# Verify datatypes
class(cleaned_subway_data$day) == "character"
class(cleaned_subway_data$time) == c("hms", "difftime")
class(cleaned_subway_data$min_delay) == "numeric"
class(cleaned_subway_data$min_gap) == "numeric"

class(cleaned_bus_data$day) == "character"
class(cleaned_bus_data$time) == c("hms", "difftime")
class(cleaned_bus_data$min_delay) == "numeric"
class(cleaned_bus_data$min_gap) == "numeric"

# Clean up workspace
rm(list = c(
  "cleaned_bus_data",
  "cleaned_subway_codes",
  "cleaned_subway_data",
  "raw_bus_data",
  "raw_subway_codes",
  "raw_subway_data",
  "srt_rmenu_codes",
  "sub_rmenu_codes"
))

