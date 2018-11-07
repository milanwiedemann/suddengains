# suddengains: An R package for identifying sudden gains in psychological therapies
[![last-change](https://img.shields.io/badge/Last%20change-2018--10--27-brightgreen.svg)](https://github.com/milanwiedemann/suddengains) 
[![suddengains-version](https://img.shields.io/badge/Version-0.0.1-brightgreen.svg)](https://github.com/milanwiedemann/suddengains) 
[![minimal-R-version](https://img.shields.io/badge/R%3E%3D-3.4.3-brightgreen.svg)](https://cran.r-project.org/)
[![licence](https://img.shields.io/badge/Licence-GPL--3-brightgreen.svg)](https://choosealicense.com/licenses/gpl-3.0/)

Identify sudden gains based on the criteria outlined by [Tang and DeRubeis (1999)](http://psycnet.apa.org/buy/1999-01811-008). 
It applies all three criteria to a dataset while adjusting for missing values. 
It calculated further variables that are of interest. 
It handles multiple gains by creating two datasets, one structured by sudden gain and one by participant. 
It also implements a function to specify which sudden gains to choose in case of multiple gains (earliest or largest gain). 
These [slides](https://docs.google.com/presentation/d/14OcAsBl8PIoIw5-eNO-_1uAXqfLHQcEGBT7M0MUWE9E/edit?usp=sharing) illustrate some functions of the `suddengains` package and some help how to use the package are shown below.

## Installation

First, you need to install the devtools package to download the `suddengains` package from this GitHub repository.

```r
install.packages("devtools")
```

To install the current stable version of `suddengains` package:

```r
devtools::install_github(repo = "milanwiedemann/suddengains")
```

## Overview of the functions

The `suddengains` package comes with a range of features which can be categorised into:

1. Functions to identify and extract sudden gains:
  - `select_cases()`: work in progress
  - `define_crit1_cutoff()`: stable
  - `identify_sg()`: stable
  - `identify_sl()`: stable

  
2. Functions to create datasets for further analysis:
  - `extract_scores()`: work in progress
  - `create_byperson()`: work in progress
  - `create_bysg()`: work in progress

3. Helper functions to visualise and report sudden gains:
  - `count_intervals()`: stable
  - `plot_sg()`: stable
  - `plot_sg_group()`: stable

## How to use `suddengains`

Here are a few examples how to use the `suddengains` package.
You need to be familiar with the [pipe](https://magrittr.tidyverse.org/) ` %>% ` operator to understand the examples.

First, load all needed packages and datasets:

```r
# Load packages ----
library(tidyverse) # Bundle of useful packages for manipulating data
library(haven) # Package to load SPSS datafiles in R
library(suddengains) # Identify and extract sudden gains

# Load data ----
# Load data with weekly measures from a csv file:
# Select ID variable, all weekly measures and a variable with the end of treatment scores
data <- read_csv("~/data.csv") %>% 
  select(id, measure_s0:measure_s12, measure_end) 

# Load data with weekly measures from a SPSS file:
data <- read_sav("~/data.sav") %>% 
  select(id, measure_s0:measure_s12, measure_end) 


# Load item by item data for sudden gains measure from baseline
# Select all item by item variables for the sudden gains measure
data_s0 <- read_csv("~/data_measure_01_s0.csv") %>% 
  select(measure_01_item1_s0:measure_01_item22_s0)
```

Then define the cut-off value fir the first sudden gains criterion using the reliable change index based on suggestions from [Stiles et al. (2003)](http://psycnet.apa.org/buy/2003-01069-004)
and select all cases in the dataset that provide enough information to aplly the sudden gains criteria.

```r
# Define cut-off for first sudden gains criterion using the reliable change index
define_crit1_cutoff(data_sessions = data, 
                    data_item = data_s0)

# Select all patients providing enough data to identify sudden gains
data_s0 <- select_cases(data_s0) %>%
  filter(sg_select == 1) %>%
  select(id) %>%
  left_join(data_s0, by = "id")
```

Now, you can use the `create_bysg()` and `create_byperson()` functions to create the dataets.

```r
# Create bysg dataset
data_bysg <- create_bysg(data = data, 
                         # The value for 'cutoff' comes from the define_crit1_cutoff() function
                         cutoff = 6.705612,
                         id_var_name = "id", 
                         sg_var_name = "measure_01_s", 
                         var_start = "measure_01_s0",
                         identify_sg_1to2 = FALSE,
                         include_s0_extract = TRUE)

# Create byperson dataset
# This function automatically selects the first sudden gain in case of multiple sudden gains
data_byperson <- create_byperson(data = data, 
                                 bysg_data = data_bysg)
```

If you are interested in extracting other measures around the time of the sudden gain you can use the  `extract_scores()` function:

```r
# Extract scores of measure_02 and measure_03 around the sudden gain (measure_01)
# The scores will be added to the byperson dataframe

data_byperson <- extract_scores(data_byperson, "measure_02")
data_byperson <- extract_scores(data_byperson, "measure_03")
```

## TODO

- [ ] For identify sg  / sl add option to specify which variables from dataset should be used and then send these variables to a rename function so that all the code is independent from variable names in a specific dataset
- [ ] For define_crit1_cutoff(), add option to input internal consistency by hand, so that it doesnt have to be calculated on item by item data
- [ ] Add sample dataset, this should include cases where critical value gets adjusted due to missing values (BDI data with cut-off 7?)
- [ ] Add function that prints all descriptives of sudden gains (e.g. number of gains, average magnitude) and call this `describe_sg()`
- [ ] Add function to export bysg or byperson dataset into other formats (SPSS, Excel, csv).

