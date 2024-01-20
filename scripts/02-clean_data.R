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
    min_gap
  )

# Save cleaned subway data
write_csv(cleaned_subway_data, 'inputs/data/subway_delay_statistics.csv')

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
    rmenu_code = sub_rmenu_code, 
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
    rmenu_code = srt_rmenu_code, 
    code_description = code_description_7
  )

# Merge back in the 2 sets of codes
cleaned_subway_codes <- 
  union(sub_rmenu_codes, srt_rmenu_codes)

# Save cleaned code mappings
write_csv(cleaned_subway_codes, 'inputs/data/subway_delay_codes.csv')

