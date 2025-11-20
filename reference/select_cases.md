# Select sample providing enough data to identify sudden gains

Select sample for further sudden gains analyses depending on specified
methods.

The following table shows the different data patterns that get selected
when `method = "pattern"`. This function goes through the data and
selects all cases with at least one of the following data patterns.

|             |        |        |        |        |        |        |
|-------------|--------|--------|--------|--------|--------|--------|
| **Pattern** | **x1** | **x2** | **x3** | **x4** | **x5** | **x6** |
| **1.**      | x      | **N**  | x      | x      | .      | .      |
| **2.**      | x      | **N**  | x      | .      | x      | .      |
| **3.**      | x      | .      | **N**  | x      | x      | .      |
| **4.**      | x      | .      | **N**  | x      | .      | x      |

*Note*. x1 to x6 are consecutive data points of the primary outcome
measure. 'x' = Available data; '.' = Missing data. '**N**' represents
available data to be examined as a possible pregain session.

## Usage

``` r
select_cases(
  data,
  id_var_name,
  sg_var_list,
  method = c("pattern", "min_sess"),
  min_sess_num = NULL,
  return_id_lgl = FALSE
)
```

## Arguments

- data:

  A dataset in wide format with an id variable and the sudden gains
  variables.

- id_var_name:

  String, specifying the name of the ID variable. Each row should have a
  unique value.

- sg_var_list:

  Vector, specifying the variable names of each measurement point
  sequentially.

- method:

  String, specifying the method used to select cases: `pattern` or
  `min_sess`.

- min_sess_num:

  Numeric, minimum number of available sessions to be selected. This
  argument needs to be specified if `method = min_sess`.

- return_id_lgl:

  Logical, if `TRUE` the function returns the ID variable and a new
  variable `sg_select` indicating whether there is enough data available
  to identify sudden gains. If set to `FALSE` this function returns the
  input data together with the new variable `sg_select`.

## Value

A wide dataset indicating with all cases and a variable indicating
whether each cases provides enough data to identify sudden gains.

## Examples

``` r
# 1. method = "pattern"
select_cases(data = sgdata,
             id_var_name = "id",
             sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
                             "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
                             "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
             method = "pattern",
             return_id_lgl = FALSE)
#> The method 'pattern' was used to select cases.
#> See help('select_cases') for more information.
#> # A tibble: 43 × 32
#>       id bdi_s0 bdi_s1 bdi_s2 bdi_s3 bdi_s4 bdi_s5 bdi_s6 bdi_s7 bdi_s8 bdi_s9
#>    <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#>  1     1     33     35     37     34     23     24     21     29     17     11
#>  2     2     26     26     NA     26     NA     27     17     19     11     10
#>  3     3     40     35     38     35     37     36     37     NA     35     26
#>  4     4     33     31     30     32     22     22     20     21     19     24
#>  5     5     39     39     37     36     26     26     23     21     19      6
#>  6     6     35     37     NA     23     NA     23     21     NA     NA     19
#>  7     7     NA     37     NA     23     21     NA     21     NA     NA     NA
#>  8     8     40     41     37     NA     NA     NA     NA     NA     NA     NA
#>  9     9     33     35     34     32     23     24     22     21     17     14
#> 10    10     34     35     35     25     25     17     17     16     16     11
#> # ℹ 33 more rows
#> # ℹ 21 more variables: bdi_s10 <dbl>, bdi_s11 <dbl>, bdi_s12 <dbl>,
#> #   bdi_fu1 <dbl>, bdi_fu2 <dbl>, rq_s0 <dbl>, rq_s1 <dbl>, rq_s2 <dbl>,
#> #   rq_s3 <dbl>, rq_s4 <dbl>, rq_s5 <dbl>, rq_s6 <dbl>, rq_s7 <dbl>,
#> #   rq_s8 <dbl>, rq_s9 <dbl>, rq_s10 <dbl>, rq_s11 <dbl>, rq_s12 <dbl>,
#> #   rq_fu1 <dbl>, rq_fu2 <dbl>, sg_select <lgl>

# 2. method = "min_sess"
select_cases(data = sgdata,
             id_var_name = "id",
             sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
                             "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
                             "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
             method = "min_sess",
             min_sess_num = 9,
             return_id_lgl = TRUE)
#> The method 'min_sess' was used to select cases.
#> # A tibble: 43 × 2
#>       id sg_select
#>    <dbl> <lgl>    
#>  1     1 TRUE     
#>  2     2 TRUE     
#>  3     3 TRUE     
#>  4     4 TRUE     
#>  5     5 TRUE     
#>  6     6 FALSE    
#>  7     7 FALSE    
#>  8     8 FALSE    
#>  9     9 TRUE     
#> 10    10 TRUE     
#> # ℹ 33 more rows
```
