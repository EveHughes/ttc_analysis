#### Preamble ####
# Purpose: Simulate delay data
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: None


#### Workspace setup ####
library(tidyverse)


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
num_subway_delays <- rpois(1, 20,000)

# Assumption that there are more bus delays (strong base since bus delay 
# dataset is twice the size) and subway delays and bus delays are correlated
num_bus_delays <- 1.5 * num_subway_delays
 


# Simulate delays happening
set.seed(302)

sim_data_subway <-
  tibble(
    "day" = sim_operating_days
    # TODO use the probabilites to generate data
  )


# Testing

# Test that the incident types are limited to the set

# Test that there are only 7 unique days

# Test that delay times are all positive and reasonable; 
# between 1 minute to 5 hours 

