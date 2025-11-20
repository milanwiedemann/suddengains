# Write a sudden gains data frame (byperson) to CSV, SPSS, STATA or Excel files

Writes a data frame as a specified file type.

## Usage

``` r
write_byperson(
  data,
  sg_crit1_cutoff,
  id_var_name,
  sg_var_list,
  tx_start_var_name,
  tx_end_var_name,
  sg_measure_name,
  sg_crit2_pct = 0.25,
  sg_crit3 = TRUE,
  sg_crit3_alpha = 0.05,
  sg_crit3_adjust = TRUE,
  sg_crit3_critical_value = 2.776,
  identify = c("sg", "sl"),
  identify_sg_1to2 = FALSE,
  multiple_sg_select = c("first", "last", "smallest", "largest"),
  data_is_bysg = FALSE,
  format = c("CSV", "SPSS", "STATA", "Excel"),
  path,
  stata_version = 14,
  ...
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

  String, specifying the name of the ID variable. Each row should have a
  unique value.

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
  4.303 is used (for sg_crit3_alpha = 0.05). If set to `FALSE` the
  critical value set in `sg_crit3_critical_value` will instead be used
  for all comparisons, regardless of missingnes in the sequence of data
  points that are investigated for potential sudden gains.

- sg_crit3_critical_value:

  Numeric, specifying the critical value to instead be used for all
  comparisons, regardless of missingnes in the sequence of data points
  that are investigated for potential sudden gains.#'

- identify:

  String, specifying whether to identify sudden gains (`"sg"`) using
  [`identify_sg`](https://milanwiedemann.github.io/suddengains/reference/identify_sg.md)
  or sudden losses (`"sl"`) using
  [`identify_sl`](https://milanwiedemann.github.io/suddengains/reference/identify_sl.md).
  The default is to identify sudden gains (`"sg"`).

- identify_sg_1to2:

  Logical, indicating whether to identify sudden losses from measurement
  point 1 to 2.

- multiple_sg_select:

  String, specifying which sudden gain/loss to select for this data set
  if more than one gain/loss was identified per case. Options are:
  `"first"`, `"last"`, `"smallest"`, or `"largest"`,
  [`create_byperson`](https://milanwiedemann.github.io/suddengains/reference/create_byperson.md).

- data_is_bysg:

  Logical, specifying whether the data set in the `data` argument is a
  bysg data set created using the
  [`create_bysg`](https://milanwiedemann.github.io/suddengains/reference/create_bysg.md)
  function.

- format:

  String, specifying the format of the data file, `"CSV"`, `"SPSS"`,
  `"STATA"` or `"Excel"`.

- path:

  String, specifying the file name ending with the matching file
  extension, `".csv"`, `".sav"`, `".dta"` or `".xlsx"`.

- stata_version:

  Numeric, specifying STATA version number.

- ...:

  Additional parameters to be passed on to the specified write function,
  see
  [`write_csv`](https://readr.tidyverse.org/reference/write_delim.html)
  for `"CSV"`,
  [`write_sav`](https://haven.tidyverse.org/reference/read_spss.html)
  for `"SPSS"`,
  [`write_dta`](https://haven.tidyverse.org/reference/read_dta.html) for
  `"STATA"` or
  [`write_xlsx`](https://docs.ropensci.org/writexl//reference/write_xlsx.html)
  for `"Excel"` for more information.

## Value

A csv file containing a wide data set with one row per case
(`id_var_name`) in `data`.

## References

Tang, T. Z., & DeRubeis, R. J. (1999). Sudden gains and critical
sessions in cognitive-behavioral therapy for depression. Journal of
Consulting and Clinical Psychology, 67(6), 894–904.
[doi:10.1037/0022-006X.67.6.894](https://doi.org/10.1037/0022-006X.67.6.894)
.

## Examples

``` r
# Adjust "path" argument before running
# Create character string name for temporary "byperson.csv" file
temp <- tempfile(pattern = "byperson", fileext = ".csv")

# Write byperson dataset (CSV file)
# To write a different format change the 'format' argument ...
# ... as well as the file extension in the 'path' argument
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
               format = "CSV",
               path = temp)
#> First, second, and third sudden gains criteria were applied.
#> The critical value for the third criterion was adjusted for missingness.
#> The first gain/loss was selected in case of multiple gains/losses.
```
