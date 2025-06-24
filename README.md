# TTC Analysis

## Paper Overview

This paper analyzes the different direct or indirect potential causes of delays that affect the TTC transit system. In particular the paper focuses on subway and bus delays in which commuters most commonly use. It was created with the intent to incite further in-depth analysis on the causes of the increase in delays.


## File Structure
```text
ttc_analysis/
├── .gitignore
├── LICENSE.md
├── README.md
├── ttc_analysis.Rproj
├── inputs
│   ├── data
│   │   ├── raw_data.csv
|   |   ├── filtered_or_selected_data.csv
│   │   └── ...
├── outputs
│   ├── data
│   │   ├── cleaned_data.csv
│   │   |── ...
|   │   └── summaries
|   │       ├── summarized_data.csv
|   │       └── ...
│   ├── paper.pdf
│   ├── paper.qmd
│   └── references.bib
├── scripts
│   ├── 00-simulate_data.py
│   ├── 01-download_data.py
│   ├── 02-data_cleaning.py
│   ├── 03-parse_codes.py        // 03=> Converting code to descriptions 
|   |                           //  and grouping classes together
│   └── 04-summarise_data.py     // 04=> Averaging, summing and other ways
|                               //  of summarizing the data which is
|                               // then stored in outputs/data/summaries/*
└── ...
```

-   `input/data` contains the raw data collected from `opendatatoronto` and datasets that have been filtered and selected but not mutated.
-   `outputs/data` contains the cleaned dataset that was constructed from the scripts, the data that is used for analysis within the final report paper.
-   `outputs/data/summaries` contains summarized information from the datasets in the outer folder
-   `outputs/` (The outer folder) contains the resources for rendering the paper and the paper itself. (`paper.pdf`) 
-   `scripts` contains the Python scripts used to simulate, download and clean data.


## Running Scripts

The numbers preceding the names of all the `Python` scripts under the scripts folder represent the order in which they should be run. If anything changes with the file names, the prerequisites for each script file is in the preamble section. 

The names of the files also represent what they each do, please see the comments made beside `03` and `04` above for explanation. If anything happens to the file names, the purpose of each script is stated in the preamble as well.

Each script cleans up its own variables from the global environment. In some instances the same variable is used elsewhere, running a script may clean that variable regardless. Since everything is reproducible, you should have no issue reaching the same point as you were before. This is just a warning if you decide to debug or run snippets of this project.