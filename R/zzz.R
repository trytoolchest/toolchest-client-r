.onLoad <- function(libname, pkgname) {
  startup_message <- paste("Toolchest client loaded.")
  packageStartupMessage(startup_message)
  toolchest::install_toolchest()
}
