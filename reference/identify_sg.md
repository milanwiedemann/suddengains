# Identify sudden gains.

Function to identify sudden gains in longitudinal data structured in
wide format.

## Usage

``` r
identify_sg(
  data,
  id_var_name,
  sg_var_list,
  sg_crit1_cutoff,
  sg_crit2_pct = 0.25,
  sg_crit3 = TRUE,
  sg_crit3_alpha = 0.05,
  sg_crit3_adjust = TRUE,
  sg_crit3_critical_value = 2.776,
  identify_sg_1to2 = FALSE,
  crit123_details = FALSE
)
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

- sg_crit1_cutoff:

  Numeric, specifying the cut-off value to be used for the first sudden
  gains criterion. The function
  [`define_crit1_cutoff`](https://milanwiedemann.github.io/suddengains/reference/define_crit1_cutoff.md)
  can be used to calculate a cutoff value based on the Reliable Change
  Index (RCI; Jacobson & Truax, 1991). If set to `NULL` the first
  criterion wont be applied.

- sg_crit2_pct:

  Numeric, specifying the percentage change to be used for the second
  sudden gains criterion. If set to `NULL` the second criterion wont be
  applied.

- sg_crit3:

  If set to `TRUE` the third criterion will be applied automatically
  adjusting the critical value for missingness. If set to `FALSE` the
  third criterion wont be applied.

- sg_crit3_alpha:

  Numeric, alpha for the two-tailed student t-test to determine the
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
  available, where one data point is missing either before or after a
  potential gain a critical value of 3.182 is used, and where one data
  point is missing both before and after the gain a critical value of
  4.303 is used (for sg_crit3_alpha = 0.05). If set to `FALSE` the
  critical value set in `sg_crit3_critical_value` will instead be used
  for all comparisons, regardless of missingnes in the sequence of data
  points that are investigated for potential sudden gains.

- sg_crit3_critical_value:

  Numeric, specifying the critical value to instead be used for all
  comparisons, regardless of missingnes in the sequence of data points
  that are investigated for potential sudden gains.

- identify_sg_1to2:

  Logical, indicating whether to identify sudden gains from measurement
  point 1 to 2. If set to TRUE, this implies that the first variable
  specified in `sg_var_list` represents a baseline measurement point,
  e.g. pre-intervention assessment.

- crit123_details:

  Logical, if set to `TRUE` this function returns information about
  which of the three criteria (e.g. "sg_crit1_2to3", "sg_crit2_2to3",
  and "sg_crit3_2to3") are met for each session to session interval for
  all cases. Variables named "sg_2to3", "sg_3to4" summarise all criteria
  that were selected to identify sudden gains.

## Value

A wide data set indicating whether sudden gains are present for each
session to session interval for all cases in `data`.

## References

Lutz, W., Ehrlich, T., Rubel, J., Hallwachs, N., Röttger, M.-A., Jorasz,
C., … Tschitsaz-Stucki, A. (2013). The ups and downs of psychotherapy:
Sudden gains and sudden losses identified with session reports.
Psychotherapy Research, 23(1), 14–24.
[doi:10.1080/10503307.2012.693837](https://doi.org/10.1080/10503307.2012.693837)
.

Tang, T. Z., & DeRubeis, R. J. (1999). Sudden gains and critical
sessions in cognitive-behavioral therapy for depression. Journal of
Consulting and Clinical Psychology, 67(6), 894–904.
[doi:10.1037/0022-006X.67.6.894](https://doi.org/10.1037/0022-006X.67.6.894)
.

## Examples

``` r
# Identify sudden gains
identify_sg(data = sgdata,
            sg_crit1_cutoff = 7,
            id_var_name = "id",
            sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
                            "bdi_s4", "bdi_s5", "bdi_s6",
                            "bdi_s7", "bdi_s8", "bdi_s9",
                            "bdi_s10", "bdi_s11", "bdi_s12"))
#> First, second, and third sudden gains criteria were applied.
#> The critical value for the third criterion was adjusted for missingness.
#> # A tibble: 43 × 22
#>       id bdi_s1 bdi_s2 bdi_s3 bdi_s4 bdi_s5 bdi_s6 bdi_s7 bdi_s8 bdi_s9 bdi_s10
#>    <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl>
#>  1     1     35     37     34     23     24     21     29     17     11      11
#>  2     2     26     NA     26     NA     27     17     19     11     10       3
#>  3     3     35     38     35     37     36     37     NA     35     26      24
#>  4     4     31     30     32     22     22     20     21     19     24      33
#>  5     5     39     37     36     26     26     23     21     19      6       7
#>  6     6     37     NA     23     NA     23     21     NA     NA     19      NA
#>  7     7     37     NA     23     21     NA     21     NA     NA     NA      NA
#>  8     8     41     37     NA     NA     NA     NA     NA     NA     NA      NA
#>  9     9     35     34     32     23     24     22     21     17     14      10
#> 10    10     35     35     25     25     17     17     16     16     11       9
#> # ℹ 33 more rows
#> # ℹ 11 more variables: bdi_s11 <dbl>, bdi_s12 <dbl>, sg_2to3 <int>,
#> #   sg_3to4 <int>, sg_4to5 <int>, sg_5to6 <int>, sg_6to7 <int>, sg_7to8 <int>,
#> #   sg_8to9 <int>, sg_9to10 <int>, sg_10to11 <int>
```
