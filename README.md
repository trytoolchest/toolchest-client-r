
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Toolchest R Client

<!-- badges: start -->
<!-- badges: end -->

Toolchest provides APIs for scientific and bioinformatic data analysis.
It allows you to abstract away the costliness of running tools on your
own resources by running the same jobs on secure, powerful remote
servers.

This package contains the **R** client for using Toolchest. For the
**Python** client, [see
here](https://github.com/trytoolchest/toolchest-client-python).

## Usage

Using Toolchest is as simple as installing the client (listed as the
`toolchest` package) and running the following:

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

If these are necessary but not specified, you can select them
interactively.

### Tools

Toolchest currently supports the following tools:

-   Bowtie 2 (`bowtie2`)
-   Cutadapt (`cutadapt`)
-   Kraken 2 (`kraken2`)
-   STAR (`STAR`)
-   Unicycler (`unicycler`)

A `test` function is also supplied, which mimics how using a tool would
work in Toolchest.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools") # uncomment to install devtools (prereq package)
devtools::install_github("trytoolchest/toolchest-client-r")
```

## Configuration

To use Toolchest, you must have an authentication key.

Contact Toolchest if:

-   you need a key
-   you’ve forgotten your key
-   the key is producing authentication errors.

Once you have your key, set the environment variable `TOOLCHEST_KEY` to
the key value:

``` r
toolchest::set_key("YOUR_TOOLCHEST_KEY")
```

### .Renviron

To prevent having to load the `TOOLCHEST_KEY` value every time R starts,
you can add the value to your `.Renviron` file.

If you don’t know what this is or if you’re unsure if this file exists,
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

## Help / Documentation

Documentation for each tool can be accessed within R, just like for any
other R function. For help on how to use an individual tool, use either
of the following:

-   `help(tool_name)`
-   `?toolchest::tool_name` (or simply `?tool_name`)
