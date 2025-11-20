# Extract values around the sudden gain

Extract values of measures around the time of a sudden gain.

## Usage

``` r
extract_values(
  data,
  id_var_name,
  extract_var_list,
  sg_session_n_var_name = "sg_session_n",
  extract_measure_name = "x",
  start_numbering = 1,
  add_to_data = TRUE
)
```

## Arguments

- data:

  A `bysg` or `byperson` data set in wide format with the variable
  `sg_session_n` and all variables specified in `extract_var_list`.

- id_var_name:

  String, specifying the name of the ID variable.

- extract_var_list:

  List or vector, specifying the variable names of session to session
  scores to extract from. If this is a list, the name of each element
  will be used when creating new variables. Note that each element of
  this list must have the same number of repeated measures as specified
  in `sg_var_list` when creating the sudden gains data set.

- sg_session_n_var_name:

  String, specifying variable name that contains information about the
  pregain session number. If the sudden gains data set was created using
  the suddengains R package, the default argument "sg_session_n" should
  be used.

- extract_measure_name:

  String, if `extract_var_list` is a vector, this string will be used as
  the when creating new variables of the extracted measures.

- start_numbering:

  Numeric, set to by default 1. Change to 0 if a pre-treatment (e.g.
  baseline assessment) measurement point is included in
  `extract_var_list`.

- add_to_data:

  Logical, if set to `TRUE`, the extracted values are added as new
  variables to the input dataset. If set to false, only the ID variable
  and all extracted values will be returned.

## Value

A wide dataset with values for `extract_measure_name` around the sudden
gain.

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

# For bysg dataset select "id" and "rq" variables first
sgdata_rq <- sgdata %>%
  dplyr::select(id, rq_s0:rq_s12)

# Join them with the sudden gains data set, here "bysg"
bysg_rq <- bysg %>%
  dplyr::left_join(sgdata_rq, by = "id")

# Extract "rq" scores around sudden gains on "bdi" in the bysg dataset
bysg_rq <- extract_values(data = bysg_rq,
                          id_var_name = "id_sg",
                          extract_var_list = c("rq_s1", "rq_s2", "rq_s3", "rq_s4",
                                               "rq_s5", "rq_s6", "rq_s7", "rq_s8",
                                               "rq_s9", "rq_s10", "rq_s11", "rq_s12"),
                          extract_measure_name = "rq",
                          add_to_data = TRUE)
#> Note: The measure specified in 'extract_var_list' must have the same number of repeated time points as the measure used to identify sudden gains.
```
