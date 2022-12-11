# `tern.rbmi`

<!-- start badges -->
[![Check 🛠](https://github.com/insightsengineering/tern.rbmi/actions/workflows/check.yaml/badge.svg)](https://github.com/insightsengineering/tern.rbmi/actions/workflows/check.yaml)
[![Docs 📚](https://github.com/insightsengineering/tern.rbmi/actions/workflows/docs.yaml/badge.svg)](https://insightsengineering.github.io/tern.rbmi/)
[![Code Coverage 📔](https://raw.githubusercontent.com/insightsengineering/tern.rbmi/_xml_coverage_reports/data/main/badge.svg)](https://raw.githubusercontent.com/insightsengineering/tern.rbmi/_xml_coverage_reports/data/main/coverage.xml)

![GitHub forks](https://img.shields.io/github/forks/insightsengineering/tern.rbmi?style=social)
![GitHub Repo stars](https://img.shields.io/github/stars/insightsengineering/tern.rbmi?style=social)

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/insightsengineering/tern.rbmi)
![GitHub contributors](https://img.shields.io/github/contributors/insightsengineering/tern.rbmi)
![GitHub last commit](https://img.shields.io/github/last-commit/insightsengineering/tern.rbmi)
![GitHub pull requests](https://img.shields.io/github/issues-pr/insightsengineering/tern.rbmi)
![GitHub repo size](https://img.shields.io/github/repo-size/insightsengineering/tern.rbmi)
![GitHub language count](https://img.shields.io/github/languages/count/insightsengineering/tern.rbmi)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Current Version](https://img.shields.io/github/r-package/v/insightsengineering/tern.rbmi/main?color=purple\&label=package%20version)](https://github.com/insightsengineering/tern.rbmi/tree/main)
[![Open Issues](https://img.shields.io/github/issues-raw/insightsengineering/tern.rbmi?color=red\&label=open%20issues)](https://github.com/insightsengineering/tern.rbmi/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)
<!-- end badges -->

[![Code Coverage](https://raw.githubusercontent.com/insightsengineering/tern.rbmi/_xml_coverage_reports/data/main/badge.svg)](https://raw.githubusercontent.com/insightsengineering/tern.rbmi/_xml_coverage_reports/data/main/coverage.xml)

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

## Stargazers and Forkers

### Stargazers over time

[![Stargazers over time](https://starchart.cc/insightsengineering/tern.rbmi.svg)](https://starchart.cc/insightsengineering/tern.rbmi)

### Stargazers

[![Stargazers repo roster for @insightsengineering/tern.rbmi](https://reporoster.com/stars/insightsengineering/tern.rbmi)](https://github.com/insightsengineering/tern.rbmi/stargazers)

### Forkers

[![Forkers repo roster for @insightsengineering/tern.rbmi](https://reporoster.com/forks/insightsengineering/tern.rbmi)](https://github.com/insightsengineering/tern.rbmi/network/members)
