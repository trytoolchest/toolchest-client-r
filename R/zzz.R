#' Installs and loads the `toolchest_client` Python package when loading
#' the R package.
#'
#' Note: The Python package interface is stored in the global variable `toolchest_client`.
#'
#'
.onLoad <- function(libname, pkgname) {
  packageStartupMessage("Installing Toolchest client... ")

  # check python configuration
  packageStartupMessage("Checking Python configuration...")
  python_path <- NULL
  if (reticulate::virtualenv_exists("r-reticulate")) {
    reticulate_python_path <- reticulate::virtualenv_python("r-reticulate")
    # Rebuild r-reticulate environment if built on an incompatible Python version.
    if (!python_is_compatible(reticulate_python_path)) {
      packageStartupMessage("Env r-reticulate has an incompatible Python version. Searching for compatible Python...")
      python_path <- find_compatible_python()
      packageStartupMessage("Compatible Python found. Env r-reticulate must be rebuilt.")
      choice <- utils::askYesNo("Would you like to continue the install? This will overwrite the r-reticulate environment.", default = FALSE)
      if (is.null(choice) || !choice) {
        stop("Toolchest install halted.", call. = FALSE)
      }
      reticulate::virtualenv_remove("r-reticulate", confirm = FALSE)
    }
  } else {
    python_path <- find_compatible_python()
  }

  packageStartupMessage("Configuring reticulate...")
  configure_virtualenv("r-reticulate", python_path)

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

python_is_compatible <- function(python_path) {
  MIN_PYTHON_VERSION = "3.6"

  Sys.setenv(RETICULATE_PYTHON = python_path)
  python_info <- reticulate::py_discover_config()
  Sys.unsetenv("RETICULATE_PYTHON")

  if (!is.null(python_info$libpython) &&
      utils::compareVersion(python_info$version, MIN_PYTHON_VERSION) >= 0) {
    return(TRUE)
  }
  return(FALSE)
}

find_compatible_python <- function() {
  python_path <- NULL
  config_info <- reticulate::py_discover_config()
  for (found_python in config_info$python_versions) {
    if (python_is_compatible(found_python)) {
      python_path <- found_python
      break
    }
  }

  if (is.null(python_path)) {
    packageStartupMessage("No compatible version of Python (>=3.6, libpython libraries) found.")

    # if on MacOS, suggest installing python3 via homebrew
    sysname <- Sys.info()[["sysname"]]
    if (sysname == "Darwin") {
      suggestion_message <- paste(
        "MacOS detected. Try installing Python3 via Homebrew (https://brew.sh/):",
        "",
        "  brew install python",
        "",
        "If Homebrew + Python are installed and problems persist, try reinstalling:",
        "",
        "  brew reinstall python",
        "",
        "After installation, make sure that Homebrew is on your $PATH.",
        "Note that Python 3.6 or greater is required for Toolchest.",
        sep = "\n"
      )
      packageStartupMessage(suggestion_message)
    }

    stop("No compatible version of Python (>=3.6, libpython libraries) found.", call. = FALSE)
  }

  return(python_path)
}

configure_virtualenv <- function(env_name, python_path) {
  SETUPTOOLS_VERSION = "58.0.0"

  # Create environment if it doesn't exist.
  if (!reticulate::virtualenv_exists(env_name)) {
    packageStartupMessage("Creating Python virtual environment...")
    reticulate::virtualenv_create(env_name, python = python_path, setuptools_version = "58.0.0")
  }

  # Check the version of setuptools. Reinstall if needed.
  version_check <- reticulate::py_run_string("reset_setuptools = False
try:
  from distutils.version import LooseVersion
  import setuptools

  setuptools_version = setuptools.__version__
  reset_setuptools = (LooseVersion(setuptools_version) >= LooseVersion('58.0.2'))
except ModuleNotFoundError:
  pass
")
  if (version_check$reset_setuptools) {
    packageStartupMessage("Incompatible version of setuptools detected. Reinstalling setuptools...")
    reticulate::virtualenv_remove(env_name, "setuptools", confirm = FALSE)
    reticulate::virtualenv_install(env_name, sprintf("setuptools==%s", SETUPTOOLS_VERSION))
  }
}
