# Statistics function which is extracting estimates from a tidied LS means data frame.

**\[experimental\]**

## Usage

``` r
s_rbmi_lsmeans(df, .in_ref_col, show_relative = c("reduction", "increase"))
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

A list of statistics extracted from a tidied LS means data frame.

## Examples

``` r
library(rtables)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
library(broom)

data("rbmi_test_data")
pool_obj <- rbmi_test_data
df <- tidy(pool_obj)

s_rbmi_lsmeans(df[1, ], .in_ref_col = TRUE)
#> $adj_mean_se
#> [1] -1.6158200  0.4862316
#> 
#> $adj_mean_ci
#> [1] -2.5757714 -0.6558685
#> attr(,"label")
#> [1] "95% CI"
#> 
#> $diff_mean_se
#> character(0)
#> 
#> $diff_mean_ci
#> character(0)
#> attr(,"label")
#> [1] "95% CI"
#> 
#> $change
#> character(0)
#> attr(,"label")
#> [1] "Relative Reduction (%)"
#> 
#> $p_value
#> character(0)
#> 

s_rbmi_lsmeans(df[2, ], .in_ref_col = FALSE)
#> $adj_mean_se
#> [1] -1.7076264  0.4749573
#> 
#> $adj_mean_ci
#> [1] -2.6453193 -0.7699335
#> attr(,"label")
#> [1] "95% CI"
#> 
#> $diff_mean_se
#> [1] -0.09180645  0.68262791
#> 
#> $diff_mean_ci
#> [1] -1.439497  1.255884
#> attr(,"label")
#> [1] "95% CI"
#> 
#> $change
#> [1] 0.05681725
#> attr(,"label")
#> [1] "Relative Reduction (%)"
#> 
#> $p_value
#> [1] 0.8931772
#> 
```
