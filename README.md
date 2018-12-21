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
You need to be familiar with the [pipe](https://magrittr.tidyverse.org/) ` %>% ` operator to understand the examples.

First, load all required packages and datasets:

```r
# Load packages ----
library(devtools)
library(tidyverse)
library(suddengains)

# Load data ----
# Two example data sets get loaded together with the suddengains package

# The data sets have identical data, "sgdata_bad" has inconsistent variable names 
sgdata
sgdata_bad
```

Then define the cut-off value for the first sudden gains criterion using the reliable change index based on suggestions from [Stiles et al. (2003)](http://psycnet.apa.org/buy/2003-01069-004).
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
| 1.           | **X** | **X** | **X** | **X** |   -   |   -   |
| 2.           | **X** | **X** | **X** |   -   | **X** |   -   |
| 3.           | **X** |   -   | **X** | **X** | **X** |   -   |
| 4.           | **X** |   -   | **X** | **X** |   -   | **X** |

*Note:* x<sub>1</sub> to x<sub>6</sub> are consecutive data points of the primary outcome measure. x = Available data; -  = Missing data.

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

If you are interested in extracting other measures around the time of the sudden gain you can use the  `extract_values()` function:

```r
# Extract scores of measure_02 and measure_03 around the sudden gain (measure_01)
# For bysg dataset add pds variables first
bysg <- bysg %>%
    left_join(select(sgdata, id, starts_with("pds")), by = "id")

# Extract scores for bysg dataset
pds_extract_bysg <- extract_values(data = bysg,
                                   id_var_name = "id_sg",
                                   extract_var_list = pds_var_list_s0_to_s12,
                                   extract_var_name = "pds",
                                   include_s0_extract = TRUE)

# Extract scores for byperson dataset
pds_extract_byperson <- extract_values(data = byperson,
                                       id_var_name = "id",
                                       extract_var_list = pds_var_list_s0_to_s12,
                                       extract_var_name = "pds",
                                       include_s0_extract = TRUE)

# Join extracted pds scores with main bysg and byperson dataset
bysg <- bysg %>%
    left_join(pds_extract_bysg, by = "id_sg")

byperson <- byperson %>%
    left_join(pds_extract_byperson, by = "id")
```

The package also offers a function to visualise the average magnitude of sudden gains in relation to the overall change of cases with sudden gains.


```r
plot_sg(data = bysg,
        tx_start_var_name = "bdi_s0",
        tx_end_var_name = "bdi_s12",
        sg_pre_post_var_list = c("sg_bdi_2n", "sg_bdi_1n", "sg_bdi_n", 
                                 "sg_bdi_n1", "sg_bdi_n2", "sg_bdi_n3"),
        ylabel = "BDI")

plot_sg(data = bysg,
        tx_start_var_name = "pds_s1",
        tx_end_var_name = "pds_s12",
        sg_pre_post_var_list = c("sg_pds_2n", "sg_pds_1n", "sg_pds_n", 
                                 "sg_pds_n1", "sg_pds_n2", "sg_pds_n3"),
        ylabel = "PDS")
```

## TODO
- [x] For identify sg  / sl add option to specify which variables from data set should be used and then send these variables to a rename function so that all the code is independent from variable names in a specific data set
- [x] For define_crit1_cutoff(), add option to input internal consistency by hand, so that it doesn't have to be calculated on item by item data
- [x] Add sample data set, this should include cases where critical value gets adjusted due to missing values (BDI data with cut-off 7?)
- [x] Add function that prints all descriptives of sudden gains (e.g. number of gains, average magnitude) and call this `describe_sg()`
- [ ] Add function or description to export bysg or byperson dataset into other formats (SPSS, Excel, csv).

