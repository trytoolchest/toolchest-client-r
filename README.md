
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Toolchest R Client

<!-- badges: start -->

[![R-CMD-check](https://github.com/trytoolchest/toolchest-client-r/workflows/R-CMD-check/badge.svg)](https://github.com/trytoolchest/toolchest-client-r/actions)
<!-- badges: end -->

Toolchest runs computational biology software in the cloud with just a
few lines of code. You can call Toolchest from anywhere Python or R
runs, using input files located on your computer or S3.

This package contains the **R** client for using Toolchest. For the
**Python** client, [see
here](https://github.com/trytoolchest/toolchest-client-python).

## [Documentation & User Guide](https://docs.trytoolchest.com/docs)

## Usage

Using Toolchest is as simple as:

1.  installing the client (listed as the `toolchest` package)

2.  configuring Toolchest with your given Toolchest key:

``` r
toolchest::set_key("YOUR_TOOLCHEST_KEY")
```

3.  running the following:

``` r
toolchest::tool_name(tool_args)
```

`tool_name` is the name of the desired tool, and `tool_args` is a string
containing any additional arguments to be passed to the function.

Input and output paths can be specified as well:

``` r
toolchest::tool_name(
    tool_args,
    inputs = "/path/to/input",
    output_path = "/path/to/output"
)
```

A list of tools can be found on the [Toolchest docs
page](https://docs.trytoolchest.com/docs).

## [Installation](INSTALL.md)

You can install the development version from
[GitHub](https://github.com/trytoolchest/toolchest-client-r) with:

``` r
# install.packages("devtools") # uncomment to install devtools (prereq package)
devtools::install_github("trytoolchest/toolchest-client-r", dependencies = TRUE)
library(toolchest)
```

### R dependencies

The R client requires the
[`reticulate`](https://rstudio.github.io/reticulate/index.html) package,
version **1.25 or greater**.

Install or update `reticulate` with:

``` r
install.packages("reticulate")
```

### Python requirements

The R client requires a version of **Python 3.7 or greater**.

A compatible version will automatically be installed via miniconda or
pyenv, using R???s `reticulate` package.

### Troubleshooting

For more details, see [the INSTALL page](INSTALL.md). If you???re having
trouble with installation, consult the page and/or contact Toolchest
directly.

## Configuration

To use Toolchest, you must have an authentication key.

Contact Toolchest if:

-   you need a key
-   you???ve forgotten your key
-   the key is producing authentication errors.

Once you have your key, set the environment variable `TOOLCHEST_KEY` to
the key value:

``` r
toolchest::set_key("YOUR_TOOLCHEST_KEY")
```

### .Renviron

To prevent having to load the `TOOLCHEST_KEY` value every time R starts,
you can add the value to your `.Renviron` file.

If you don???t know what this is or if you???re unsure if this file exists,
use `Sys.getenv("R_USER")` in R to find the location of your home
folder, and create a file named `.Renviron`. Then, add the following
line to it:

    TOOLCHEST_KEY = YOUR_TOOLCHEST_KEY

where `YOUR_TOOLCHEST_KEY` is the value of your Toolchest key.

Note that these changes must be loaded in order to take effect. This
automatically happens at the start of each R session.

After adding/editing an `.Renviron` file *during* your R session, you
can proceed to load `.Renviron` into your current R session as follows:

``` r
readRenviron("~/.Renviron")
```

## Help / R Studio Documentation

Visit our main docs page at
[docs.trytoolchest.com](https://docs.trytoolchest.com/).

Documentation for each tool can also be accessed within R, just like any
other function in an R package. For help on how to use an individual
tool, use either of the following:

-   `help(tool_name)`
-   `?toolchest::tool_name` (or simply `?tool_name`)
