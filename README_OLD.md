# suddengains: An R package for identifying sudden gains in longitudinal data

[![Build Status](https://travis-ci.com/milanwiedemann/suddengains.svg?branch=master)](https://travis-ci.com/milanwiedemann/suddengains)
[![Build status](https://ci.appveyor.com/api/projects/status/v4lkpg630byy06wn?svg=true)](https://ci.appveyor.com/project/milanwiedemann/suddengains-ws7vl)
[![licence](https://img.shields.io/badge/Licence-GPL--3-brightgreen.svg)](https://choosealicense.com/licenses/gpl-3.0/)
[![CRANstatus](https://www.r-pkg.org/badges/version/suddengains)](https://cran.r-project.org/package=suddengains)
[![](https://cranlogs.r-pkg.org/badges/grand-total/suddengains)](https://cran.r-project.org/package=suddengains)

To learn more about the background of this package see our preprint on [PsyArXiv](https://psyarxiv.com/2wa84/).
We have also created an open [Zotero group](https://www.zotero.org/groups/2280342/suddengains) collecting all the literature looking at sudden gains in psychological therapies. 
Please let me know if I missed anything or join the group and add papers yourself.

Identify sudden gains based on the criteria outlined by Tang and DeRubeis ([1999](https://doi.org/10.1037/0022-006X.67.6.894)). 
It applies all three criteria to a dataset while adjusting for missing values. 
It calculates further variables that are of interest. 
It handles multiple gains by creating two datasets, one structured by sudden gain and one by participant. 
It also implements a function to specify which sudden gains to choose in case of multiple gains (e.g. the earliest or largest gain).

## Installation

The current stable version of the `suddengains` package is available on [CRAN](https://CRAN.R-project.org/package=suddengains):

```r
install.packages("suddengains")
```

To download the current developement version you need to install the devtools package to download the `suddengains` package from this GitHub repository.

```r
install.packages("devtools")
```

To install the current developement version of the `suddengains` package use the code below.

```r
devtools::install_github(repo = "milanwiedemann/suddengains", ref = "master")
```

## Overview of the functions

The `suddengains` package comes with a range of features which can be categorised into:

1. Functions to identify sudden gains:
  - `select_cases()`: Select sample providing enough data to identify sudden gains
  - `define_crit1_cutoff()`: Uses RCI formula to determine a cut-off value for criterion 1
  - `identify_sg()`: Identifies sudden gains
  - `identify_sl()`: Identifies sudden losses
  - `check_interval()`: Checks if a given interval is a sudden gain/loss
  
2. Functions to create datasets for further analysis:
  - `extract_values()`: Extracts values on a secondary measure around the sudden gain/loss
  - `create_byperson()`: Creates a dataset with one row for each sudden gain/loss
  - `create_bysg()`: Creates a dataset with one row for each person

3. Helper functions to visualise and report sudden gains:
  - `count_intervals()`: Count number of between-session intervals available to identify sudden gains
  - `plot_sg()`: Creates plots of the average sudden gain
  - `plot_sg_trajectories()`: Creates plots of plots of individual case trajectories
  - `describe_sg()`: Shows descriptives for the sudden gains datasets
  
4. Helper functions to export data sets to SPSS, Excel, Stata, and CSV:
  - `write_bysg()`: Exports CSV, SPSS, Excel, or STATA files of the sudden gains data sets
  - `write_byperson()`: Exports CSV, SPSS, Excel, or STATA files of the sudden gains data sets
  
A detailed illustration of all functions can be found in the vignette on [CRAN](https://CRAN.R-project.org/package=suddengains).
Note that the vignette is only available in R when you install the package from CRAN.
To make the vignette available when installing from GitHub the following additional `build_opts` arguments have to be added: `devtools::install_github(repo = "milanwiedemann/suddengains", ref = "master", build_opts = c("--no-resave-data", "--no-manual"))`.

```r
# Open vignette in RStudio ----
vignette("suddengains-tutorial")
```
  
## How to use `suddengains`

Here are a few examples how to use the `suddengains` package.
First, load all required packages and datasets.
This package also contains two sample data sets with made up data to test and illustrate the functions.

### 1. Functions to identify sudden gains:
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

#### 1.1 Define cut-off

The cut-off value for the first sudden gains criterion can be calculated using the reliable change index (RCI; Jacobson & Truax, [1991](https://doi.org/10.1037/0022-006X.59.1.12)) based on suggestions from Stiles et al. ([2003](https://doi.org/10.1037/0022-006X.71.1.14)).
The function has the option to calculate Chronbach's a based in item-by-item data if provided, or alternatively the reliability of the measure can be specified.

```r
# Define cut-off for first sudden gains criterion using the reliable change index
define_crit1_cutoff(sd = 10.5,
                    reliability = 0.93)
```

#### 1.2 Select cases

The package currently implements two methods to select cases for sudden gains analyses.
Which method is most appropriate for your study will depend on the therapy to be analysed, the underlying theory, the data your're using, the questions you're interested.
It might also be that it's not neccessary for you to make use of this function.
Below are some more details about the two methods that are currently available:

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

Another option is to select all cases where it is possible to apply all three sudden gains criteria. 
This function goes through the data and selects all cases with at least one of the following data patterns.

| Data pattern | x<sub>i</sub> | x<sub>i+1</sub> | x<sub>i+2</sub> | x<sub>i+3</sub> | x<sub>i+4</sub> | x<sub>i+5</sub> |
|:------------:|-------|-------|-------|-------|-------|-------|
| 1.           |   x   | x<sub>N</sub> |   x   |   x   |    .   |    .   |
| 2.           |   x   | x<sub>N</sub> |   x   |   .    |   x   |    .   |
| 3.           |   x   |   .    | x<sub>N</sub> |   x   |   x   |    .   |
| 4.           |   x   |   .    | x<sub>N</sub> |   x   |   .    |   x   |

*Note:* x<sub>i</sub> to x<sub>i+5</sub> represent the scores on the measure used to identify sudden gains at time point i and the subsequent five measurement points. 'x' = Available data; x<sub>N</sub> represents available data to be considered as the possible pregain session;'.' = Missing data.

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

#### 1.3. Identify sudden gains

To identify sudden gains/losses you can use the `identify_sg` and `identify_sl` functions.
The functions return a data frame with new variables indicating for each between-session interval whether a sudden gain/loss was identified.
For example the variable `sg_2to3` holds information whether a sudden gains occurred from session two to three, with two being the pregain and three being the postgain session.

```r
identify_sg(data = sgdata,
            sg_crit1_cutoff = 7,
            id_var_name = "id",
            sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4", 
                            "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8", 
                            "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"))
```

### 2. Functions to create datasets for further analysis:

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

### 3. Extract values around sudden gains

If you are interested in extracting values of other measures around the time of the sudden gain you can use the `extract_values()` function. 
You need to be familiar with the [pipe](https://magrittr.tidyverse.org/) `%>%` operator to understand the examples.

```r
# Load dplyr package for adding variables from a secondary measure to the by_sg data set
library(dplyr)

# For bysg dataset select "rq" variables from sgdata first
sgdata_rq <- sgdata %>% 
    select(id, rq_s0:rq_s12)

# Now add the "rq" variables to the bysg data set
bysg_rq <- bysg %>%
    left_join(sgdata_rq, by = "id")

# Extract rq scores around sudden gain on bdi
bysg_rq <- extract_values(data = bysg_rq,
                          id_var_name = "id_sg",
                          extract_var_list = c("rq_s1", "rq_s2", "rq_s3", "rq_s4", 
                                               "rq_s5", "rq_s6", "rq_s7", "rq_s8", 
                                               "rq_s9", "rq_s10", "rq_s11", "rq_s12"),
                          extract_var_name = "rq",
                          add_to_data = TRUE)
```

### 4. Helper functions to visualise and report sudden gains:

#### 4.1 Count between-session intervals

The `count_intervals` function provides a summary of between-session intervals that were and weren't analysed for sudden gains.
For more info see the help file of this function, `help(count_intervals)`.

```r
count_intervals(data = sgdata_select,
                id_var_name = "id",
                sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
                                "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
                                "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"))
```

#### 4.2 Plot average sudden gain magnitude

The package also offers a function to visualise the average magnitude of sudden gains in relation to the overall change of cases with sudden gains.
Here is code to create a figure of the average gain magnitude.

```r
plot_sg(data = bysg,
        id_var_name = "id",
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
        id_var_name = "id",
        tx_start_var_name = "rq_s1",
        tx_end_var_name = "rq_s12",
        sg_pre_post_var_list = c("sg_rq_2n", "sg_rq_1n", "sg_rq_n", 
                                 "sg_rq_n1", "sg_rq_n2", "sg_rq_n3"),
        ylabel = "RQ")
```

![](https://dl.dropboxusercontent.com/s/smwspv6hvzu7eq8/suddengains-plot-rq.png)

#### 4.3 Show descriptive statistics of sudden gains

The `describe_sg()` function provides descriptive statistics about the sudden gains based on the variables from the `bysg` or `byperson` datasets.

```r
# Describe bysg dataset ----
describe_sg(data = bysg, 
            sg_data_structure = "bysg")

# Describe byperson dataset ----
describe_sg(data = byperson_first, 
            sg_data_structure = "byperson")
```

### 5. Helper functions to export data sets to SPSS, Excel, Stata or CSV:

Here is one example how to create a "bysg" data set and write a CSV file to the computer.
Note that you have to change the file path (and name) to where you want to save the file.
 
```r
write_bysg(data = sgdata,
           sg_crit1_cutoff = 7,
           id_var_name = "id",
           tx_start_var_name = "bdi_s1",
           tx_end_var_name = "bdi_s12",
           sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
                           "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
                           "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
           sg_measure_name = "bdi",
           identify = "sg",
           format = "CSV",
           path = "~/Desktop/bysg_data.csv")
```
 
Here is another example how to write a "byperson" data set to a SPSS file on your computer.
 
```r
write_byperson(data = sgdata,
               sg_crit1_cutoff = 7,
               id_var_name = "id",
               tx_start_var_name = "bdi_s1",
               tx_end_var_name = "bdi_s12",
               sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
                               "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
                               "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
               sg_measure_name = "bdi",
               identify_sg_1to2 = FALSE,
               multiple_sg_select = "largest",
               format = "SPSS",
               path = "~/Desktop/byperson_data.sav")
```
