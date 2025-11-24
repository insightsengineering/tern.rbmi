# Helper function to produce data frame with results of pool for a single visit

**\[experimental\]**

## Usage

``` r
h_tidy_pool(x)
```

## Arguments

- x:

  (`pool`) is a list of pooled object from `rbmi` analysis results. This
  list includes analysis results, confidence level, hypothesis testing
  type.

## Value

Data frame with results of pool for a single visit.

## Examples

``` r
data("rbmi_test_data")
pool_obj <- rbmi_test_data

h_tidy_pool(pool_obj$pars[1:3])
#>   group       est    se_est lower_cl_est upper_cl_est   est_contr  se_contr
#> 1   ref -1.615820 0.4862316    -2.575771   -0.6558685          NA        NA
#> 2   alt -1.707626 0.4749573    -2.645319   -0.7699335 -0.09180645 0.6826279
#>   lower_cl_contr upper_cl_contr   p_value relative_reduc
#> 1             NA             NA        NA             NA
#> 2      -1.439497       1.255884 0.8931772     0.05681725
```
