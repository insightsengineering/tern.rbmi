# Formatted Analysis function which can be further customized by calling [`rtables::make_afun()`](https://insightsengineering.github.io/rtables/latest-tag/reference/make_afun.html) on it. It is used as `afun` in [`rtables::analyze()`](https://insightsengineering.github.io/rtables/latest-tag/reference/analyze.html).

**\[experimental\]**

## Usage

``` r
a_rbmi_lsmeans(df, .in_ref_col, show_relative = c("reduction", "increase"))
```

## Arguments

- df:

  input dataframe

- .in_ref_col:

  boolean variable, if reference column is specified

- show_relative:

  "reduction" if (`control - treatment`, default) or "increase"
  (`treatment - control`) of relative change from baseline?

## Value

Formatted Analysis function
