#### Preamble ####
# Purpose: Group delay data into similar sets of incidents
# Author: Daniel Hartono
# Date: 23 January 2024
# Contact: daniel.hartono@mail.utoronto.ca
# License: MIT
# Prerequisites: 01-download_data, 02-clean_data

#### Workspace setup ####
import pandas as pd

### Bus data ###

# Load in non-grouped data
bus_delay_data = pd.read_csv("inputs/data/bus_delay_statistics.csv")

# Group bus incidents
bus_incident_map = {
    "Diversion": "Miscellaneous",
    "Security": "Security/Safety",
    "Cleaning - Unsanitary": "Security/Safety",
    "Emergency Services": "Security/Safety",
    "Collision - TTC": "Operator",
    "Mechanical": "Equipment/Mechanical",
    "Operations - Operator": "Operator",
    "Investigation": "Security/Safety",
    "Utilized Off Route": "Miscellaneous",
    "General Delay": "Miscellaneous",
    "Road Blocked - NON-TTC Collision": "Miscellaneous",
    "Held By": "Miscellaneous",
    "Vision": "Security/Safety"
}

cleaned_bus_delay_data = bus_delay_data.copy()
cleaned_bus_delay_data["incident"] = cleaned_bus_delay_data["incident"].map(bus_incident_map)

# Save cleaned data
cleaned_bus_delay_data.to_csv("outputs/data/cleaned_bus_delay_statistics.csv", index=False)

### SUBWAY DATA ###

# Read in subway codes
subway_codes = pd.read_csv("inputs/data/subway_delay_codes.csv")

# Section codes into incident groups
def classify_subway_incident(code):
    if str(code).startswith("E"):
        return "Equipment/Mechanical"
    if str(code).startswith(("MUI", "MUS", "MUP")):
        return "Security/Safety"
    if str(code).startswith("MUD") or str(code).startswith("MUE"):
        return "Equipment/Mechanical"
    if str(code).startswith("P"):
        return "Equipment/Mechanical"
    if str(code).startswith("S"):
        return "Security/Safety"
    if str(code).startswith("T"):
        return "Operator"
    return "Miscellaneous"

cleaned_subway_codes = subway_codes.copy()
cleaned_subway_codes["incident"] = cleaned_subway_codes["code"].apply(classify_subway_incident)

# Save cleaned codes
cleaned_subway_codes.to_csv("outputs/data/cleaned_subway_codes.csv", index=False)

# Read in subway data
subway_delay_data = pd.read_csv("inputs/data/subway_delay_statistics.csv")

# Merge subway delay data with grouped code data
cleaned_subway_delay_data = pd.merge(subway_delay_data, cleaned_subway_codes, on="code", how="inner")

# Select and reorder relevant columns
cleaned_subway_delay_data = cleaned_subway_delay_data[[
    "date",
    "time",
    "day",
    "incident",
    "min_delay",
    "min_gap",
    "line"
]]

# Clean up line data
line_map = {
    "YU": "Yonge-University",
    "YUS": "Yonge-University",
    "BD": "Bloor-Danforth",
    "BD LINE 2": "Bloor-Danforth",
    "SRT": "Scarborough-RT",
    "SHP": "Sheppard",
    "YU / BD": "Yonge-University/Bloor-Danforth",
    "BD/YU": "Yonge-University/Bloor-Danforth",
    "YU/BD": "Yonge-University/Bloor-Danforth",
    "YUS/BD": "Yonge-University/Bloor-Danforth",
    "YU & BD": "Yonge-University/Bloor-Danforth",
    "BLOOR DANFORTH & YONGE": "Yonge-University/Bloor-Danforth"
}

cleaned_subway_delay_data["line"] = cleaned_subway_delay_data["line"].map(line_map).fillna("Other")

# Sort data by date and time
cleaned_subway_delay_data = cleaned_subway_delay_data.sort_values(by=["date", "time"], ascending=[True, True])

# Save cleaned subway data
cleaned_subway_delay_data.to_csv("outputs/data/cleaned_subway_delay_statistics.csv", index=False)

#### Data Validation ####

valid_incidents = {"Equipment/Mechanical", "Miscellaneous", "Operator", "Security/Safety"}

# Test that the incident types are limited to the set
assert set(cleaned_subway_delay_data["incident"].unique()) == valid_incidents
assert set(cleaned_bus_delay_data["incident"].dropna().unique()) <= valid_incidents

# Test that there are only 7 unique days
assert cleaned_subway_delay_data["day"].nunique() == 7
assert cleaned_bus_delay_data["day"].nunique() == 7

# Test that delay times are positive
assert cleaned_subway_delay_data["min_delay"].min() >= 0
assert cleaned_bus_delay_data["min_delay"].min() >= 0

# Verify datatypes (approximate checks)
assert cleaned_subway_delay_data["day"].dtype == "object"
assert cleaned_subway_delay_data["incident"].dtype == "object"
assert pd.api.types.is_numeric_dtype(cleaned_subway_delay_data["min_delay"])
assert pd.api.types.is_numeric_dtype(cleaned_subway_delay_data["min_gap"])

assert cleaned_bus_delay_data["day"].dtype == "object"
assert cleaned_bus_delay_data["incident"].dtype == "object"
assert pd.api.types.is_numeric_dtype(cleaned_bus_delay_data["min_delay"])
assert pd.api.types.is_numeric_dtype(cleaned_bus_delay_data["min_gap"])

# Clean up workspace
del (
    bus_delay_data, 
    cleaned_bus_delay_data, 
    subway_codes, 
    cleaned_subway_codes, 
    subway_delay_data, 
    cleaned_subway_delay_data
)
