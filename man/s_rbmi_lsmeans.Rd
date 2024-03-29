% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tabulate_rbmi.R
\name{s_rbmi_lsmeans}
\alias{s_rbmi_lsmeans}
\title{Statistics function which is extracting estimates from a tidied LS means
data frame.}
\usage{
s_rbmi_lsmeans(df, .in_ref_col, show_relative = c("reduction", "increase"))
}
\arguments{
\item{df}{input dataframe}

\item{.in_ref_col}{boolean variable, if reference column is specified}

\item{show_relative}{"reduction" if (\code{control - treatment}, default) or "increase"
(\code{treatment - control}) of relative change from baseline?}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\examples{
library(rtables)
library(dplyr)
library(broom)

data("rbmi_test_data")
pool_obj <- rbmi_test_data
df <- tidy(pool_obj)

s_rbmi_lsmeans(df[1, ], .in_ref_col = TRUE)

s_rbmi_lsmeans(df[2, ], .in_ref_col = FALSE)

}
