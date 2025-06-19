#### Preamble ####
# Purpose: Group delay data into similar sets of incidents
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01-download_data, 02-clean_data, 03-parse_codes

#### Workspace setup ####

import pandas as pd

# Ordered day list for consistent grouping
ordered_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

# Read in bus data
bus_delay_data = pd.read_csv("outputs/data/cleaned_bus_delay_statistics.csv")
bus_delay_data["day"] = pd.Categorical(bus_delay_data["day"], categories=ordered_days, ordered=True)

# Summarize into average number of delays per day of the week (Mon, Tues, ...)
avg_num_bus_delays_by_day = (
    bus_delay_data.groupby(["date", "day"], observed=False)
    .size()
    .reset_index(name="n")
    .groupby("day", observed=False)
    .agg(mean_num_delays=("n", "mean"))
    .reset_index()
)

# Summarize into total delay time and number of delays per date (Jan 1st, 2nd, ...)
total_bus_delay_time_by_date = (
    bus_delay_data.groupby(["date", "day"], observed=False)
    .agg(
        total_delay_time=("min_delay", "sum"),
        n=("min_delay", "size")
    )
    .reset_index()
)
total_bus_delay_time_by_date["mean_delay_time"] = (
    total_bus_delay_time_by_date["total_delay_time"] / total_bus_delay_time_by_date["n"]
)

# Summarize into the total number of delays per incident type
total_num_bus_delays_by_incident = (
    bus_delay_data.groupby("incident", observed=False)
    .size()
    .reset_index(name="n")
)

# Read in subway data
subway_delay_data = pd.read_csv("outputs/data/cleaned_subway_delay_statistics.csv")
subway_delay_data["day"] = pd.Categorical(subway_delay_data["day"], categories=ordered_days, ordered=True)

# Summarize into average number of delays per day of the week (Mon, Tues, ...)
avg_num_subway_delays_by_day = (
    subway_delay_data.groupby(["date", "day"], observed=False)
    .size()
    .reset_index(name="n")
    .groupby("day", observed=False)
    .agg(mean_num_delays=("n", "mean"))
    .reset_index()
)

# Summarize into total delay time and number of delays per date (Jan 1st, 2nd, ...)
total_subway_delay_time_by_date = (
    subway_delay_data.groupby(["date", "day"], observed=False)
    .agg(
        total_delay_time=("min_delay", "sum"),
        n=("min_delay", "size")
    )
    .reset_index()
)
total_subway_delay_time_by_date["mean_delay_time"] = (
    total_subway_delay_time_by_date["total_delay_time"] / total_subway_delay_time_by_date["n"]
)

# Summarize into the total number of delays per incident type
total_num_subway_delays_by_incident = (
    subway_delay_data.groupby("incident", observed=False)
    .size()
    .reset_index(name="n")
)

# Summarize into the total number of delays per line
total_num_subway_delays_by_line = (
    subway_delay_data.groupby("line", observed=False)
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
    bus_delay_data,
    subway_delay_data,
    total_bus_delay_time_by_date,
    total_num_bus_delays_by_incident,
    total_num_subway_delays_by_incident,
    total_num_subway_delays_by_line,
    total_subway_delay_time_by_date
)
