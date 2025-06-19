#### Preamble ####
# Purpose: Clean raw datasets
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01-download_data

#### Workspace setup ####

import pandas as pd

#### Read and clean raw data ####

## Read in Bus data
raw_bus_data = pd.read_csv("inputs/data/raw_bus_delay_statistics.csv")

# Clean names
cleaned_bus_data = raw_bus_data.rename(columns=lambda x: x.strip().lower().replace(" ", "_"))

# Select only relevant columns
cleaned_bus_data = cleaned_bus_data[[
    "date",
    "time",
    "day",
    "incident",
    "min_delay",
    "min_gap"
]]

# Filter out situations in which the delay is 0, meaning the incident that
# occurred didn't affect service
cleaned_bus_data = cleaned_bus_data[cleaned_bus_data["min_gap"] > 0]

# Save cleaned bus data
cleaned_bus_data.to_csv("inputs/data/bus_delay_statistics.csv", index=False)


## SUBWAY DATA

# Read in subway statistics
raw_subway_data = pd.read_csv("inputs/data/raw_subway_delay_statistics.csv")

# Clean names
cleaned_subway_data = raw_subway_data.rename(columns=lambda x: x.strip().lower().replace(" ", "_"))

# Select only relevant columns
cleaned_subway_data = cleaned_subway_data[[
    "date",
    "time",
    "day",
    "code",
    "min_delay",
    "min_gap",
    "line"  # additional for subway (no similar grouping for buses)
]]

# Save cleaned subway data
cleaned_subway_data.to_csv("inputs/data/subway_delay_statistics.csv", index=False)

# The reason 2 different .csv files are stored is that the vast majority
# of rows had a delay of 0 minutes. It seems as if a delay of 0 minutes
# means a delay of < 1 minute which is reasonable for a subway system.
# However, since this is an assumption, I also kept the filtered 
# dataset for reference.

# Filter out situations in which the delay is 0, meaning the incident that
# occurred didn't affect service
filtered_subway_data = cleaned_subway_data[cleaned_subway_data["min_delay"] > 0]

# Save cleaned and filtered subway data
filtered_subway_data.to_csv("inputs/data/filtered_subway_delay_statistics.csv", index=False)


# Read in subway codes
raw_subway_codes = pd.read_csv("inputs/data/raw_subway_delay_codes.csv")

# Clean names
cleaned_subway_codes = raw_subway_codes.rename(columns=lambda x: x.strip().lower().replace(" ", "_"))

# Select sub_rmenu_code columns
sub_rmenu_codes = cleaned_subway_codes[[
    "sub_rmenu_code",
    "code_description"
]].rename(columns={
    "sub_rmenu_code": "code",
    "code_description": "code_description"
})

# Select srt_rmenu_code columns (Scarborough RT)
srt_rmenu_codes = cleaned_subway_codes[[
    "srt_rmenu_code",
    "code_description.1"
]].dropna(subset=["srt_rmenu_code"]).rename(columns={
    "srt_rmenu_code": "code",
    "code_description.1": "code_description"
})

# Merge back in the 2 sets of codes
merged_subway_codes = pd.concat([sub_rmenu_codes, srt_rmenu_codes], ignore_index=True)

# Save cleaned code mappings
merged_subway_codes.to_csv("inputs/data/subway_delay_codes.csv", index=False)


#### Data Validation ####

# Test that there are only 7 unique days
assert cleaned_subway_data["day"].nunique() == 7
assert cleaned_bus_data["day"].nunique() == 7

# Test that delay times are positive
assert cleaned_subway_data["min_delay"].min() >= 0
assert cleaned_bus_data["min_delay"].min() >= 0

# Verify datatypes (informal check, not strict class testing like R)
assert cleaned_subway_data["day"].dtype == "object"
assert cleaned_bus_data["day"].dtype == "object"

# 'time' likely string or object unless parsed explicitly
# skipping strict time type assertion (would require datetime parsing)

assert pd.api.types.is_numeric_dtype(cleaned_subway_data["min_delay"])
assert pd.api.types.is_numeric_dtype(cleaned_subway_data["min_gap"])
assert pd.api.types.is_numeric_dtype(cleaned_bus_data["min_delay"])
assert pd.api.types.is_numeric_dtype(cleaned_bus_data["min_gap"])

# Clean up workspace
del (
    cleaned_bus_data,
    cleaned_subway_data,
    raw_bus_data,
    raw_subway_data,
    raw_subway_codes,
    sub_rmenu_codes,
    srt_rmenu_codes,
    merged_subway_codes,
    filtered_subway_data
)
