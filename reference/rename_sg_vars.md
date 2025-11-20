# Rename variable names to a generic and consistent format

Rename variable names to a generic and consistent format that can be
used by other functions of the suddengains package.

## Usage

``` r
rename_sg_vars(
  data,
  rename_var_list,
  new_var_str = "temp_var_",
  start_numbering = 1
)
```

## Arguments

- data:

  Dataframe in wide format.

- rename_var_list:

  Vector of variables to be renamed.

- new_var_str:

  String, new name for variables.

- start_numbering:

  Numeric, first number to be used as suffix for renaming variables
  specified in "rename_var_list".

## Value

Dataframe in wide format with renamed variables.
