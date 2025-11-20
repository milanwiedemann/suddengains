# Define cut-off value for first SG criterion

Define a cut-off value for the first sudden gains criterion based on the
Reliable Change Index (RCI; Jacobson & Truax, 1991) using an estimate
for the standard deviation (sd) of the normal population and the
reliability of the scale. These values can be entered manually using the
arguments `sd` and `reliability` or extracted from data using the
arguments `data_sd` and `data_reliability`. This function calculates the
standard error of measurement (se), the standard error of the difference
(sdiff) and a value that classifies as reliable change
(reliable_change_value) based on the Reliable Change Index (RCI;
Jacobson & Truax, 1991). \$\$se = sd \* \sqrt{(1 - reliability)}\$\$
\$\$sdiff = \sqrt{(2 \* se^2)}\$\$ \$\$reliable change value = 1.96 \*
sdiff\$\$

## Usage

``` r
define_crit1_cutoff(
  sd = NULL,
  reliability = NULL,
  data_sd = NULL,
  data_reliability = NULL
)
```

## Arguments

- sd:

  Numeric, standard deviation of normal population or standard deviation
  at baseline. This argument is not needed if a vector with pretreatment
  scores is specified in the `data_sd` argument.

- reliability:

  Numeric, between 0 and 1 indicating reliability of the scale. This
  argument is not needed if item-by-item data is specified in the
  `data_reliability` argument.

- data_sd:

  A vector with pretreatment values. This argument is not needed if the
  standard deviation is specified in the `sd` argument.

- data_reliability:

  A dataset in wide format (one row for each individual and one column
  for each item) including only the item-by-item scores of the SG
  measure (no ID variable). According to Jacobson & Truax (1991) the
  test-retest reliability should be used. Martinovich et al. (1996)
  suggest that the internal consistency (Cronbach's alpha) can be used
  instead of the test-retest reliability and may be more appropriate for
  estimating the standard error in some cases. This argument is not
  needed if the reliability is specified in the `reliability` argument.

## Value

A list with estimates the for standard error of measurement (se), the
standard error of the difference (sdiff) and a value that classifies as
reliable change (reliable_change_value).

## References

Jacobson, N. S., & Truax, P. A. (1991). Clinical significance: A
statistical approach to defining meaningful change in psychotherapy
research. Journal of Consulting and Clinical Psychology, 59 (1), 12-19.
[doi:10.1037/0022-006X.59.1.12](https://doi.org/10.1037/0022-006X.59.1.12)
.

Martinovich, Z., Saunders, S., & Howard, K. (1996). Some Comments on
“Assessing Clinical Significance”. Psychotherapy Research, 6(2),
124–132.
[doi:10.1080/10503309612331331648](https://doi.org/10.1080/10503309612331331648)
.

Stiles et al. (2003). Early sudden gains in psychotherapy under routine
clinic conditions: Practice-based evidence. Journal of Consulting and
Clinical Psychology, 71 (1), 14-21.
[doi:10.1037/0022-006X.71.1.14](https://doi.org/10.1037/0022-006X.71.1.14)
.

## Examples

``` r
# Define cut-off value for first SG criterion
# In this example the standard deviation and the reliability are specified manually
define_crit1_cutoff(sd = 10.5,
                    reliability = 0.931)
#> The reliability of the measure used to identify sudden gains was specified in the arguement 'reliability = 0.931'.
#> $sd
#> [1] 10.5
#> 
#> $reliability
#> [1] 0.931
#> 
#> $standard_error_measurement
#> [1] 2.758124
#> 
#> $standard_error_difference
#> [1] 3.900577
#> 
#> $reliable_change_value
#> [1] 7.645131
#> 

# In this example the reliability is specified manually
# The standard deviation of the variable "bdi_s0" in the dataset "sgdata" gets calculated
define_crit1_cutoff(data_sd = sgdata$bdi_s0,
                    reliability = 0.931)
#> The reliability of the measure used to identify sudden gains was specified in the arguement 'reliability = 0.931'.
#> $sd
#> [1] 6.396073
#> 
#> $reliability
#> [1] 0.931
#> 
#> $standard_error_measurement
#> [1] 1.680111
#> 
#> $standard_error_difference
#> [1] 2.376036
#> 
#> $reliable_change_value
#> [1] 4.65703
#> 
```
