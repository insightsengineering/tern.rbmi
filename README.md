# `tern.rbmi`

## Overview

`tern.rbmi` provides an interface for Reference Based Multiple Imputation (`rbmi`) within the `tern` framework. 

## Background

For details of the `rbmi` package, please see [Reference Based Multiple Imputation (rbmi)](https://github.com/insightsengineering/rbmi). The basic usage of `rbmi` core functions is described 
in the quickstart vignette:

```R
vignette(topic = "quickstart", package = "rbmi")
```

## Installation

This repository requires a personal access token to install see here [creating and using PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token). Once this is set up, to install the latest released version of the package run:

```r
Sys.setenv(GITHUB_PAT = "your_access_token_here")
if (!require("devtools")) install.packages("devtools")
devtools::install_github("insightsengineering/tern.rbmi@*release", dependencies = FALSE)
```

You might need to manually install all of the package dependencies before installing this package as without
the `dependencies = FALSE` argument to `install_github` it may produce an error.

See package vignettes `browseVignettes(package = "tern.rbmi")` for usage of this package.
