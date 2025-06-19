#### Preamble ####
# Purpose: Simulate delay data
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: None


#### Workspace setup ####
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(302)


## Simulated situation attributes ##

# The possible incident types causing the delay
sim_incident_types = [
    "Equipment/Mechanical",
    "Miscellaneous",
    "Security/Safety",
    "Operator"
]

# Expected distribution of incident types
sim_incident_probabilities = [
    0.3,
    0.2,
    0.4,
    0.2
]

# The days of the week the buses and subways operate
sim_operating_days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
]

# Assumption that delays change depending on the day
sim_probability_of_subway_delay = [
    0.18,  # Sort of high on Sundays
    0.14,  # Slightly lower as people go back to school/work
    0.10,  # Low on Tuesday
    0.10,  # Low on Wednesday
    0.11,  # Low on Thursday
    0.17,  # High on Friday
    0.20   # High on Saturday
]

# Sample 1 time from a possion dist with an average
# of 20,000 delays in 1 day
num_subway_delays = np.random.poisson(20000)

# Assumption that there are more bus delays (strong base since bus delay 
# dataset is twice the size) and subway delays and bus delays are correlated
num_bus_delays = int(1.5 * num_subway_delays)


## Simulated situation attributes ##

# The possible incident types causing the delay
sim_incident_types = [
    "Equipment/Mechanical",
    "Miscellaneous",
    "Security/Safety",
    "Operator"
]

# Expected distribution of incident types
sim_incident_probabilities = [
    0.3,
    0.2,
    0.4,
    0.2
]

# The days of the week the buses and subways operate
sim_operating_days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
]

# Assumption that delays change depending on the day
sim_probability_of_subway_delay = [
    0.18,  # Sort of high on Sundays
    0.14,  # Slightly lower as people go back to school/work
    0.10,  # Low on Tuesday
    0.10,  # Low on Wednesday
    0.11,  # Low on Thursday
    0.17,  # High on Friday
    0.20   # High on Saturday
]

# Sample 1 time from a possion dist with an average
# of 20,000 delays in 1 day
num_subway_delays = np.random.poisson(20000)

# Assumption that there are more bus delays (strong base since bus delay 
# dataset is twice the size) and subway delays and bus delays are correlated
num_bus_delays = int(1.5 * num_subway_delays)


# Simulate delays happening
sim_data_subway = pd.DataFrame({
    "day": np.random.choice(sim_operating_days, size=num_subway_delays, p=sim_probability_of_subway_delay),
    "time": np.random.normal(loc=17, scale=6, size=num_subway_delays) % 24,
    "incident": np.random.choice(sim_incident_types, size=num_subway_delays, p=sim_incident_probabilities),
    "delay_time": np.random.poisson(lam=30, size=num_subway_delays) + 1
})

sim_data_bus = pd.DataFrame({
    "day": np.random.choice(sim_operating_days, size=num_bus_delays, p=sim_probability_of_subway_delay),
    "time": np.random.normal(loc=17, scale=6, size=num_bus_delays) % 24,
    "incident": np.random.choice(sim_incident_types, size=num_bus_delays, p=sim_incident_probabilities),
    "delay_time": np.random.poisson(lam=30, size=num_bus_delays) + 1
})

# Display the data
print(sim_data_subway)
print(sim_data_bus)

# Visualize a sample for the data

# Allow for display of plots side by side
plt.figure(figsize=(12, 4))

plt.subplot(1, 3, 1)
plt.hist(sim_data_subway["time"], bins=np.arange(0, 24.2, 0.2), color="blue", alpha=0.75)
plt.title("A simulation of the amount of delays at a given time")
plt.xlabel("Time (in military time hrs)")
plt.ylabel("Number of delays")

plt.tight_layout()
plt.show()


# Testing

# Test that the incident types are limited to the set
print(set(sim_data_subway["incident"].unique()) == set(sim_incident_types))
print(set(sim_data_bus["incident"].unique()) == set(sim_incident_types))

# Test that there are only 7 unique days
print(len(sim_data_subway["day"].unique()) == 7)
print(len(sim_data_bus["day"].unique()) == 7)

# Test that delay times are all positive and reasonable; 
# (between 1 minute to 5 hours) 
print(sim_data_subway["delay_time"].min() >= 1)
print(sim_data_subway["delay_time"].max() <= 60 * 5)

print(sim_data_bus["delay_time"].min() >= 1)
print(sim_data_bus["delay_time"].max() <= 60 * 5)

# Clean up workspace
del (
    num_bus_delays,
    num_subway_delays,
    sim_data_bus,
    sim_data_subway,
    sim_incident_probabilities,
    sim_incident_types,
    sim_operating_days,
    sim_probability_of_subway_delay
)
