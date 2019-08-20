# suddengains 0.3.0

- Add function `check_interval()` to check if a given interval is a sudden gain/loss

# suddengains 0.2.1

- Fix error message when loading SPSS datasets with the R package foreign 
- Calculate critical values from the student t distribution for third criterion using `base::qt()`
- Add functionality to change significance level (alpha) for computing two-tailed critical value based on the student t distribution using the argument `sg_crit3_alpha`

# suddengains 0.2.0

- Add new plot function `plot_sg_trajectories()` to plot trajectories of individual cases
- Add more specific warning and error messages:
  - Message notification if no gains/losses are identified using: identify_sg() or identify_sl()
  - Error if no gains/losses are identified using: `create_bysg()`, `create_byperson()`
- Add colour option to `plot_sg()` function for different groups
- Fix calculation of start and end values in `plot_sg()` function for bysg data sets
- Update help files
  - Fix spelling mistakes
  - Clarify some arguments
  - Add table explaining "pattern" method to `select_cases()` function

# suddengains 0.1.0

First CRAN submission.
