# `tern.rbmi`

## Overview

`tern.rbmi` provides an interface for Reference Based Multiple Imputation (`rbmi`) within the `tern` framework.

## Background

For details of the `rbmi` package, please see [Reference Based Multiple Imputation (rbmi)](https://github.com/insightsengineering/rbmi). The basic usage of `rbmi` core functions is described
in the `quickstart` vignette:

```R
vignette(topic = "quickstart", package = "rbmi")
```

## Installation

For releases from August 2022 it is recommended that you [create and use a Github PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to install the latest version of this package. Once you have the PAT, run the following:

```r
Sys.setenv(GITHUB_PAT = "your_access_token_here")
if (!require("remotes")) install.packages("remotes")
remotes::install_github("insightsengineering/tern.rbmi@*release")
```

A stable release of all `NEST` packages from June 2022 is also available [here](https://github.com/insightsengineering/depository#readme).

See package vignettes `browseVignettes(package = "tern.rbmi")` for usage of this package.

[![Stargazers repo roster for @insightsengineering/tern.rbmi](https://reporoster.com/stars/insightsengineering/tern.rbmi)](https://github.com/insightsengineering/tern.rbmi/stargazers)
[![Forkers repo roster for @insightsengineering/tern.rbmi](https://reporoster.com/forks/insightsengineering/tern.rbmi)](https://github.com/insightsengineering/tern.rbmi/network/members)

## Stargazers over time

[![Stargazers over time](https://starchart.cc/insightsengineering/tern.rbmi.svg)](https://starchart.cc/insightsengineering/tern.rbmi)
