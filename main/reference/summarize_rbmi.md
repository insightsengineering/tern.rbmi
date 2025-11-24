# Analyze function for tabulating LS means estimates from tidied `rbmi` `pool` results.

**\[experimental\]**

## Usage

``` r
summarize_rbmi(
  lyt,
  ...,
  table_names = "rbmi_summary",
  .stats = NULL,
  .formats = NULL,
  .indent_mods = NULL,
  .labels = NULL
)
```

## Arguments

- lyt:

  (`layout`)  
  input layout where analyses will be added to.

- ...:

  additional argument.

- table_names:

  (`character`)  
  this can be customized in case that the same `vars` are analyzed
  multiple times, to avoid warnings from `rtables`.

- .stats:

  (`character`)  
  statistics to select for the table.

- .formats:

  (named `character` or `list`)  
  formats for the statistics.

- .indent_mods:

  (named `integer`)  
  indent modifiers for the labels.

- .labels:

  (named `character`)  
  labels for the statistics (without indent).

## Value

`rtables` layout for tabulating LS means estimates from tidied `rbmi`
`pool` results.

## Examples

``` r
library(rtables)
library(dplyr)
library(broom)

data("rbmi_test_data")
pool_obj <- rbmi_test_data

df <- tidy(pool_obj)

basic_table() %>%
  split_cols_by("group", ref_group = levels(df$group)[1]) %>%
  split_rows_by("visit", split_label = "Visit", label_pos = "topleft") %>%
  summarize_rbmi() %>%
  build_table(df)
#> Visit                                       ref                alt       
#> —————————————————————————————————————————————————————————————————————————
#> 4                                                                        
#>   Adjusted Mean (SE)                   -1.616 (0.486)     -1.708 (0.475) 
#>     95% CI                            (-2.576, -0.656)   (-2.645, -0.770)
#>   Difference in Adjusted Means (SE)                       -0.092 (0.683) 
#>     95% CI                                               (-1.439, 1.256) 
#>     Relative Reduction (%)                                     5.7%      
#>     p-value (RBMI)                                            0.8932     
#> 5                                                                        
#>   Adjusted Mean (SE)                   -4.225 (0.656)     -2.874 (0.648) 
#>     95% CI                            (-5.520, -2.930)   (-4.154, -1.593)
#>   Difference in Adjusted Means (SE)                       1.351 (0.922)  
#>     95% CI                                               (-0.470, 3.172) 
#>     Relative Reduction (%)                                    -32.0%     
#>     p-value (RBMI)                                            0.1447     
#> 6                                                                        
#>   Adjusted Mean (SE)                   -6.381 (0.703)     -4.159 (0.696) 
#>     95% CI                            (-7.771, -4.991)   (-5.536, -2.782)
#>   Difference in Adjusted Means (SE)                       2.222 (0.975)  
#>     95% CI                                                (0.296, 4.149) 
#>     Relative Reduction (%)                                    -34.8%     
#>     p-value (RBMI)                                            0.0241     
#> 7                                                                        
#>   Adjusted Mean (SE)                   -7.580 (0.791)     -4.760 (0.756) 
#>     95% CI                            (-9.145, -6.016)   (-6.254, -3.267)
#>   Difference in Adjusted Means (SE)                       2.820 (1.085)  
#>     95% CI                                                (0.676, 4.964) 
#>     Relative Reduction (%)                                    -37.2%     
#>     p-value (RBMI)                                            0.0103     
```
