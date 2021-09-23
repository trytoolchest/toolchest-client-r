#' Installs and loads the `toolchest_client` Python package when loading
#' the R package.
#'
#' Note: The Python package interface is stored in the global variable `toolchest_client`.
#'
#'
.onLoad <- function(libname, pkgname) {
  packageStartupMessage("Installing Toolchest client... ")

  # packageStartupMessage("Configuring python...")
  # py_version <- "3.8.7"
  # reticulate::install_python(version = py_version)

  packageStartupMessage("Configuring reticulate...")
  if (reticulate::virtualenv_exists("r-reticulate")) {
    cat("checking version")
    version_check <- reticulate::py_run_string("from distutils.version import LooseVersion
import setuptools

setuptools_version = setuptools.__version__
reset_setuptools = (LooseVersion(setuptools_version) >= LooseVersion('58.0.2'))
")
    if (version_check$reset_setuptools || T) {
      cat("reinstalling setuptools")
      packageStartupMessage("Incompatible version of setuptools detected. Reinstalling setuptools...")
      reticulate::virtualenv_remove("r-reticulate", "setuptools")
      reticulate::virtualenv_install("r-reticulate", "setuptools==58.0.0")
    }
  } else {
    packageStartupMessage("Creating Python virtual environment...")
    reticulate::virtualenv_create("r-reticulate", setuptools_version = "58.0.0")
  }

  reticulate::virtualenv_install(
    envname = "r-reticulate",
    packages = "toolchest_client",
    ignore_installed = TRUE
  )
  reticulate::configure_environment("toolchest_client")
  toolchest_client <<- reticulate::import("toolchest_client", delay_load = TRUE)

  packageStartupMessage("The Toolchest client has been installed!")

  # Detect if TOOLCHEST_KEY is specified in .Renviron or elsewhere.
  # Notify user if this is not the case.
  config_message <- ""
  if (Sys.getenv("TOOLCHEST_KEY") == "") {
    config_message <- paste(
      "To use Toolchest, please set your given key with:",
      "",
      "  toolchest::set_key(\"YOUR_TOOLCHEST_KEY\")",
      "",
      "If you do not have a key, please contact Toolchest.",
      sep = "\n"
    )
  }
  packageStartupMessage(config_message)
}
