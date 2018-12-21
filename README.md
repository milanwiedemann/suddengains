# suddengains: An R package for identifying sudden gains in longitudinal data
[![last-change](https://img.shields.io/badge/Last%20change-2018--12--21-brightgreen.svg)](https://github.com/milanwiedemann/suddengains) 
[![suddengains-version](https://img.shields.io/badge/Version-0.0.1.9903-brightgreen.svg)](https://github.com/milanwiedemann/suddengains) 
[![minimal-R-version](https://img.shields.io/badge/R%3E%3D-3.4.3-brightgreen.svg)](https://cran.r-project.org/)
[![licence](https://img.shields.io/badge/Licence-GPL--3-brightgreen.svg)](https://choosealicense.com/licenses/gpl-3.0/)

Identify sudden gains based on the criteria outlined by [Tang and DeRubeis (1999)](http://psycnet.apa.org/buy/1999-01811-008). 
It applies all three criteria to a dataset while adjusting for missing values. 
It calculates further variables that are of interest. 
It handles multiple gains by creating two datasets, one structured by sudden gain and one by participant. 
It also implements a function to specify which sudden gains to choose in case of multiple gains (earliest or largest gain).

## Installation

First, you need to install the devtools package to download the `suddengains` package from this GitHub repository.

```r
install.packages("devtools")
```

To install the developement version of `suddengains` package:

```r
devtools::install_github(repo = "milanwiedemann/suddengains", ref = "dev")
```

## Overview of the functions

The `suddengains` package comes with a range of features which can be categorised into:

1. Functions to identify and extract sudden gains:
  - `select_cases()`: stable
  - `define_crit1_cutoff()`: testing
  - `identify_sg()`: stable
  - `identify_sl()`: testing
  
2. Functions to create datasets for further analysis:
  - `extract_values()`: stable
  - `create_byperson()`: stable
  - `create_bysg()`: stable

3. Helper functions to visualise and report sudden gains:
  - `count_intervals()`: stable
  - `plot_sg()`: stable
  - `plot_sg_group()`: stable
  - `describe_sg()`: testing

## How to use `suddengains`

Here are a few examples how to use the `suddengains` package.
First, load all required packages and datasets.
This package also contains two sample data sets with made up data to test and illustrate the functions.

```r
# Load packages ----
library(devtools)
library(tidyverse)
library(suddengains)

# Load data ----
# Two example data sets get loaded together with the suddengains package

# The data sets have identical data, "sgdata_bad" has inconsistent variable names 
View(sgdata)
View(sgdata_bad)

# Create vectors with all variable names as input argument for the functions
# This is not neccessary, but saves some time typing
bdi_var_list_s0_to_s12 <- c("bdi_s0", "bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", "bdi_s5", "bdi_s6", 
                            "bdi_s7", "bdi_s8", "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12")

pds_var_list_s0_to_s12 <- c("pds_s0", "pds_s1", "pds_s2", "pds_s3", "pds_s4", "pds_s5", "pds_s6", 
                            "pds_s7", "pds_s8", "pds_s9", "pds_s10", "pds_s11", "pds_s12")
```

The cut-off value for the first sudden gains criterion can be calculated using the reliable change index based on suggestions from [Stiles et al. (2003)](http://psycnet.apa.org/buy/2003-01069-004).
The function has the option to calculate Chronbach's a based in item-by-item data if provided, or alternatively the reliability of the measure can be specified.

```r
# Define cut-off for first sudden gains criterion using the reliable change index
define_crit1_cutoff(data_sessions = sgdata,
                    data_item = NULL,
                    tx_start_var_name = "bdi_s0",
                    tx_end_var_name = "bdi_s12",
                    reliability = .93)
```

Next, select all cases for the sudden gains analysis. 
The package currently implements two methods to select cases:
1. Select all cases with a minimum number of repeated measurements available: `method = "min_sess"`
1. Select all that provide enough data to apply the three sudden gains criteria: `method = "pattern"`

```r
# 1. Select all cases with a minimum of available values over the whole course of repeated measurements
select_cases(data = sgdata, 
             id_var_name = "id", 
             sg_var_list = bdi_var_list_s0_to_s12, 
             method = "min_sess", 
             min_sess_num = 9, 
             return_id_lgl = TRUE)
```

An alternative option is to select all cases where it is possible to apply all three sudden gains criteria. 
This function goes through the data and selects all cases with at least one of the following data patterns.

| Data pattern | x<sub>1</sub> | x<sub>2</sub> | x<sub>3</sub> | x<sub>4</sub> | x<sub>5</sub> | x<sub>6</sub> |
|:------------:|-------|-------|-------|-------|-------|-------|
| 1.           |   x   | **X** |   x   |   x   |       |       |
| 2.           |   x   |   x   | **X** |       |   x   |       |
| 3.           |   x   |       | **X** |   x   |   x   |       |
| 4.           |   x   |       | **X** |   x   |       |   x   |

*Note:* x<sub>1</sub> to x<sub>6</sub> are consecutive data points of the primary outcome measure. x = Available data; Empty cell = Missing data. Bold **X** represent the pregain session for each pattern.

```r
# 2. Select all patients providing enough data to identify sudden gains ----
select_cases(data = sgdata, 
             id_var_name = "id", 
             sg_var_list = bdi_var_list_s0_to_s12, 
             method = "pattern", 
             return_id_lgl = FALSE)
```

Now, you can use the `create_bysg()` and `create_byperson()` functions to create the data sets.

```r
# Create bysg dataset
# This data set has one row per gain and creates a new ID variable for each sudden gain
bysg <- create_bysg(data = sgdata,
                    cutoff = 7,
                    id_var_name = "id",
                    tx_start_var_name = "bdi_s1",
                    tx_end_var_name = "bdi_s12",
                    sg_var_list = bdi_var_list_s0_to_s12,
                    sg_var_name = "bdi",
                    identify_sg_1to2 = TRUE,
                    include_s0_extract = TRUE)

# Create byperson dataset
# This function can select the "first", "last", "smallest", or "largest" sudden gain in cases of multiple sudden gains using the "multiple_sg_select" argument.
byperson <- create_byperson(data = sgdata,
                            cutoff = 7,
                            id_var_name = "id",
                            tx_start_var_name = "bdi_s1",
                            tx_end_var_name = "bdi_s12",
                            sg_var_list = bdi_var_list_s0_to_s12,
                            sg_var_name = "bdi",
                            identify_sg_1to2 = TRUE,
                            include_s0_extract = TRUE,
                            multiple_sg_select = "first")
```

If you are interested in extracting other measures around the time of the sudden gain you can use the  `extract_values()` function. 
You need to be familiar with the [pipe](https://magrittr.tidyverse.org/) ` %>% ` operator to understand the examples.

```r
# Extract values of PDS values around the sudden gain (BDI)
# For bysg dataset add PDS variables need to be added from the main data set first
bysg <- bysg %>%
    left_join(select(sgdata, id, starts_with("pds")), by = "id")

# Extract scores for bysg dataset and save to new dataframe
pds_extract_bysg <- extract_values(data = bysg,
                                   id_var_name = "id_sg",
                                   extract_var_list = pds_var_list_s0_to_s12,
                                   extract_var_name = "pds",
                                   include_s0_extract = TRUE)

# Extract scores for byperson dataset and save to new dataframe
pds_extract_byperson <- extract_values(data = byperson,
                                       id_var_name = "id",
                                       extract_var_list = pds_var_list_s0_to_s12,
                                       extract_var_name = "pds",
                                       include_s0_extract = TRUE)

# Now join the extracted PDS scores with main bysg and byperson dataset
bysg <- bysg %>%
    left_join(pds_extract_bysg, by = "id_sg")

byperson <- byperson %>%
    left_join(pds_extract_byperson, by = "id")
```

The package also offers a function to visualise the average magnitude of sudden gains in relation to the overall change of cases with sudden gains.
Here is code to create a figure of the average gain magnitude.

```r
plot_sg(data = bysg,
        tx_start_var_name = "bdi_s0",
        tx_end_var_name = "bdi_s12",
        sg_pre_post_var_list = c("sg_bdi_2n", "sg_bdi_1n", "sg_bdi_n", 
                                 "sg_bdi_n1", "sg_bdi_n2", "sg_bdi_n3"),
        ylabel = "BDI")
```

![](https://dl.dropboxusercontent.com/s/fpjvbgg9yizji9z/sg-bdi-average-magnitude.png)

Here is code to create a figure of the average change of PDS scores around the sudden gain on the BDI.

```r
plot_sg(data = bysg,
        tx_start_var_name = "pds_s1",
        tx_end_var_name = "pds_s12",
        sg_pre_post_var_list = c("sg_pds_2n", "sg_pds_1n", "sg_pds_n", 
                                 "sg_pds_n1", "sg_pds_n2", "sg_pds_n3"),
        ylabel = "PDS")
```

![](https://dl.dropboxusercontent.com/s/0vvsrchayci92e9/sg-bdi-everage-change-pds.png)

## TODO
- [x] For identify sg  / sl add option to specify which variables from data set should be used and then send these variables to a rename function so that all the code is independent from variable names in a specific data set
- [x] For define_crit1_cutoff(), add option to input internal consistency by hand, so that it doesn't have to be calculated on item by item data
- [x] Add sample data set, this should include cases where critical value gets adjusted due to missing values (BDI data with cut-off 7?)
- [x] Add function that prints all descriptives of sudden gains (e.g. number of gains, average magnitude) and call this `describe_sg()`
- [ ] Add function or description to export bysg or byperson dataset into other formats (SPSS, Excel, csv).

