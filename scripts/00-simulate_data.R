#### Preamble ####
# Purpose: Simulate delay data
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: None


#### Workspace setup ####
library(tidyverse)
#### Preamble ####
# Purpose: Simulate delay data
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: None


#### Workspace setup ####
library(tidyverse)
set.seed(302)

## Simulated situation attributes ##

# The possible incident types causing the delay
sim_incident_types <- 
  c(
    "Equipment/Mechanical", 
    "Miscellaneous", 
    "Security/Safety", 
    "Operator"
  )

# Expected distribution of incident types
sim_incident_probabilities <-
  c(
    0.3,
    0.2,
    0.4,
    0.2
  )

# The days of the week the buses and subways operate
sim_operating_days <-
  c(
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  )

# Assumption that delays change depending on the day
sim_probability_of_subway_delay <-
  c(
    0.18, # Sort of high on Sundays
    0.14, # Slightly lower as people go back to school/work
    0.10, # Low on Tuesday
    0.10, # Low on Wednesday
    0.11, # Low on Thursday
    0.17, # High on Friday
    0.20  # High on Saturday
  )

# Sample 1 time from a possion dist with an average
# of 20,000 delays in 1 day
num_subway_delays <- rpois(1, 20000)

# Assumption that there are more bus delays (strong base since bus delay 
# dataset is twice the size) and subway delays and bus delays are correlated
num_bus_delays <- 1.5 * num_subway_delays


## Simulated situation attributes ##

# The possible incident types causing the delay
sim_incident_types <- 
  c(
    "Equipment/Mechanical", 
    "Miscellaneous", 
    "Security/Safety", 
    "Operator"
  )

# Expected distribution of incident types
sim_incident_probabilities <-
  c(
    0.3,
    0.2,
    0.4,
    0.2
  )

# The days of the week the buses and subways operate
sim_operating_days <-
  c(
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  )

# Assumption that delays change depending on the day
sim_probability_of_subway_delay <-
  c(
    0.18, # Sort of high on Sundays
    0.14, # Slightly lower as people go back to school/work
    0.10, # Low on Tuesday
    0.10, # Low on Wednesday
    0.11, # Low on Thursday
    0.17, # High on Friday
    0.20  # High on Saturday
  )

# Sample 1 time from a possion dist with an average
# of 20,000 delays in 1 day
num_subway_delays <- rpois(1, 20000)

# Assumption that there are more bus delays (strong base since bus delay 
# dataset is twice the size) and subway delays and bus delays are correlated
num_bus_delays <- 1.5 * num_subway_delays
 


# Simulate delays happening
sim_data_subway <-
  tibble(
    "day" = sample(
      sim_operating_days, 
      num_subway_delays, 
      prob = sim_probability_of_subway_delay, 
      replace = TRUE
    ),
    "incident" = sample(
      sim_incident_types, 
      num_subway_delays, 
      prob = sim_incident_probabilities, 
      replace = TRUE
    ), 
    "delay_time" = rpois(
      n = num_subway_delays,
      lambda = 30 # Average of a 30 + 1 minute delay time
    ) + 1 # + 1 so that min is 1 minute delay time
  )

sim_data_bus <-
  tibble(
    "day" = sample(
      sim_operating_days, 
      num_bus_delays, 
      prob = sim_probability_of_subway_delay, 
      replace = TRUE
    ),
    "incident" = sample(
      sim_incident_types, 
      num_bus_delays, 
      prob = sim_incident_probabilities, 
      replace = TRUE
    ), 
    "delay_time" = rpois(
      n = num_bus_delays,
      lambda = 30 # Average of a 30 + 1 minute delay time
    ) + 1 # + 1 so that min is 1 minute delay time
  )

# Display the data
sim_data_subway
sim_data_bus

# Visualize the data

### TODO ggplot


# Testing

# Test that the incident types are limited to the set
sim_data_subway$incident |> 
  unique() |>
  setequal(sim_incident_types)

sim_data_bus$incident |> 
  unique() |>
  setequal(sim_incident_types)


# Test that there are only 7 unique days
sim_data_subway$day |>
  unique() |>
  length() == 7

sim_data_bus$day |>
  unique() |>
  length() == 7

# Test that delay times are all positive and reasonable; 
# (between 1 minute to 5 hours) 
sim_data_subway$delay_time |>
  min() >= 1
sim_data_subway$delay_time |>
  max() <= 60 * 5

sim_data_bus$delay_time |>
  min() >= 1
sim_data_bus$delay_time |>
  max() <= 60 * 5

# Clean up workspace
rm(list = ls())
