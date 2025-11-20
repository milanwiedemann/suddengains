# Create a data set with one gain per person

This function returns a wide data set with one row for each case in
`data`. The data set includes variables indicating whether each case
experienced a sudden gain/loss or not, values around the period of each
gain/loss, and descriptives. For cases with no sudden gain/loss the
descriptive variables are coded as missing (`NA`).

## Usage

``` r
create_byperson(
  data,
  sg_crit1_cutoff,
  id_var_name,
  sg_var_list,
  tx_start_var_name,
  tx_end_var_name,
  sg_measure_name,
  multiple_sg_select = c("first", "last", "smallest", "largest"),
  data_is_bysg = FALSE,
  identify = c("sg", "sl"),
  sg_crit2_pct = 0.25,
  sg_crit3 = TRUE,
  sg_crit3_alpha = 0.05,
  sg_crit3_adjust = TRUE,
  sg_crit3_critical_value = 2.776,
  identify_sg_1to2 = FALSE
)
```

## Arguments

- data:

  A data set in wide format including an ID variable and variables for
  each measurement point.

- sg_crit1_cutoff:

  Numeric, specifying the cut-off value to be used for the first sudden
  gains criterion. The function
  [`define_crit1_cutoff`](https://milanwiedemann.github.io/suddengains/reference/define_crit1_cutoff.md)
  can be used to calculate a cutoff value based on the Reliable Change
  Index (RCI; Jacobson & Truax, 1991). If set to `NULL` the first
  criterion wont be applied.

- id_var_name:

  String, specifying the name of the ID variable.

- sg_var_list:

  Vector, specifying the variable names of each measurement point
  sequentially.

- tx_start_var_name:

  String, specifying the variable name of the first measurement point of
  the intervention.

- tx_end_var_name:

  String, specifying the variable name of the last measurement point of
  the intervention.

- sg_measure_name:

  String, specifying the name of the measure used to identify sudden
  gains/losses.

- multiple_sg_select:

  String, specifying which sudden gain/loss to select for this data set
  if more than one gain/loss was identified per case. Options are:
  `"first"`, `"last"`, `"smallest"`, or `"largest"`. The default is to
  select the first sudden gain (`"first"`) if someone experienced
  multiple gains.

- data_is_bysg:

  Logical, specifying whether the data set in the `data` argument is a
  bysg datasets created using the
  [`create_bysg`](https://milanwiedemann.github.io/suddengains/reference/create_bysg.md)
  function.

- identify:

  String, specifying whether to identify sudden gains (`"sg"`) using
  [`identify_sg`](https://milanwiedemann.github.io/suddengains/reference/identify_sg.md)
  or sudden losses (`"sl"`) using
  [`identify_sl`](https://milanwiedemann.github.io/suddengains/reference/identify_sl.md).
  The default is to identify sudden gains (`"sg"`).

- sg_crit2_pct:

  Numeric, specifying the percentage change to be used for the second
  sudden gains/losses criterion. If set to `NULL` the second criterion
  wont be applied.

- sg_crit3:

  If set to `TRUE` the third criterion will be applied automatically
  adjusting the critical value for missingness. If set to `FALSE` the
  third criterion wont be applied.

- sg_crit3_alpha:

  Numeric, alpha for the student t-test (two-tailed) to determine the
  critical value to be used for the third criterion. Degrees of freedom
  are based on the number of available data in the three sessions
  preceding the gain and the three sessions following the gain.

- sg_crit3_adjust:

  Logical, specify whether critical value gets adjusted for missingness,
  see Lutz et al. (2013) and the documentation of this R package for
  further details. This argument is set to `TRUE` by default adjusting
  the critical value for missingness as described in the package
  documentation and Lutz et al. (2013): A critical value of 2.776 is
  used when all three data points before and after a potential gain are
  available, where one datapoint is missing either before or after a
  potential gain a critical value of 3.182 is used, and where one
  datapoint is missing both before and after the gain a critical value
  of 4.303 is used (for sg_crit3_alpha = 0.05). If set to `FALSE` the
  critical value specified in `sg_crit3_critical_value` will instead be
  used for all comparisons, regardless of missingnes in the sequence of
  data points that are investigated for potential sudden gains.

- sg_crit3_critical_value:

  Numeric, specifying the critical value to instead be used for all
  comparisons, regardless of missingnes in the sequence of data points
  that are investigated for potential sudden gains.

- identify_sg_1to2:

  Logical, indicating whether to identify sudden losses from measurement
  point 1 to 2. If set to TRUE, this implies that the first variable
  specified in `sg_var_list` represents a baseline measurement point,
  e.g. pre-intervention assessment.

## Value

A wide data set with one row per case (`id_var_name`) in `data`.

## References

Tang, T. Z., & DeRubeis, R. J. (1999). Sudden gains and critical
sessions in cognitive-behavioral therapy for depression. Journal of
Consulting and Clinical Psychology, 67(6), 894–904.
[doi:10.1037/0022-006X.67.6.894](https://doi.org/10.1037/0022-006X.67.6.894)
.

## Examples

``` r
# Create byperson data set, selecting the largest gain in case of muliple gains
create_byperson(data = sgdata,
                sg_crit1_cutoff = 7,
                id_var_name = "id",
                tx_start_var_name = "bdi_s1",
                tx_end_var_name = "bdi_s12",
                sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
                                "bdi_s4", "bdi_s5", "bdi_s6",
                                "bdi_s7", "bdi_s8", "bdi_s9",
                                "bdi_s10", "bdi_s11", "bdi_s12"),
                sg_measure_name = "bdi",
                multiple_sg_select = "largest")
#> First, second, and third sudden gains criteria were applied.
#> The critical value for the third criterion was adjusted for missingness.
#> The largest gain/loss was selected in case of multiple gains/losses.
#> # A tibble: 43 × 46
#>       id id_sg   sg_crit123 sg_session_n sg_freq_byperson sg_bdi_2n sg_bdi_1n
#>    <dbl> <chr>        <int>        <dbl>            <int>     <dbl>     <dbl>
#>  1     1 1_sg_7           1            7                2        24        21
#>  2     2 NA               0           NA                0        NA        NA
#>  3     3 3_sg_8           1            8                1        37        NA
#>  4     4 4_sg_3           1            3                1        31        30
#>  5     5 5_sg_8           1            8                2        23        21
#>  6     6 NA               0           NA                0        NA        NA
#>  7     7 NA               0           NA                0        NA        NA
#>  8     8 NA               0           NA                0        NA        NA
#>  9     9 9_sg_3           1            3                1        35        34
#> 10    10 10_sg_2          1            2                2        NA        35
#> # ℹ 33 more rows
#> # ℹ 39 more variables: sg_bdi_n <dbl>, sg_bdi_n1 <dbl>, sg_bdi_n2 <dbl>,
#> #   sg_bdi_n3 <dbl>, sg_magnitude <dbl>, sg_bdi_tx_change <dbl>,
#> #   sg_change_proportion <dbl>, sg_reversal_value <dbl>, sg_reversal <dbl>,
#> #   bdi_s0 <dbl>, bdi_s1 <dbl>, bdi_s2 <dbl>, bdi_s3 <dbl>, bdi_s4 <dbl>,
#> #   bdi_s5 <dbl>, bdi_s6 <dbl>, bdi_s7 <dbl>, bdi_s8 <dbl>, bdi_s9 <dbl>,
#> #   bdi_s10 <dbl>, bdi_s11 <dbl>, bdi_s12 <dbl>, bdi_fu1 <dbl>, …
```
