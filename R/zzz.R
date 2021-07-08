#' Installs and loads the `toolchest_client` Python package when loading
#' the R package.
.onLoad <- function(libname, pkgname) {
  packageStartupMessage("Installing Toolchest client... ")

  reticulate::py_install("toolchest_client", method = "auto", pip = TRUE)
  toolchest_client <<- reticulate::import("toolchest_client", delay_load = TRUE)

  packageStartupMessage("The Toolchest client has been installed!")
  config_message <- paste(
    "To use Toolchest, please set your given key with:",
    "",
    "  toolchest::set_key(\"YOUR_TOOLCHEST_KEY\")",
    "",
    "If you do not have a key, please contact Toolchest.",
    sep = "\n"
  )
  packageStartupMessage(config_message)
}
