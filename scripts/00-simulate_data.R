#### Preamble ####
# Purpose: Simulate delay data
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: None


#### Workspace setup ####
library(tidyverse)


# Simulated situation attributes
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
    0.44, # Sort of high on Sundays
    0.33, # Slightly lower as people go back to school/work
    0.21, # Low on Tuesday
    0.30, # Low on Wednesday
    0.27, # Low on Thursday
    0.51, # High on Friday
    0.54  # High on Saturday
  )

# Assumption that there are more bus delays (strong base since bus delay 
# dataset is twice the size) and subway delays and bus delays are correlated
sim_probability_of_bus_delay <- 1.5 * sim_probability_of_subway_delay


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

