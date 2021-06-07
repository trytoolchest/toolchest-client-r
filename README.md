
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
toolchest::tool_name("tool_args")
```

`tool_name` is the name of the desired tool, and `tool_args` contains
any additional arguments to be passed to the function.

Input and output paths can be specified as well:

``` r
toolchest::tool_name(
    tool_args,
    input_path = "/path/to/input",
    output_path = "/path/to/output"
)
```

If these are necessary but not specified, you can select them
interactively.

### Tools

Toolchest currently supports the following tools:

-   Cutadapt (`cutadapt`)

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools") # uncomment to install devtools (prereq package)
devtools::install_github("gotoolchest/toolchest-client-r")
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
Sys.setenv(TOOLCHEST_KEY = "{your key goes here}")
```

### .Renviron

To prevent having to load the `TOOLCHEST_KEY` value every time R starts,
you can add the value to your `.Renviron` file.

If you don’t know what this is or if you’re unsure if this file exists,
use `Sys.getenv("R_USER")` to find the location of your home folder, and
create a file named `.Renviron`. Then, add the following line to it:

    TOOLCHEST_KEY = {your key goes here}
