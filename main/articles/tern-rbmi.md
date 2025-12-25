# Introduction to tern.rbmi

## Introduction to tern.rbmi

------------------------------------------------------------------------

This vignette shows the general purpose and syntax of the `tern.rbmi` R
package. The `tern.rbmi` provides an interface for Reference Based
Multiple Imputation (`rbmi`) within the tern framework. For details of
the `rbmi` package, please see [Reference Based Multiple Imputation
(rbmi)](https://github.com/insightsengineering/rbmi). The basic usage of
`rbmi` core functions is described in the `quickstart` vignette:

``` r
vignette(topic = "quickstart", package = "rbmi")
```

------------------------------------------------------------------------

## Example of using `tern.rbmi`

The `rbmi` package consists of 4 core functions (plus several helper
functions) which are typically called in sequence:

- `draws()` - fits the imputation models and stores their parameters
- `impute()` - creates multiple imputed datasets
- `analyse()` - analyses each of the multiple imputed datasets
- `pool()` - combines the analysis results across imputed datasets into
  a single statistic

### The Data

We use a publicly available example dataset from an antidepressant
clinical trial of an active drug versus placebo. The relevant endpoint
is the Hamilton 17-item depression rating scale (`HAMD17`) which was
assessed at baseline and at weeks 1, 2, 4, and 6. Study drug
discontinuation occurred in 24% of subjects from the active drug and 26%
of subjects from placebo. All data after study drug discontinuation are
missing and there is a single additional intermittent missing
observation.

``` r
library(tern.rbmi)
#> Loading required package: rbmi
#> Loading required package: tern
#> Loading required package: rtables
#> Loading required package: formatters
#> 
#> Attaching package: 'formatters'
#> The following object is masked from 'package:base':
#> 
#>     %||%
#> Loading required package: magrittr
#> 
#> Attaching package: 'rtables'
#> The following object is masked from 'package:utils':
#> 
#>     str
#> Registered S3 method overwritten by 'tern':
#>   method   from 
#>   tidy.glm broom
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

``` r
data <- antidepressant_data
levels(data$THERAPY) <- c("PLACEBO", "DRUG") # This is important! The order defines the computation order later

missing_var <- "CHANGE"
vars <- list(
  id = "PATIENT",
  visit = "VISIT",
  expand_vars = c("BASVAL", "THERAPY"),
  group = "THERAPY"
)
covariates <- list(
  draws = c("BASVAL*VISIT", "THERAPY*VISIT"),
  analyse = c("BASVAL")
)

data <- data %>%
  dplyr::select(PATIENT, THERAPY, VISIT, BASVAL, THERAPY, CHANGE) %>%
  dplyr::mutate(dplyr::across(.cols = vars$id, ~ as.factor(.x))) %>%
  dplyr::arrange(dplyr::across(.cols = c(vars$id, vars$visit)))
```

``` r
# Use expand_locf to add rows corresponding to visits with missing outcomes to the dataset
data_full <- do.call(
  expand_locf,
  args = list(
    data = data,
    vars = c(vars$expand_vars, vars$group),
    group = vars$id,
    order = c(vars$id, vars$visit)
  ) %>%
    append(lapply(data[c(vars$id, vars$visit)], levels))
)

data_full <- data_full %>%
  dplyr::group_by(dplyr::across(vars$id)) %>%
  dplyr::mutate(!!vars$group := Filter(Negate(is.na), .data[[vars$group]])[1])

# there are duplicates - use first value
data_full <- data_full %>%
  dplyr::group_by(dplyr::across(c(vars$id, vars$group, vars$visit))) %>%
  dplyr::slice(1) %>%
  dplyr::ungroup()
# need to have a single ID column
data_full <- data_full %>%
  tidyr::unite("TMP_ID", dplyr::all_of(vars$id), sep = "_#_", remove = FALSE) %>%
  dplyr::mutate(TMP_ID = as.factor(TMP_ID))
```

#### Creating intercurrent event data

Set the imputation strategy to MAR for each patient with at least one
missing observation.

``` r
data_ice <- data_full %>%
  dplyr::arrange(dplyr::across(.cols = c("TMP_ID", vars$visit))) %>%
  dplyr::filter(is.na(.data[[missing_var]])) %>%
  dplyr::group_by(TMP_ID) %>%
  dplyr::slice(1) %>%
  dplyr::ungroup() %>%
  dplyr::select(all_of(c("TMP_ID", vars$visit))) %>%
  dplyr::mutate(strategy = "MAR")
```

### Draws

The
[`rbmi::draws()`](https://insightsengineering.github.io/rbmi/latest-tag/reference/draws.html)
function fits the imputation models and stores the corresponding
parameter estimates or Bayesian posterior parameter draws. The three
main inputs to the
[`rbmi::draws()`](https://insightsengineering.github.io/rbmi/latest-tag/reference/draws.html)
function are:

- data - The primary longitudinal data.frame containing the outcome
  variable and all covariates.
- data_ice - A data.frame which specifies the first visit affected by an
  intercurrent event (ICE) and the imputation strategy for handling
  missing outcome data after the ICE. At most one ICE which is to be
  imputed by a non-MAR strategy is allowed per subject.
- method - The statistical method used to fit the imputation models and
  to create imputed datasets.

#### Define key variables

Define the names of key variables in our dataset and the covariates
included in the imputation model using
[`rbmi::set_vars()`](https://insightsengineering.github.io/rbmi/latest-tag/reference/set_vars.html).
Note that the covariates argument can also include interaction terms.

``` r
debug_mode <- FALSE

draws_vars <- rbmi::set_vars(
  outcome = missing_var,
  visit = vars$visit,
  group = vars$group,
  covariates = covariates$draws
)
draws_vars$subjid <- "TMP_ID"
```

Define which imputation method to use, then create samples for the
imputation parameters by running the `draws()` function.

``` r
draws_method <- rbmi::method_bayes()

draws_obj <- rbmi::draws(
  data = data_full,
  data_ice = data_ice,
  vars = draws_vars,
  method = draws_method
)
#> 
#> SAMPLING FOR MODEL 'rbmi_MMRM_us_default' NOW (CHAIN 1).
#> Chain 1: 
#> Chain 1: Gradient evaluation took 0.000231 seconds
#> Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 2.31 seconds.
#> Chain 1: Adjust your expectations accordingly!
#> Chain 1: 
#> Chain 1: 
#> Chain 1: Iteration:    1 / 1200 [  0%]  (Warmup)
#> Chain 1: Iteration:  120 / 1200 [ 10%]  (Warmup)
#> Chain 1: Iteration:  201 / 1200 [ 16%]  (Sampling)
#> Chain 1: Iteration:  320 / 1200 [ 26%]  (Sampling)
#> Chain 1: Iteration:  440 / 1200 [ 36%]  (Sampling)
#> Chain 1: Iteration:  560 / 1200 [ 46%]  (Sampling)
#> Chain 1: Iteration:  680 / 1200 [ 56%]  (Sampling)
#> Chain 1: Iteration:  800 / 1200 [ 66%]  (Sampling)
#> Chain 1: Iteration:  920 / 1200 [ 76%]  (Sampling)
#> Chain 1: Iteration: 1040 / 1200 [ 86%]  (Sampling)
#> Chain 1: Iteration: 1160 / 1200 [ 96%]  (Sampling)
#> Chain 1: Iteration: 1200 / 1200 [100%]  (Sampling)
#> Chain 1: 
#> Chain 1:  Elapsed Time: 0.438 seconds (Warm-up)
#> Chain 1:                1.569 seconds (Sampling)
#> Chain 1:                2.007 seconds (Total)
#> Chain 1:
#> Warning in fit_mcmc(designmat = model_df_scaled[, -1, drop = FALSE], outcome = model_df_scaled[, : The largest R-hat is 1.22, indicating chains have not mixed.
#> Running the chains for more iterations may help. See
#> https://mc-stan.org/misc/warnings.html#r-hat
```

### Impute

The next step is to use the parameters from the imputation model to
generate the imputed datasets. This is done via the
[`rbmi::impute()`](https://insightsengineering.github.io/rbmi/latest-tag/reference/impute.html)
function. The function only has two key inputs: the imputation model
output from
[`rbmi::draws()`](https://insightsengineering.github.io/rbmi/latest-tag/reference/draws.html)
and the reference groups relevant to reference-based imputation methods.
Its usage is thus:

``` r
impute_references <- c("DRUG" = "PLACEBO", "PLACEBO" = "PLACEBO")

impute_obj <- rbmi::impute(
  draws_obj,
  references = impute_references
)
```

### Analyze

The next step is to run the analysis model on each imputed dataset. This
is done by defining an analysis function and then calling
[`rbmi::analyse()`](https://insightsengineering.github.io/rbmi/latest-tag/reference/analyse.html)
to apply this function to each imputed dataset.

``` r
# Define analysis model
analyse_fun <- ancova

ref_levels <- levels(impute_obj$data$group[[1]])
names(ref_levels) <- c("ref", "alt")

analyse_obj <- rbmi::analyse(
  imputations = impute_obj,
  fun = analyse_fun,
  vars = rbmi::set_vars(
    subjid = "TMP_ID",
    outcome = missing_var,
    visit = vars$visit,
    group = vars$group,
    covariates = covariates$analyse
  )
)
```

### Pool

The
[`rbmi::pool()`](https://insightsengineering.github.io/rbmi/latest-tag/reference/pool.html)
function can be used to summarize the analysis results across multiple
imputed datasets to provide an overall statistic with a standard error,
confidence intervals and a p-value for the hypothesis test of the null
hypothesis that the effect is equal to 0.

``` r
pool_obj <- rbmi::pool(
  results = analyse_obj,
  conf.level = 0.95,
  alternative = c("two.sided", "less", "greater"),
  type = c("percentile", "normal")
)
```

### Create output

Finally create output with `rtables` and `tern` packages

``` r
library(broom)

df <- tidy(pool_obj)
df
#>   group       est    se_est lower_cl_est upper_cl_est   est_contr  se_contr
#> 1   ref -1.615820 0.4862316    -2.575771   -0.6558685          NA        NA
#> 2   alt -1.707626 0.4749573    -2.645319   -0.7699335 -0.09180645 0.6826279
#> 3   ref -4.232449 0.6545980    -5.525319   -2.9395788          NA        NA
#> 4   alt -2.755938 0.6376072    -4.015164   -1.4967127  1.47651061 0.9150973
#> 5   ref -6.398943 0.7112831    -7.804702   -4.9931846          NA        NA
#> 6   alt -4.096711 0.7014969    -5.483622   -2.7098009  2.30223161 1.0133119
#> 7   ref -7.685237 0.8084819    -9.285536   -6.0849389          NA        NA
#> 8   alt -4.768890 0.7826814    -6.317460   -3.2203197  2.91634721 1.1540718
#>   lower_cl_contr upper_cl_contr    p_value relative_reduc visit conf_level
#> 1             NA             NA         NA             NA     4       0.95
#> 2     -1.4394968       1.255884 0.89317724     0.05681725     4       0.95
#> 3             NA             NA         NA             NA     5       0.95
#> 4     -0.3306770       3.283698 0.10860056    -0.34885493     5       0.95
#> 5             NA             NA         NA             NA     6       0.95
#> 6      0.2984360       4.306027 0.02464870    -0.35978311     6       0.95
#> 7             NA             NA         NA             NA     7       0.95
#> 8      0.6300237       5.202671 0.01288127    -0.37947393     7       0.95
```

Final product, reshape `rbmi` final results to nicely formatted `rtable`
object.

``` r
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
#>   Adjusted Mean (SE)                   -4.232 (0.655)     -2.756 (0.638) 
#>     95% CI                            (-5.525, -2.940)   (-4.015, -1.497)
#>   Difference in Adjusted Means (SE)                       1.477 (0.915)  
#>     95% CI                                               (-0.331, 3.284) 
#>     Relative Reduction (%)                                    -34.9%     
#>     p-value (RBMI)                                            0.1086     
#> 6                                                                        
#>   Adjusted Mean (SE)                   -6.399 (0.711)     -4.097 (0.701) 
#>     95% CI                            (-7.805, -4.993)   (-5.484, -2.710)
#>   Difference in Adjusted Means (SE)                       2.302 (1.013)  
#>     95% CI                                                (0.298, 4.306) 
#>     Relative Reduction (%)                                    -36.0%     
#>     p-value (RBMI)                                            0.0246     
#> 7                                                                        
#>   Adjusted Mean (SE)                   -7.685 (0.808)     -4.769 (0.783) 
#>     95% CI                            (-9.286, -6.085)   (-6.317, -3.220)
#>   Difference in Adjusted Means (SE)                       2.916 (1.154)  
#>     95% CI                                                (0.630, 5.203) 
#>     Relative Reduction (%)                                    -37.9%     
#>     p-value (RBMI)                                            0.0129
```
