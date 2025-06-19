#### Preamble ####
# Purpose: Download TTC delay data from opendatatoronto
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: none


delay_stats_url = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/996cfe8d-fb35-40ce-b569-698d51fc683b/resource/3900e649-f31e-4b79-9f20-4731bbfd94f7/download/ttc-subway-delay-codes.xlsx"
delay_code_url = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/996cfe8d-fb35-40ce-b569-698d51fc683b/resource/2fbec48b-33d9-4897-a572-96c9f002d66a/download/ttc-subway-delay-2023.xlsx"
bus_delay_url = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/e271cdae-8788-4980-96ce-6a5c95bc6618/resource/10802a64-9ac0-4f2e-9538-04800a399d1e/download/ttc-bus-delay-data-2023.xlsx"

#### Preamble ####
# Purpose: Download TTC delay data from opendatatoronto
# Author: Timothius Prajogi
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workplace setup ####

import pandas as pd
import requests
from io import BytesIO

#### Download and save TTC data ####

# Provided direct download links
delay_stats_url = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/996cfe8d-fb35-40ce-b569-698d51fc683b/resource/3900e649-f31e-4b79-9f20-4731bbfd94f7/download/ttc-subway-delay-codes.xlsx"
delay_code_url = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/996cfe8d-fb35-40ce-b569-698d51fc683b/resource/2fbec48b-33d9-4897-a572-96c9f002d66a/download/ttc-subway-delay-2023.xlsx"
bus_delay_url = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/e271cdae-8788-4980-96ce-6a5c95bc6618/resource/10802a64-9ac0-4f2e-9538-04800a399d1e/download/ttc-bus-delay-data-2023.xlsx"

# Subway delay codes
response = requests.get(delay_stats_url)
df_subway_codes = pd.read_excel(BytesIO(response.content), header=1)
df_subway_codes.to_csv("inputs/data/raw_subway_delay_codes.csv", index=False)

# Subway delay statistics
response = requests.get(delay_code_url)
df_subway_stats = pd.read_excel(BytesIO(response.content))
df_subway_stats.to_csv("inputs/data/raw_subway_delay_statistics.csv", index=False)

# Bus delay statistics
response = requests.get(bus_delay_url)
df_bus_stats = pd.read_excel(BytesIO(response.content))
df_bus_stats.to_csv("inputs/data/raw_bus_delay_statistics.csv", index=False)

# Clean up workspace
del df_subway_codes
del df_subway_stats
del df_bus_stats