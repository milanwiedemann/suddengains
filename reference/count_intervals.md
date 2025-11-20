# Count number of between-session intervals available to identify sudden gains

Calculates the number of total between-session intervals present in the
data set and the number of between-session intervals that are available
to identify sudden gains talking into account the pattern of missing
data.

## Usage

``` r
count_intervals(data, id_var_name, sg_var_list, identify_sg_1to2 = FALSE)
```

## Arguments

- data:

  A data set in wide format including an ID variable and variables for
  each measurement point.

- id_var_name:

  String, specifying the name of the ID variable. Each row should have a
  unique value.

- sg_var_list:

  Vector, specifying the variable names of each measurement point
  sequentially.

- identify_sg_1to2:

  Logical, indicating whether to identify sudden losses from measurement
  point 1 to 2. If set to TRUE, this implies that the first variable
  specified in `sg_var_list` represents a baseline measurement point,
  e.g. pre-intervention assessment.

## Value

List with values for:

- total_between_sess_intervals: The total number of between-session
  intervals present in the data set, NAs are also included here. This
  multiplies the number of cases (rows) with the number of specified
  between-session intervals: `nrows * (length(sg_var_list) - 1)`.

- total_between_sess_intervals_sg: The total number of between-session
  intervals where sudden gains can theoretically, NAs are also included
  here. This multiplies the number of cases (rows) with the number of
  between-session intervals where sudden gains can be identified using
  the 3 original criteria: `nrows * (length(sg_var_list) - 3)`.

- available_between_sess_intervals_sg: The total number of
  between-session intervals that can be analysed for sudden gains taking
  into account the pattern of missing data.

- not_available_between_sess_intervals_sg: The total number of
  between-session intervals that can not be analysed for sudden gains
  due to the pattern of missing data.

## Examples

``` r
# Count between session intervals in "sgdata"
count_intervals(data = sgdata,
                id_var_name = "id",
                sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
                                "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
                                "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"))
#> $total_between_sess_intervals
#> [1] 473
#> 
#> $total_between_sess_intervals_sg
#> [1] 387
#> 
#> $available_between_sess_intervals_sg
#> [1] 298
#> 
#> $not_available_between_sess_intervals_sg
#> [1] 89
#> 
```
