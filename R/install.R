#' Installs and loads the `toolchest_client` Python package.
#'
#' @note The Python package interface is stored in the global variable `toolchest_client`.
#'
#' @export
install_toolchest <- function() {
  packageStartupMessage("Installing Toolchest client... ")

  # Disable the prompt to install with conda, which is not compatible
  # on Mac/Linux due to the pysam install.
  Sys.setenv(RETICULATE_MINICONDA_ENABLED = FALSE)

  # check python configuration
  packageStartupMessage("Checking Python configuration...")
  python_path <- NULL
  if (reticulate::virtualenv_exists("r-reticulate")) {
    python_path <- reticulate::virtualenv_python("r-reticulate")
    # Rebuild r-reticulate environment if built on an incompatible Python version.
    if (!python_is_compatible(python_path)) {
      packageStartupMessage("Env r-reticulate has an incompatible Python version. Searching for compatible Python...")
      python_path <- find_compatible_python() # throws error if not found
      packageStartupMessage("Compatible Python found. Env r-reticulate must be rebuilt.")
      choice <- utils::askYesNo("Would you like to continue the install? This will overwrite the r-reticulate environment.", default = FALSE)
      if (is.null(choice) || !choice) {
        stop("Toolchest install cancelled.", call. = FALSE)
      }
      reticulate::virtualenv_remove("r-reticulate", confirm = FALSE)
    }
  } else {
    python_path <- find_compatible_python()
  }

  packageStartupMessage("Configuring reticulate...")
  configure_virtualenv("r-reticulate", python_path)

  packageStartupMessage("Installing Toolchest into environment...")
  reticulate::virtualenv_install(
    envname = "r-reticulate",
    packages = "toolchest_client",
    ignore_installed = TRUE
  )
  toolchest_client <<- reticulate::import("toolchest_client")

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

python_is_compatible <- function(python_path) {
  MIN_PYTHON_VERSION <- "3.6"

  Sys.setenv(RETICULATE_PYTHON = python_path)
  python_info <- reticulate::py_discover_config()
  Sys.unsetenv("RETICULATE_PYTHON")

  if (!is.null(python_info$libpython) &&
      utils::compareVersion(python_info$version, MIN_PYTHON_VERSION) >= 0) {
    return(TRUE)
  }
  return(FALSE)
}

python_versions_in_path <- function() {
  python_regex <- "python(3|3.\\d)?$"
  if (Sys.info()[["sysname"]] == "Windows") {
    python_regex <- "python(3|3.\\d)?.exe$"
  }

  found_versions <- NULL
  path_options <- strsplit(Sys.getenv("PATH"), split = ":")
  for (path in path_options) {
    path_versions <- list.files(
      path = path,
      pattern = python_regex,
      full.names = TRUE
    )
    found_versions <- c(found_versions, path_versions)
  }

  return(found_versions)
}

find_compatible_python <- function() {
  # Version to be installed on Windows if no compatible python found.
  PYTHON_VERSION_TO_BE_INSTALLED <- "3.8"

  python_path <- NULL

  # If RETICULATE_PYTHON is set, check that Python first.
  preset_python <- Sys.getenv("RETICULATE_PYTHON")
  if (preset_python != "") {
    if (python_is_compatible(preset_python)) {
      Sys.setenv(RETICULATE_PYTHON = preset_python)
      return(preset_python)
    }
    # if python isn't compatible, RETICULATE_PYTHON is unset
  }

  # List all versions of Python found, from py_discover_config().
  # If on Mac/Linux, also search along $PATH since reticulate doesn't auto-search.
  sysname <- Sys.info()[["sysname"]]
  config_info <- reticulate::py_discover_config()
  all_versions <- config_info$python_versions
  if (sysname == "Darwin" || sysname == "Linux") {
    all_versions <- c(all_versions, python_versions_in_path())
  }

  for (found_python in all_versions) {
    if (python_is_compatible(found_python)) {
      python_path <- found_python
      break
    }
  }

  # If no compatible Python found, try some backup options and/or display a
  # custom error message depending on OS.
  if (is.null(python_path)) {
    packageStartupMessage("No compatible version of Python (>=3.6) with development libraries found.")

    # if on MacOS, suggest installing python3 via homebrew
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
    } else if (sysname == "Windows") {
      # If on Windows, attempt to install Miniconda if not installed.
      conda_try <- try(reticulate::conda_list(), silent = TRUE)
      if (class(conda_try) == "try-error") {
        packageStartupMessage("No install of Anaconda detected. Installing Miniconda.")
        reticulate::conda_install(
          "r-miniconda",
          python_version = PYTHON_VERSION_TO_BE_INSTALLED
        )
        return(reticulate::conda_python("r-miniconda"))
      }
    }

    stop("No compatible version of Python (>=3.6) with development libraries found.", call. = FALSE)
  }

  return(python_path)
}

configure_virtualenv <- function(env_name, python_path) {
  SETUPTOOLS_VERSION <- "58.0.0"

  # Create environment if it doesn't exist.
  if (!reticulate::virtualenv_exists(env_name)) {
    # Enforce RETICULATE_PYTHON to be the version passed into the function.
    # This prevents reticulate's miniconda from overriding it, if present.
    Sys.setenv(RETICULATE_PYTHON = python_path)

    packageStartupMessage("Creating Python virtual environment...")
    reticulate::virtualenv_create(
      envname = env_name,
      python = python_path,
      module = "virtualenv",
      setuptools_version = SETUPTOOLS_VERSION
    )
  }

  # Enforce RETICULATE_PYTHON to be the version in the r-reticulate env,
  # in order to make any changes to setuptools affect the env python
  # instead of the version on python_path, if it is different.
  env_python <- reticulate::virtualenv_python("r-reticulate")
  Sys.setenv(RETICULATE_PYTHON = env_python)

  # Reload reticulate in case the python version changes.
  # TODO: add a proper reload here, or at least an error msg if install fails

  # Check the version of setuptools. Reinstall if needed.
  version_check <- reticulate::py_run_file(system.file("python", "check_setuptools.py", package = "toolchest"))

  if (version_check$reset_setuptools) {
    packageStartupMessage("Incompatible version of setuptools detected. Reinstalling setuptools...")
    reticulate::virtualenv_remove(env_name, "setuptools", confirm = FALSE)
    reticulate::virtualenv_install(env_name, sprintf("setuptools==%s", SETUPTOOLS_VERSION))
  }
}
