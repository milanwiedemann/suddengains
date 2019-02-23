# suddengains: An R package for identifying sudden gains in longitudinal data

[![last-change](https://img.shields.io/badge/Last%20change-2019--02--23-brightgreen.svg)](https://github.com/milanwiedemann/suddengains) 
[![suddengains-version](https://img.shields.io/badge/Version-0.0.2-brightgreen.svg)](https://github.com/milanwiedemann/suddengains) 
[![minimal-R-version](https://img.shields.io/badge/R%3E%3D-3.4.0-brightgreen.svg)](https://cran.r-project.org/)
[![licence](https://img.shields.io/badge/Licence-GPL--3-brightgreen.svg)](https://choosealicense.com/licenses/gpl-3.0/)

Check out our Preprint describing this package on [PsyArXiv](https://psyarxiv.com/2wa84/).
We have also created an open [Zotero group](https://www.zotero.org/groups/2280342/suddengains) with research looking at sudden gains. 
Please let me know if I missed anything or join the group and add papers yourself.

Identify sudden gains based on the criteria outlined by Tang and DeRubeis [(1999)](http://psycnet.apa.org/buy/1999-01811-008). 
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
devtools::install_github(repo = "milanwiedemann/suddengains")
```

## Overview of the functions

The `suddengains` package comes with a range of features which can be categorised into:

1. Functions to identify and extract sudden gains:
  - `select_cases()`: stable
  - `define_crit1_cutoff()`: stable
  - `identify_sg()`: stable
  - `identify_sl()`: stable
  
2. Functions to create datasets for further analysis:
  - `extract_values()`: stable
  - `create_byperson()`: stable
  - `create_bysg()`: stable

3. Helper functions to visualise and report sudden gains:
  - `count_intervals()`: stable
  - `plot_sg()`: stable
  - `describe_sg()`: stable
  
4. Helper functions to export data sets:
  - `write_bysg()`: in progress
  - `write_byperson()`: in progress
  
## How to use `suddengains`

Here are a few examples how to use the `suddengains` package.
First, load all required packages and datasets.
This package also contains two sample data sets with made up data to test and illustrate the functions.

```r
# Load packages ----
library(tidyverse)
library(suddengains)

# Load data ----
# Two example data sets get loaded together with the suddengains package

# The data sets have identical data, `sgdata_bad` has "messy" variable names to show that the
# functions also work with inconsistent variable names.
View(sgdata)
View(sgdata_bad)
```

The cut-off value for the first sudden gains criterion can be calculated using the reliable change index (RCI; Jacobson & Truax, [1991](https://psycnet.apa.org/record/1991-16094-001)) based on suggestions from Stiles et al. [(2003)](http://psycnet.apa.org/buy/2003-01069-004)).
The function has the option to calculate Chronbach's a based in item-by-item data if provided, or alternatively the reliability of the measure can be specified.

```r
# Define cut-off for first sudden gains criterion using the reliable change index
define_crit1_cutoff(data_sessions = sgdata,
                    data_item = NULL,
                    tx_start_var_name = "bdi_s0",
                    tx_end_var_name = "bdi_s12",
                    reliability = 0.93)
```

Next, select all cases for the sudden gains analysis. 
The package currently implements two methods to select cases:
1. Select all cases with a minimum number of repeated measurements available: `method = "min_sess"`
1. Select all that provide enough data to apply the three sudden gains criteria: `method = "pattern"`

```r
# 1. Select all cases with a minimum of available values over the whole course of repeated measurements
select_cases(data = sgdata, 
             id_var_name = "id", 
             sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", 
                             "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8", 
                             "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
             method = "min_sess", 
             min_sess_num = 9, 
             return_id_lgl = TRUE)
```

An alternative option is to select all cases where it is possible to apply all three sudden gains criteria. 
This function goes through the data and selects all cases with at least one of the following data patterns.

| Data pattern | x<sub>1</sub> | x<sub>2</sub> | x<sub>3</sub> | x<sub>4</sub> | x<sub>5</sub> | x<sub>6</sub> |
|:------------:|-------|-------|-------|-------|-------|-------|
| 1.           |   x   | **X** |   x   |   x   |       |       |
| 2.           |   x   | **X** |   x   |       |   x   |       |
| 3.           |   x   |       | **X** |   x   |   x   |       |
| 4.           |   x   |       | **X** |   x   |       |   x   |

*Note:* x<sub>1</sub> to x<sub>6</sub> are consecutive data points of the primary outcome measure. x = Available data; Empty cell = Missing data. Bold **X** represent the pregain session for each pattern.

```r
# 2. Select all patients providing enough data to identify sudden gains ----
select_cases(data = sgdata, 
             id_var_name = "id", 
             sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", 
                             "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8", 
                             "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
             method = "pattern", 
             return_id_lgl = FALSE)
```

Now, you can use the `create_bysg()` and `create_byperson()` functions to create data sets for further analyses.

```r
# Create bysg dataset ----
# This data set has one row per gain and creates a new ID variable for each sudden gain
bysg <- create_bysg(data = sgdata,
                    sg_crit1_cutoff = 7,
                    id_var_name = "id",
                    tx_start_var_name = "bdi_s1",
                    tx_end_var_name = "bdi_s12",
                    sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", 
                                    "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8", 
                                    "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
                    sg_measure_name = "bdi",
                    identify = "sg")

# Create byperson dataset ----
# This function can select the "first", "last", "smallest", or "largest" sudden gain in cases of 
# multiple sudden gains using the "multiple_sg_select" argument.
byperson_first <- create_byperson(data = sgdata,
                                  sg_crit1_cutoff = 7,
                                  id_var_name = "id",
                                  tx_start_var_name = "bdi_s1",
                                  tx_end_var_name = "bdi_s12",
                                  sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", 
                                                  "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8", 
                                                  "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
                                  sg_measure_name = "bdi",
                                  identify_sg_1to2 = FALSE,
                                  multiple_sg_select = "first")
```

If you are interested in extracting values of other measures around the time of the sudden gain you can use the `extract_values()` function. 
You need to be familiar with the [pipe](https://magrittr.tidyverse.org/) `%>%` operator to understand the examples.

```r
# Load dplyr package for adding variables from a secondary measure to the by_sg data set
library(dplyr)

# For bysg dataset select rq variables from sgdata first
sgdata_rq <- sgdata %>% 
    select(id, rq_s0:rq_s12)

# Now join them
bysg_rq <- bysg %>%
    left_join(sgdata_rq, by = "id")

# Extract scores for bysg dataset
bysg_rq <- extract_values(data = bysg_rq,
                          id_var_name = "id_sg",
                          extract_var_list = c("rq_s1", "rq_s2", "rq_s3", "rq_s4", 
                                               "rq_s5", "rq_s6", "rq_s7", "rq_s8", 
                                               "rq_s9", "rq_s10", "rq_s11", "rq_s12"),
                          extract_var_name = "rq",
                          add_to_data = TRUE)
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

![](https://dl.dropboxusercontent.com/s/jz3ntir87zqkv8r/suddengains-plot-bdi.png)

Here is code to create a figure of the average change of PDS scores around the sudden gain on the BDI.

```r
plot_sg(data = bysg_rq,
        tx_start_var_name = "rq_s1",
        tx_end_var_name = "rq_s12",
        sg_pre_post_var_list = c("sg_rq_2n", "sg_rq_1n", "sg_rq_n", 
                                 "sg_rq_n1", "sg_rq_n2", "sg_rq_n3"),
        ylabel = "RQ")
```

![](https://dl.dropboxusercontent.com/s/smwspv6hvzu7eq8/suddengains-plot-rq.png)
