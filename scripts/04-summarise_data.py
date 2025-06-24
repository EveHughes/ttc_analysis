#### Preamble ####
# Purpose: Group delay data into similar sets of incidents
# Author: Daniel Hartono
# Date: 23 January 2024
# Contact: daniel.hartono@mail.utoronto.ca
# License: MIT
# Prerequisites: 01-download_data, 02-clean_data, 03-parse_codes

#### Workspace setup ####
import pandas as pd

# Read in bus data
bus_delay_data = pd.read_csv("outputs/data/cleaned_bus_delay_statistics.csv")

# Ensure date is just the calendar date (not datetime with time)
bus_delay_data["date"] = pd.to_datetime(bus_delay_data["date"]).dt.date


avg_num_bus_delays_by_day = (
    bus_delay_data
    .groupby(["date", "day"], observed=False)  # observed=False ensures all day levels are preserved
    .size()
    .groupby(level="day", observed=False)
    .mean()
    .reset_index(name="mean_num_delays")
)

# Summarize into total delay time and number of delays per date (Jan 1st, 2nd, ...)
total_bus_delay_time_by_date = (
    bus_delay_data
    .groupby(["date", "day"])
    .agg(total_delay_time=("min_delay", "sum"), n=("min_delay", "count"))
    .reset_index()
)
total_bus_delay_time_by_date["mean_delay_time"] = total_bus_delay_time_by_date["total_delay_time"] / total_bus_delay_time_by_date["n"]

# Summarize into the total number of delays per incident type (e.g. Equipment/Mechanical)
total_num_bus_delays_by_incident = (
    bus_delay_data
    .groupby("incident")
    .size()
    .reset_index(name="n")
)

# Read in subway data
subway_delay_data = pd.read_csv("outputs/data/cleaned_subway_delay_statistics.csv")

# Ensure date is just the calendar date (not datetime with time)
subway_delay_data["date"] = pd.to_datetime(subway_delay_data["date"]).dt.date

# Summarize into average number of delays per day of the week (Mon, Tues, ...)
delays_per_day_subway = (
    subway_delay_data
    .groupby(["date", "day"])
    .size()
    .reset_index(name="n")
)

avg_num_subway_delays_by_day = (
    delays_per_day_subway
    .groupby("day")
    .agg(mean_num_delays=("n", "mean"))
    .reset_index()
)

# Summarize into total delay time and number of delays per date (Jan 1st, 2nd, ...)
total_subway_delay_time_by_date = (
    subway_delay_data
    .groupby(["date", "day"])
    .agg(total_delay_time=("min_delay", "sum"), n=("min_delay", "count"))
    .reset_index()
)
total_subway_delay_time_by_date["mean_delay_time"] = total_subway_delay_time_by_date["total_delay_time"] / total_subway_delay_time_by_date["n"]

# Summarize into the total number of delays per incident type (e.g. Equipment/Mechanical)
total_num_subway_delays_by_incident = (
    subway_delay_data
    .groupby("incident")
    .size()
    .reset_index(name="n")
)

# Summarize into the total number of delays per line (e.g. BY (Bloor-Yonge))
total_num_subway_delays_by_line = (
    subway_delay_data
    .groupby("line")
    .size()
    .reset_index(name="n")
)

# Save all the data

avg_num_bus_delays_by_day.to_csv("outputs/data/summaries/avg_num_bus_delays_by_day.csv", index=False)
avg_num_subway_delays_by_day.to_csv("outputs/data/summaries/avg_num_subway_delays_by_day.csv", index=False)

total_num_bus_delays_by_incident.to_csv("outputs/data/summaries/total_num_bus_delays_by_incident.csv", index=False)
total_num_subway_delays_by_incident.to_csv("outputs/data/summaries/total_num_subway_delays_by_incident.csv", index=False)

total_bus_delay_time_by_date.to_csv("outputs/data/summaries/total_bus_delay_time_by_date.csv", index=False)
total_subway_delay_time_by_date.to_csv("outputs/data/summaries/total_subway_delay_time_by_date.csv", index=False)

total_num_subway_delays_by_line.to_csv("outputs/data/summaries/total_num_subway_delays_by_line.csv", index=False)

# Clean up workspace
del (
    avg_num_bus_delays_by_day,
    avg_num_subway_delays_by_day,
    delays_per_day_subway,
    bus_delay_data,
    subway_delay_data,
    total_bus_delay_time_by_date,
    total_num_bus_delays_by_incident,
    total_num_subway_delays_by_incident,
    total_num_subway_delays_by_line,
    total_subway_delay_time_by_date
)
