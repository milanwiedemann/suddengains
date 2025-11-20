# Check if a given interval is a sudden gain/loss

Checks if a specific session to session interval is a sudden gain/loss.

## Usage

``` r
check_interval(
  pre_values,
  post_values,
  sg_crit1_cutoff,
  sg_crit2_pct = 0.25,
  sg_crit3 = TRUE,
  sg_crit3_alpha = 0.05,
  sg_crit3_adjust = TRUE,
  sg_crit3_critical_value = 2.776,
  identify = c("sg", "sl"),
  details = TRUE
)
```

## Arguments

- pre_values:

  Vector, three pre gain/loss values to be checked for a sudden
  gain/loss (n-2, n-1, n)

- post_values:

  Vector, three post gain/loss values to be checked for a sudden
  gain/loss (n+1, n+2, n+3)

- sg_crit1_cutoff:

  Numeric, specifying the cut-off value to be used for the first sudden
  gains criterion. The function
  [`define_crit1_cutoff`](https://milanwiedemann.github.io/suddengains/reference/define_crit1_cutoff.md)
  can be used to calculate a cutoff value based on the Reliable Change
  Index (RCI; Jacobson & Truax, 1991). If set to `NULL` the first
  criterion wont be applied.

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
  available, where one data point is missing either before or after a
  potential gain a critical value of 3.182 is used, and where one data
  point is missing both before and after the gain a critical value of
  4.303 is used. If set to `FALSE` a critical value of 2.776 will
  instead be used for all comparisons, regardless of missingnes in the
  sequence of data points that are investigated for sudden gains.

- sg_crit3_critical_value:

  Numeric, specifying the critical value to instead be used for all
  comparisons, regardless of missingnes in the sequence of data points
  that are investigated for potential sudden gains.

- identify:

  String, specifying whether to identify sudden gains (`"sg"`) or sudden
  losses (`"sl"`).

- details:

  Logical, details yes no?

## Value

Information on whether a given interval is a sudden gain/loss

## Examples

``` r
# Check interval for sudden gain using all 3 criteria
# No missing data, alpha = 0.05
check_interval(pre_values = c(32, 31, 33),
               post_values = c(5, 6, 7),
               sg_crit1_cutoff = 7,
               sg_crit2_pct = .25,
               sg_crit3 = TRUE,
               sg_crit3_alpha = .05,
               identify = "sg")
#> First, second, and third sudden gains criteria were applied.
#> The critical value for the thrid criterion was adjusted for missingness.
#> # Check sudden gain
#> ## Met Criterion 1: YES
#> ## Met Criterion 2: YES
#> ## Met Criterion 3: YES
#> ## Sudden gain: YES
#> 
#> # Detailed output
#> ## Criterion 1: Cut-off: 7 
#> ## Criterion 2: Percentage change threshhold: 25 %
#> ## Criterion 3: Adjusted: YES, Critical value: 2.776
#> ## Number of pre gain values present: 3
#> ## Number of post gain values present: 3
#> ## Mean of pre gain values: 32
#> ## Mean of post gain values: 6
#> ## SD of pre gain values: 1
#> ## SD of post gain values: 1

# No missing data, alpha = 0.01
check_interval(pre_values = c(32, 31, 33),
               post_values = c(5, 6, 7),
               sg_crit1_cutoff = 7,
               sg_crit2_pct = .25,
               sg_crit3 = TRUE,
               sg_crit3_alpha = .01,
               identify = "sg")
#> First, second, and third sudden gains criteria were applied.
#> The critical value for the thrid criterion was adjusted for missingness.
#> # Check sudden gain
#> ## Met Criterion 1: YES
#> ## Met Criterion 2: YES
#> ## Met Criterion 3: YES
#> ## Sudden gain: YES
#> 
#> # Detailed output
#> ## Criterion 1: Cut-off: 7 
#> ## Criterion 2: Percentage change threshhold: 25 %
#> ## Criterion 3: Adjusted: YES, Critical value: 4.604
#> ## Number of pre gain values present: 3
#> ## Number of post gain values present: 3
#> ## Mean of pre gain values: 32
#> ## Mean of post gain values: 6
#> ## SD of pre gain values: 1
#> ## SD of post gain values: 1

# Check interval for sudden gain using only third criterion
# Some missing data, alpha = 0.01
check_interval(pre_values = c(NA,31,33),
               post_values = c(5, NA, 7),
               sg_crit1_cutoff = NULL,
               sg_crit2_pct = NULL,
               sg_crit3 = TRUE,
               sg_crit3_alpha = .01,
               identify = "sg")
#> Third sudden gains criterion was applied.
#> The critical value for the thrid criterion was adjusted for missingness.
#> # Check sudden gain
#> ## Met Criterion 1: NA
#> ## Met Criterion 2: NA
#> ## Met Criterion 3: YES
#> ## Sudden gain: YES
#> 
#> # Detailed output
#> ## Criterion 1: Cut-off: Criterion 1 was not applied
#> ## Criterion 2: Percentage change threshhold: Criterion 2 was not applied
#> ## Criterion 3: Adjusted: YES, Critical value: 9.925
#> ## Number of pre gain values present: 2
#> ## Number of post gain values present: 2
#> ## Mean of pre gain values: 32
#> ## Mean of post gain values: 6
#> ## SD of pre gain values: 1.414
#> ## SD of post gain values: 1.414

# Check interval for sudden loss using all three criteria
# Some missing data, alpha = 0.05
check_interval(pre_values = c(5, NA, 7),
               post_values = c(16, 12, 14),
               sg_crit1_cutoff = -7,
               sg_crit2_pct = .25,
               sg_crit3 = TRUE,
               sg_crit3_alpha = .05,
               identify = "sl")
#> First, second, and third sudden gains criteria were applied.
#> The critical value for the thrid criterion was adjusted for missingness.
#> # Check sudden loss
#> ## Met Criterion 1: YES
#> ## Met Criterion 2: YES
#> ## Met Criterion 3: YES
#> ## Sudden loss: YES
#> 
#> # Detailed output
#> ## Criterion 1: Cut-off: -7 
#> ## Criterion 2: Percentage change threshhold: 25 %
#> ## Criterion 3: Adjusted: YES, Critical value: 3.182
#> ## Number of pre gain values present: 2
#> ## Number of post gain values present: 3
#> ## Mean of pre gain values: 6
#> ## Mean of post gain values: 14
#> ## SD of pre gain values: 1.414
#> ## SD of post gain values: 2
```
