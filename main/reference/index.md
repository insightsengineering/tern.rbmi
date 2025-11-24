# Package index

## Statistics Functions

Statistics functions should do the computation of the numbers that are
tabulated later. In order to separate computation from formatting, they
should not take care of `rcell` type formatting themselves.

- [`s_rbmi_lsmeans()`](https://insightsengineering.github.io/tern.rbmi/reference/s_rbmi_lsmeans.md)
  **\[experimental\]** : Statistics function which is extracting
  estimates from a tidied LS means data frame.

## Formatted Analysis functions

These have the same arguments as the corresponding statistics functions,
and can be further customized by calling
[`rtables::make_afun()`](https://insightsengineering.github.io/rtables/latest-release/reference/make_afun.html)
on them. They are used as `afun` in
[`rtables::analyze()`](https://insightsengineering.github.io/rtables/latest-release/reference/analyze.html).

- [`a_rbmi_lsmeans()`](https://insightsengineering.github.io/tern.rbmi/reference/a_rbmi_lsmeans.md)
  **\[experimental\]** :

  Formatted Analysis function which can be further customized by calling
  [`rtables::make_afun()`](https://insightsengineering.github.io/rtables/latest-release/reference/make_afun.html)
  on it. It is used as `afun` in
  [`rtables::analyze()`](https://insightsengineering.github.io/rtables/latest-release/reference/analyze.html).

## Analyze Functions

Analyze Functions are used in combination with the rtables layout
functions, in the pipeline which creates the table.

- [`summarize_rbmi()`](https://insightsengineering.github.io/tern.rbmi/reference/summarize_rbmi.md)
  **\[experimental\]** :

  Analyze function for tabulating LS means estimates from tidied `rbmi`
  `pool` results.

## Analysis Helper Functions

these functions are useful to help definining the analysis

- [`h_tidy_pool()`](https://insightsengineering.github.io/tern.rbmi/reference/h_tidy_pool.md)
  **\[experimental\]** : Helper function to produce data frame with
  results of pool for a single visit

## Helper method

Helper method

- [`tidy(`*`<pool>`*`)`](https://insightsengineering.github.io/tern.rbmi/reference/tidy.pool.md)
  **\[experimental\]** :

  Helper method (for
  [`broom::tidy()`](https://broom.tidymodels.org/reference/reexports.html))
  to prepare a data frame from an `pool` `rbmi` object containing the LS
  means and contrasts and multiple visits

## Test data

Test data

- [`rbmi_test_data`](https://insightsengineering.github.io/tern.rbmi/reference/rbmi_test_data.md)
  **\[experimental\]** :

  Example dataset for `tern.rbmi` package. This is an pool object from
  the rbmi analysis, see `browseVignettes(package = "tern.rbmi")`
