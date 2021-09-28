.onLoad <- function(libname, pkgname) {
  startup_message <- paste(
    "Toolchest client loaded.",
    "To install the Toolchest client, run:",
    "",
    "  toolchest::install_toolchest()",
    "",
    sep = "\n"
  )
  packageStartupMessage(startup_message)
}
