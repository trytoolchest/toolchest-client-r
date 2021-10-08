.onLoad <- function(libname, pkgname) {
  startup_message <- paste("Toolchest client loaded.")
  packageStartupMessage(startup_message)

  # Install Toolchest Python package on package load.
  install_toolchest()
}
