#' Tabulation of `RBMI` Results
#'
#' These functions can be used to produce tables from a fitted `RBMI` produced
#'
#' @name tabulate_rbmi
#'
NULL

#' @describeIn tabulate_rbmi Helper function to produce data frame with results
#' of pool for a single visit
#' @param x (`list`)
#' @export
#'
h_tidy_pool <- function(x) {
  contr <- x[[grep("trt_", names(x))]]
  ref <- x[[grep("lsm_ref_", names(x))]]
  alt <- x[[grep("lsm_alt_", names(x))]]

  df_ref <- data.frame(
    group = "ref",
    est = ref$est,
    se_est = ref$se,
    lower_cl_est = ref$ci[1],
    upper_cl_est = ref$ci[2],
    est_contr = NA_real_,
    se_contr = NA_real_,
    lower_cl_contr = NA_real_,
    upper_cl_contr = NA_real_,
    p_value = NA_real_,
    relative_reduc = NA_real_,
    stringsAsFactors = FALSE
  )

  df_alt <- data.frame(
    group = "alt",
    est = alt$est,
    se_est = alt$se,
    lower_cl_est = alt$ci[1],
    upper_cl_est = alt$ci[2],
    est_contr = contr$est,
    se_contr = contr$se,
    lower_cl_contr = contr$ci[1],
    upper_cl_contr = contr$ci[2],
    p_value = contr$pvalue,
    relative_reduc = contr$est / df_ref$est,
    stringsAsFactors = FALSE
  )

  result <- rbind(
    df_ref,
    df_alt
  )

  result
}

#' @describeIn tabulate_rbmi Helper method (for [`broom::tidy()`]) to prepare a data frame from an
#'   `pool` rbmi object containing the LS means and contrasts and multiple visits
#' @method tidy pool
#' @param x (`pool`)
#' @export
#' @return A dataframe
#'
tidy.pool <- function(x) { # nolint

  ls_raw <- x$pars

  visit_raw_names <- names(ls_raw)[grep("trt_", names(ls_raw))]
  l_visit_names <- strsplit(visit_raw_names, "trt_")
  visit_names <- vapply(l_visit_names, `[`, 2, FUN.VALUE = character(1))

  spl <- rep(visit_names, each = 3)

  ls_split <- split(ls_raw, spl)

  ls_df <- lapply(ls_split, h_tidy_pool)

  result <- do.call(rbind, unname(ls_df))

  result$visit <- factor(rep(visit_names, each = 2))
  result$group <- factor(result$group, levels = c("ref", "alt"))
  result$conf_level <- x$conf.level

  result
}

#' @describeIn tabulate_rbmi Statistics function which is extracting estimates from a tidied LS means
#'   data frame.
#'
#' @param df input dataframe
#' @param .in_ref_col boolean variable, if reference column is specified
#' @param show_relative should the "reduction" (`control - treatment`, default) or the "increase"
#'   (`treatment - control`) be shown for the relative change from baseline?
#' @export
#'
s_rbmi_lsmeans <- function(df, .in_ref_col, show_relative = c("reduction", "increase")) {
  show_relative <- match.arg(show_relative)
  if_not_ref <- function(x) `if`(.in_ref_col, character(), x)
  list(
    adj_mean_se = c(df$est, df$se_est),
    adj_mean_ci = formatters::with_label(
      c(df$lower_cl_est, df$upper_cl_est),
      f_conf_level(df$conf_level)
    ),
    diff_mean_se = if_not_ref(c(df$est_contr, df$se_contr)),
    diff_mean_ci = formatters::with_label(if_not_ref(c(df$lower_cl_contr, df$upper_cl_contr)), f_conf_level(df$conf_level)),
    change = switch(show_relative,
      reduction = formatters::with_label(if_not_ref(df$relative_reduc), "Relative Reduction (%)"),
      increase = formatters::with_label(if_not_ref(-df$relative_reduc), "Relative Increase (%)")
    ),
    p_value = if_not_ref(df$p_value)
  )
}

#' @describeIn tabulate_rbmi Formatted Analysis function which can be further customized by calling
#'   [`rtables::make_afun()`] on it. It is used as `afun` in [`rtables::analyze()`].
#' @export
#'
a_rbmi_lsmeans <- make_afun(
  s_rbmi_lsmeans,
  .labels = c(
    adj_mean_se = "Adjusted Mean (SE)",
    diff_mean_se = "Difference in Adjusted Means (SE)",
    p_value = "p-value (RBMI)"
  ),
  .formats = c(
    # n = "xx.", # note we don't have N from `rbmi` result
    adj_mean_se = sprintf_format("%.3f (%.3f)"),
    adj_mean_ci = "(xx.xxx, xx.xxx)",
    diff_mean_se = sprintf_format("%.3f (%.3f)"),
    diff_mean_ci = "(xx.xxx, xx.xxx)",
    change = "xx.x%",
    p_value = "x.xxxx | (<0.0001)"
  ),
  .indent_mods = c(
    adj_mean_ci = 1L,
    diff_mean_ci = 1L,
    change = 1L,
    p_value = 1L
  ),
  .null_ref_cells = FALSE
)

#' @describeIn tabulate_rbmi Analyze function for tabulating LS means estimates from tidied
#'   `rbmi` `pool` results.
#' @param lyt (`layout`)\cr input layout where analyses will be added to.
#' @param table_names (`character`)\cr this can be customized in case that the same `vars` are analyzed multiple times,
#'   to avoid warnings from `rtables`.
#' @param .stats (`character`)\cr statistics to select for the table.
#' @param .formats (named `character` or `list`)\cr formats for the statistics.
#' @param .indent_mods (named `integer`)\cr indent modifiers for the labels.
#' @param .labels (named `character`)\cr labels for the statistics (without indent).
#' @param ... additional argument.
#' @export
#' @examples
#' library(rtables)
#' library(dplyr)
#' library(broom)
#' library(rbmi)
#'
#' data <- antidepressant_data
#' levels(data$THERAPY) <- c("PLACEBO", "DRUG") # This is important! The order defines the computation order later
#' missing_var <- "CHANGE"
#' vars <- list(
#'   id = "PATIENT",
#'   visit = "VISIT",
#'   expand_vars = c("BASVAL", "THERAPY"),
#'   group = "THERAPY"
#' )
#' covariates <- list(
#'   draws = c("BASVAL*VISIT", "THERAPY*VISIT"),
#'   analyse = c("BASVAL")
#' )
#' draws_vars <- set_vars(
#'   outcome = missing_var,
#'   visit = vars$visit,
#'   group = vars$group,
#'   covariates = covariates$draws
#' )
#' impute_references <- c("DRUG" = "PLACEBO", "PLACEBO" = "PLACEBO")
#' draws_method <- method_bayes()
#' analyse_fun <- ancova
#' analyse_fun_args <- list(
#'   vars = set_vars(
#'     outcome = missing_var,
#'     visit = vars$visit,
#'     group = vars$group,
#'     covariates = covariates$analyse
#'   )
#' )
#' pool_args <- list(
#'   conf.level = formals(pool)$conf.level,
#'   alternative = formals(pool)$alternative,
#'   type = formals(pool)$type
#' )
#' debug_mode <- FALSE
#'
#' data <- data %>%
#'   dplyr::select(dplyr::all_of(c(vars$id, vars$group, vars$visit, vars$expand_vars, missing_var))) %>%
#'   dplyr::mutate(dplyr::across(.cols = vars$id, ~ as.factor(.x))) %>%
#'   dplyr::arrange(dplyr::across(.cols = c(vars$id, vars$visit)))
#' data_full <- do.call(
#'   expand_locf,
#'   args = list(
#'     data = data,
#'     vars = c(vars$expand_vars, vars$group),
#'     group = vars$id,
#'     order = c(vars$id, vars$visit)
#'   ) %>%
#'     append(lapply(data[c(vars$id, vars$visit)], levels))
#' )
#'
#' data_full <- data_full %>%
#'   dplyr::group_by(dplyr::across(vars$id)) %>%
#'   dplyr::mutate(!!vars$group := Filter(Negate(is.na), .data[[vars$group]])[1])
#'
#' # there are duplicates - use first value
#' data_full <- data_full %>%
#'   dplyr::group_by(dplyr::across(c(vars$id, vars$group, vars$visit))) %>%
#'   dplyr::slice(1) %>%
#'   dplyr::ungroup()
#' # need to have a single ID column
#' data_full <- data_full %>%
#'   tidyr::unite("TMP_ID", dplyr::all_of(vars$id), sep = "_#_", remove = FALSE) %>%
#'   dplyr::mutate(TMP_ID = as.factor(TMP_ID))
#' draws_vars$subjid <- "TMP_ID"
#'
#' data_ice <- data_full %>%
#'   dplyr::arrange(dplyr::across(.cols = c("TMP_ID", vars$visit))) %>%
#'   dplyr::filter(is.na(.data[[missing_var]])) %>%
#'   dplyr::group_by(TMP_ID) %>%
#'   dplyr::slice(1) %>%
#'   dplyr::ungroup() %>%
#'   dplyr::select(all_of(c("TMP_ID", vars$visit))) %>%
#'   dplyr::mutate(strategy = "MAR")
#'
#' draws_obj <- draws(
#'   data = data_full,
#'   data_ice = data_ice,
#'   vars = draws_vars,
#'   method = draws_method
#' )
#' impute_obj <- impute( # @TODO: add support of `update_stategy` argument
#'   draws_obj,
#'   references = impute_references
#' )
#'
#' ref_levels <- levels(impute_obj$data$group[[1]])
#' names(ref_levels) <- c("ref", "alt")
#' analyse_fun_args$vars$subjid <- "TMP_ID"
#' analyse_obj <- do.call(
#'   analyse, # @TODO: add support of `delta` argument
#'   args = list(
#'     imputations = impute_obj,
#'     fun = analyse_fun
#'   ) %>%
#'     append(analyse_fun_args)
#' )
#' pool_obj <- do.call(
#'   pool,
#'   args = list(
#'     results = analyse_obj
#'   ) %>%
#'     append(pool_args)
#' )
#'
#' h_tidy_pool(pool_obj$pars[1:3])
#' df <- tidy(pool_obj)
#' df
#'
#' s_rbmi_lsmeans(df[2, ], .in_ref_col = FALSE)
#'
#' afun <- make_afun(a_rbmi_lsmeans)
#' afun(df[2, ], .in_ref_col = FALSE)
#'
#' basic_table() %>%
#'   split_cols_by("group", ref_group = levels(df$group)[1]) %>%
#'   split_rows_by("visit", split_label = "Visit", label_pos = "topleft") %>%
#'   summarize_rbmi() %>%
#'   build_table(df)
#'
summarize_rbmi <- function(lyt,
                           ...,
                           table_names = "rbmi_summary",
                           .stats = NULL,
                           .formats = NULL,
                           .indent_mods = NULL,
                           .labels = NULL) {
  afun <- make_afun(
    a_rbmi_lsmeans,
    .stats = .stats,
    .formats = .formats,
    .indent_mods = .indent_mods,
    .labels = .labels
  )
  analyze(
    lyt = lyt,
    vars = "est",
    afun = afun,
    table_names = table_names,
    extra_args = list(...)
  )
}
