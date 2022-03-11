
# Installation

This page contains detailed instructions for installing the Toolchest R
client.

If an installation problem persists, contact Toolchest directly, or
[file an issue on Github with the encountered
errors](https://github.com/trytoolchest/toolchest-client-r/issues).

## Base Instructions

You can install the development version from
[GitHub](https://github.com/trytoolchest/toolchest-client-r) with:

``` r
# install.packages("devtools") # uncomment to install devtools (prereq package)
devtools::install_github("trytoolchest/toolchest-client-r")
library(toolchest)
```

## Requirements

### R dependencies

The R client requires the
[`reticulate`](https://rstudio.github.io/reticulate/index.html) package,
version **1.24 or greater**.

Install or update `reticulate` with:

``` r
install.packages("reticulate")
```

### Python

The R client requires a version of **Python 3.6 or greater**.

A compatible version will automatically be installed via miniconda or
pyenv, using R’s `reticulate` package.

## Troubleshooting

### Updating reticulate

Some compatibility errors may occur during installation if `reticulate`
is out-of-date. Check the package version:

``` r
packageVersion("reticulate")
```

If this is not **1.24** or greater, update the package with:

``` r
install.packages("reticulate")
```

Contact Toolchest if installation errors persist.
