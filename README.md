# suddengains: R package for identifying sudden gains in psychological therapies

Identify sudden gains based on the criteria outlined by [Tang and DeRubeis (1999)](http://psycnet.apa.org/buy/1999-01811-008). 
It applies all three criteria to a dataset while adjusting for missing values. 
It calculated further variables that are of interest. 
It handles multiple gains by creating two datasets, one structured by sudden gain and one by participant. 
It also implements a function to specify which sudden gains to choose in case of multiple gains (earliest or largest gain). 
See below for more information and examples.

## Installation

First, you need to install the devtools package to download the suddengains package from this GitHub repository.

```r
install.packages("devtools")
```

To install the current stable version of suddengains package:

```r
devtools::install_github(repo = "milanwiedemann/suddengains")
```

To install the current stable version of suddengains package with updated plot function:

```r
devtools::install_github(repo = "milanwiedemann/suddengains", ref = "fix-plots")
```

## Overview of the functions

The suddengains package comes with a range of features which can be categorised into:

1. Functions to identify and extract sudden gains:
  - `select_cases()`
  - `define_crit1_cutoff()`
  - `identify_sg()`
  
2. Functinos to creatw datasets for further analysis:
  - `create_byperson()`
  - `create_bysg()`
  - `extract_scores()`

3. Helper functions to visualise and report sudden gains:
  - `count_intervals()`
  - `plot_sg()`

## How to use suddengains

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

## Random notes

- [ ] Add sample dataset, this should include cases where critical value gets adjusted due to missing values
- [ ] Add feature to identify "sudden losses" as part of the `identify_sg(..., suddenlosses = TRUE)` function with a 
- [ ] Add function that prints all descriptives of sudden gains (e.g. number of gains, average magnitude) and call this `describe_sg()`

- need to tidy this up at some point!
some functions wont work if the measure of the variable that the sudden gains are being analysed on starts with "sg".
this will conflict with the variables that get created for the bysg and byperson datasets.
there I think it shold be recommended to rename variables in this special case!

- variables for identify sg must be numbered in a specific way. alpha (e.g. 'w' for week or 's' for session) and then session number in digit.
this is important as identify function automaticall checks for s0 intake score. 
if this is provided it will calculate sg after the first session and name variables in that way starting with sg_1to2
if s0 is not provided it will name variables starting with sg_2to3
