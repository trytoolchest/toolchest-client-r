
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

The R client requires a version of **Python 3.6 or greater** with
development libraries (`libpython`).

Most installed versions of Python 3.6 or greater will have the necessary
libraries installed with Python itself.

## Installing Python

New versions of Python can be installed via [the official
release](https://www.python.org/downloads/) or
[Anaconda](https://docs.anaconda.com/anaconda/install/index.html).

### Python on MacOS

For MacOS: The built-in `python3` version may not have the necessary
libraries. Installing Python from [Homebrew](https://brew.sh/) should
provide a version that does include them. Run the following from the
terminal:

``` shell
$ brew install python
```

<!-- TODO: add more detailed instructions about PATH -->

## Troubleshooting

## Finding a compatible version of Python

The installation may halt if no compatible version of Python is found.

### Manually setting Python

If Python is installed and problems persist, try directing the R client
to your Python installation directly, as follows on the R command line:

``` r
Sys.setenv(RETICULATE_PYTHON = "/path/to/your/python")
```

## Rebuilding `r-reticulate`

The message “Env `r-reticulate` must be rebuilt” may be encountered
during the install. **When encountering this prompt, select `Yes` to
proceed.** Selecting `No` will halt the install.

Toolchest runs on the `r-reticulate` Python virtual environment built by
the `reticulate` package. When `r-reticulate` is built an incompatible
version of Python, it must be re-built with a compatible version in
order for Toolchest to run correctly.

Note that this will overwrite the existing `r-reticulate` environment
with its rebuilt version, which should only pose a problem if any other
R packages depend on an incompatible version of Python and use the
`reticulate` package.

## Requiring a different version of Python

The install may require you to restart R if a compatible Python is found
that is different than the version loaded by the `reticulate` package.
**Restarting R and reloading the Toolchest package should fix this and
complete the installation:**

``` r
library(toolchest)
```