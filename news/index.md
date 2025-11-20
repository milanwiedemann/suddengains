# Changelog

## suddengains 0.4.4

CRAN release: 2020-05-22

- add function
  [`plot_sg_intervals()`](https://milanwiedemann.github.io/suddengains/reference/plot_sg_intervals.md)
  to visualise session to session intervals that are analysed for sudden
  gains
- minor changes to integrate updates in tibble package

## suddengains 0.4.3

CRAN release: 2020-03-15

- Suppress message about vector length from
  [`extract_values()`](https://milanwiedemann.github.io/suddengains/reference/extract_values.md)
  in the functions
  [`create_bysg()`](https://milanwiedemann.github.io/suddengains/reference/create_bysg.md)
  and
  [`create_byperson()`](https://milanwiedemann.github.io/suddengains/reference/create_byperson.md)
- Update ggplot2 functions with “deprecated” warning message
- Add clearer detailed output message in
  [`check_interval()`](https://milanwiedemann.github.io/suddengains/reference/check_interval.md)
  function

## suddengains 0.4.2

CRAN release: 2020-03-10

- Add option to specify the critical value for criterion three using the
  argument `sg_crit3_critical_value`
- Add option to extract values from multiple measures by specifting a
  list in the `extract_var_list` of the function
  [`extract_values()`](https://milanwiedemann.github.io/suddengains/reference/extract_values.md)
- Internal changes to
  [`plot_sg()`](https://milanwiedemann.github.io/suddengains/reference/plot_sg.md)
  function to work properly with shiny
- Make output from
  [`describe_sg()`](https://milanwiedemann.github.io/suddengains/reference/describe_sg.md)
  function clearer
- Create shiny app illustrating main functions of this version,
  available at <https://milanwiedemann.shinyapps.io/shinygains/>
- Correct typos
- Add funders to documentation

## suddengains 0.4.0

CRAN release: 2019-10-27

- Fix error in formula used to define a cutoff value for the first
  sudden gains criteria based on the Reliable Change Index (RCI;
  Jacobson & Truax, 1991) in the function
  [`define_crit1_cutoff()`](https://milanwiedemann.github.io/suddengains/reference/define_crit1_cutoff.md)
- Add formulas used to calculate standard error of measurement, standard
  error of difference, and relaible change value to help file of
  [`define_crit1_cutoff()`](https://milanwiedemann.github.io/suddengains/reference/define_crit1_cutoff.md)
- Simplify
  [`define_crit1_cutoff()`](https://milanwiedemann.github.io/suddengains/reference/define_crit1_cutoff.md)
  function arguments
- Add links to functions of other R packages to help files
- Add links to functions of suddengains package to help files
- Add option to not adjust critical value in third sudden gains
  criterion

## suddengains 0.3.1

CRAN release: 2019-09-24

- Make compaible with tidyr v1.0.0
- Fix error in
  [`extract_values()`](https://milanwiedemann.github.io/suddengains/reference/extract_values.md)
  function

## suddengains 0.3.0

CRAN release: 2019-08-20

- Add function
  [`check_interval()`](https://milanwiedemann.github.io/suddengains/reference/check_interval.md)
  to check if a given interval is a sudden gain/loss

## suddengains 0.2.1

CRAN release: 2019-05-21

- Fix error message when loading SPSS datasets with the R package
  foreign
- Calculate critical values from the student t distribution for third
  criterion using `base::qt()`
- Add functionality to change significance level (alpha) for computing
  two-tailed critical value based on the student t distribution using
  the argument `sg_crit3_alpha`

## suddengains 0.2.0

CRAN release: 2019-05-11

- Add new plot function
  [`plot_sg_trajectories()`](https://milanwiedemann.github.io/suddengains/reference/plot_sg_trajectories.md)
  to plot trajectories of individual cases
- Add more specific warning and error messages:
  - Message notification if no gains/losses are identified using:
    identify_sg() or identify_sl()
  - Error if no gains/losses are identified using:
    [`create_bysg()`](https://milanwiedemann.github.io/suddengains/reference/create_bysg.md),
    [`create_byperson()`](https://milanwiedemann.github.io/suddengains/reference/create_byperson.md)
- Add colour option to
  [`plot_sg()`](https://milanwiedemann.github.io/suddengains/reference/plot_sg.md)
  function for different groups
- Fix calculation of start and end values in
  [`plot_sg()`](https://milanwiedemann.github.io/suddengains/reference/plot_sg.md)
  function for bysg data sets
- Update help files
  - Fix spelling mistakes
  - Clarify some arguments
  - Add table explaining “pattern” method to
    [`select_cases()`](https://milanwiedemann.github.io/suddengains/reference/select_cases.md)
    function

## suddengains 0.1.0

CRAN release: 2019-05-03

First CRAN submission.
