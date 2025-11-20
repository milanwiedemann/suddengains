# Show descriptives for the sudden gains datasets

Descriptives might differ between the bysg and byperson data sets
depending on whether multiple gains are present.

## Usage

``` r
describe_sg(data, sg_data_structure = c("bysg", "byperson"))
```

## Arguments

- data:

  A `bysg` or `byperson` dataset created using the function
  [`create_bysg`](https://milanwiedemann.github.io/suddengains/reference/create_bysg.md)
  or
  [`create_byperson`](https://milanwiedemann.github.io/suddengains/reference/create_byperson.md).

- sg_data_structure:

  String, indicating whether the input data is a `bysg` or `byperson`
  dataset.

## Value

A list, showing basic descriptive statistics for sudden gains within the
dataset specified. Note that some numbers (e.g. percentages) will be
different depending which dataset is selected, because where a
participant has multiple gains, only one is selected for the `byperson`
dataset. The list includes values for:

- total_n: number of rows in input dataset

- sg_total_n: total number of sudden gains

- sg_n: number of people who experienced a sudden gain (byperson dataset
  only)

- sg_pct: percentage of people in the input dataset who experienced a
  sudden gain

- sg_multiple_n: number of people who experienced a sudden gain
  (byperson dataset only)

- sg_multiple_pct: percentage of people in the input dataset who
  experienced more than one sudden gain

- sg_reversal_n: number of sudden gains that later meet the criteria for
  a reversal

- sg_reversal_pct: percentage of sudden gains that later meet the
  criteria for a reversal

- sg_magnitude_m: mean magnitude of the sudden gains observed

- sg_magnitude_sd: standard deviation of the magnitude of the sudden
  gains observed

## Examples

``` r
# Create bysg dataset
bysg <- create_bysg(data = sgdata,
                    sg_crit1_cutoff = 7,
                    id_var_name = "id",
                    tx_start_var_name = "bdi_s1",
                    tx_end_var_name = "bdi_s12",
                    sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
                                    "bdi_s4", "bdi_s5", "bdi_s6",
                                    "bdi_s7", "bdi_s8", "bdi_s9",
                                    "bdi_s10", "bdi_s11", "bdi_s12"),
                    sg_measure_name = "bdi")
#> First, second, and third sudden gains criteria were applied.
#> The critical value for the third criterion was adjusted for missingness.

# Describe bysg dataset
describe_sg(data = bysg,
            sg_data_structure = "bysg")
#> $total_n
#> [1] 24
#> 
#> $sg_total_n
#> [1] 24
#> 
#> $sg_pct
#> [1] 100
#> 
#> $sg_multiple_pct
#> [1] 70.83
#> 
#> $sg_reversal_n
#> [1] 4
#> 
#> $sg_reversal_pct
#> [1] 16.67
#> 
#> $sg_magnitude_m
#> [1] 11
#> 
#> $sg_magnitude_sd
#> [1] 3.43
#> 
```
