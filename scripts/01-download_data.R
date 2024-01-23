#### Preamble ####
# Purpose: Download TTC delay data from opendatatoronto
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workplace setup ####

library(opendatatoronto)
library(tidyverse)

#### Download and save TTC data ####

## Subway delay data
## -----------------
## 996cfe8d-fb35-40ce-b569-698d51fc683b -> Package
## 2fbec48b-33d9-4897-a572-96c9f002d66a -> Delay Statistics Resource 
## 3900e649-f31e-4b79-9f20-4731bbfd94f7 -> Delay Code Meaning Resource

raw_subway_data <- 
  list_package_resources("996cfe8d-fb35-40ce-b569-698d51fc683b") |> 
  filter (id == "2fbec48b-33d9-4897-a572-96c9f002d66a") |> 
  get_resource() 

write_csv(raw_subway_data, 'inputs/data/raw_subway_delay_statistics.csv')

subway_delay_codes <- 
  list_package_resources("996cfe8d-fb35-40ce-b569-698d51fc683b") |> 
  filter (id == "3900e649-f31e-4b79-9f20-4731bbfd94f7") |> 
  get_resource()

write_csv(subway_delay_codes, 'inputs/data/raw_subway_delay_codes.csv')

## Bus delay data
## --------------
## e271cdae-8788-4980-96ce-6a5c95bc6618 -> Package
## 10802a64-9ac0-4f2e-9538-04800a399d1e -> Resource

raw_bus_data <-
  list_package_resources("e271cdae-8788-4980-96ce-6a5c95bc6618") |> 
  filter (id == "10802a64-9ac0-4f2e-9538-04800a399d1e") |> 
  get_resource() 

write_csv(raw_bus_data, 'inputs/data/raw_bus_delay_statistics.csv')

# Clean up workspace
rm(list = ls())


