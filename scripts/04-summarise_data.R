#### Preamble ####
# Purpose: Group delay data into similar sets of incidents
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01-download_data, 02-clean_data

#### Workspace setup ####
library(tidyverse)

# Read in bus data
bus_delay_data <- 
  read_csv(
    file = "outputs/data/cleaned_bus_delay_statistics.csv",
    show_col_types = FALSE
  )

# Enforce ordering of days
bus_delay_data$day <- factor(bus_delay_data$day, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Summarize into average number of delays per day of the week (Mon, Tues, ...)
avg_num_bus_delays_by_day <-
  bus_delay_data |> 
  group_by(date, day) |> 
  summarise(n = n(), .groups = "keep") |>
  group_by(day) |>
  summarise(mean_num_delays = mean(n))

# Summarize into total delay time and number of delays per date (Jan 1st, 2nd, ...)
total_bus_delay_time_by_date <-
  bus_delay_data |> 
  group_by(date, day) |> 
  summarise(
    total_delay_time = sum(min_delay), 
    n = n(), 
    mean_delay_time = (total_delay_time / n),
    .groups = "keep")

# Summarize into the total number of delays per incident type (e.g. Equipment/Mechanical)
total_num_bus_delays_by_incident <-
  bus_delay_data |>
  group_by(incident) |>
  summarise(n = n())

# Read in subway data
subway_delay_data <- 
  read_csv(
    file = "outputs/data/cleaned_subway_delay_statistics.csv",
    show_col_types = FALSE
  )

# Enforce ordering of days
subway_delay_data$day <- factor(subway_delay_data$day, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Summarize into average number of delays per day of the week (Mon, Tues, ...)
avg_num_subway_delays_by_day <-
  subway_delay_data |> 
  group_by(date, day) |> 
  summarise(n = n(), .groups = "keep") |>
  group_by(day) |>
  summarise(mean_num_delays = mean(n))

# Summarize into total delay time and number of delays per date (Jan 1st, 2nd, ...)
total_subway_delay_time_by_date <-
  subway_delay_data |> 
  group_by(date, day) |> 
  summarise(
    total_delay_time = sum(min_delay), 
    n = n(), 
    mean_delay_time = (total_delay_time / n),
    .groups = "keep")

# Summarize into the total number of delays per incident type (e.g. Equipment/Mechanical)
total_num_subway_delays_by_incident <-
  subway_delay_data |>
  group_by(incident) |>
  summarise(n = n())

# Summarize into the total number of delays per line (e.g. BY (Bloor-Yonge))
total_num_subway_delays_by_line <-
  subway_delay_data |>
  group_by(line) |>
  summarise(n = n())

# Save all the data

write_csv(avg_num_bus_delays_by_day, "outputs/data/summaries/avg_num_bus_delays_by_day.csv")
write_csv(avg_num_subway_delays_by_day, "outputs/data/summaries/avg_num_subway_delays_by_day.csv")

write_csv(total_num_bus_delays_by_incident, "outputs/data/summaries/total_num_bus_delays_by_incident.csv")
write_csv(total_num_subway_delays_by_incident, "outputs/data/summaries/total_num_subway_delays_by_incident.csv")

write_csv(total_bus_delay_time_by_date, "outputs/data/summaries/total_bus_delay_time_by_date.csv")
write_csv(total_subway_delay_time_by_date, "outputs/data/summaries/total_subway_delay_time_by_date.csv")

write_csv(total_num_subway_delays_by_line, "outputs/data/summaries/total_num_subway_delays_by_line.csv")

# Clean up workspace
rm(list = c(
  "avg_num_bus_delays_by_day",
  "avg_num_subway_delays_by_day",
  "bus_delay_data",
  "subway_delay_data",
  "total_bus_delay_time_by_date",
  "total_num_bus_delays_by_incident",
  "total_num_subway_delays_by_incident",
  "total_num_subway_delays_by_line",
  "total_subway_delay_time_by_date"  
))

