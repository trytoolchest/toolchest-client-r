#' Toolchest Installation
#'
#' Installs and loads the `toolchest_client` Python package.
#'
#' @note The Python package interface is stored in the global variable `toolchest_client`.
#'
#' @export
install_toolchest <- function() {
  packageStartupMessage("Installing Toolchest client... ")

  packageStartupMessage("Configuring reticulate...")
  tryCatch(
    # Try a miniconda-based install.
    toolchest_client <- install_with_conda(),
    error = function(cnd) {
      packageStartupMessage("Miniconda installation failed. Attempting with base Python:")
      toolchest_client <- install_with_virtualenv()
    }
  )

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

  # Returns the client object, in case the user would like to invoke it
  # directly with `toolchest_client$function_name()`.
  invisible(toolchest_client)
}

install_with_conda <- function() {
  # Install or update miniconda
  # (Reticulate defaults to Python 3.8 with miniconda)
  packageStartupMessage("Updating conda configuration...")
  miniconda_is_installed <- try(reticulate::install_miniconda(), silent = TRUE)
  if(!("r-reticulate" %in% reticulate::conda_list()$name)) {
    reticulate::conda_create("r-reticulate")
  }

  # Point reticulate to miniconda
  reticulate::use_miniconda("r-reticulate")

  # If python is out-of-date in miniconda, force reinstall
  if (!python_is_compatible()) {
    reticulate::conda_remove("r-reticulate")
    reticulate::install_miniconda(force = TRUE)
    reticulate::conda_create("r-reticulate")
  }

  # Install Toolchest client.
  packageStartupMessage("Installing Toolchest into environment...")
  reticulate::conda_install(
    envname = "r-reticulate",
    packages = "toolchest_client",
    pip = TRUE,
    pip_ignore_installed = TRUE
  )
  toolchest_client <<- reticulate::import("toolchest_client", delay_load = TRUE)
  return(toolchest_client)
}

install_with_virtualenv <- function() {
  # TODO: deprecate assigning a default version with reticulate 1.25
  PYTHON_VERSION <- "3.8.7"

  # (Reticulate 1.25+ defaults to latest version of Python, or at least 3.8)
  packageStartupMessage("Installing custom Python...")
  python_path <- reticulate::install_python(version = PYTHON_VERSION)

  packageStartupMessage("Creating custom environment...")
  reticulate::virtualenv_create(envname = "r-reticulate", python = python_path)

  # Point reticulate to virtualenv
  reticulate::use_virtualenv(virtualenv = "r-reticulate")

  # If python is out-of-date in virtualenv, force reinstall
  if (!python_is_compatible()) {
    reticulate::virtualenv_remove(envname = "r-reticulate", confirm = FALSE)
    reticulate::virtualenv_create(envname = "r-reticulate", python = python_path)
  }

  # Install Toolchest client.
  packageStartupMessage("Installing Toolchest into environment...")
  reticulate::virtualenv_install(
    envname = "r-reticulate",
    packages = "toolchest_client",
    ignore_installed = TRUE
  )
  toolchest_client <<- reticulate::import("toolchest_client", delay_load = TRUE)
  return(toolchest_client)
}

python_is_compatible <- function(python_path) {
  MIN_PYTHON_VERSION <- "3.6"

  path_is_python <- try(python_info <- reticulate::py_discover_config(), silent = TRUE)
  if (class(path_is_python) == "try-error") {
    return(FALSE)
  }

  if (utils::compareVersion(python_info$version, MIN_PYTHON_VERSION) >= 0) {
    return(TRUE)
  }
  return(FALSE)
}
