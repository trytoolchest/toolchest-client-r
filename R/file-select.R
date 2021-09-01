#' Helper function that allows user to select input path(s) for a generic tool
#' if `inputs` is not specified.
#'
#' @param inputs User-specified value for `inputs` variable.
#' @param choose_multiple Whether the prompt should be repeated to select multiple files.
#' @return Input filepath(s).
.validate.inpath <- function(inputs, choose_multiple = FALSE) {
  if (is.null(inputs)) {
    inputs <- .choose.path()
    if (choose_multiple) {
      choose_another <- TRUE
      while (choose_another) {
        new_file_path <- .choose.path(is_optional = TRUE, file_descriptor = "an additional input file")
        if (is.null(new_file_path)) {
          choose_another <- FALSE
        } else {
          inputs <- c(inputs, new_file_path)
        }
      }
    }
  }
  return(inputs)
}

#' Helper function that allows user to select output path
#' if `output_file` for a tool is not specified.
#'
#' @param output_path User-specified value for `output_path` variable.
#' @return Output filepath.
.validate.outpath <- function(output_path) {
  if (is.null(output_path)) {
    cat("Choose a destination for the output file.\n")
    output_path <- file.choose()
  }
  return(output_path)
}

#' Helper function that allows user to select a single input file path.
#'
#' To be used directly in place of `.validate.inputs()` for customization
#' when a certain kind of input file (e.g., long reads) is being requested.
#'
#' @param is_optional Whether choosing a file is optional.
#' @param file_descriptor A description of the file, to be printed when prompting the user.
#' @return A file path.
.choose.path <- function(is_optional = FALSE,
                         file_descriptor = "input") {
  if (is_optional) {
    optional_prompt <- sprintf("Would you like to choose %s?\n", file_descriptor)
    choose_another <- utils::askYesNo(optional_prompt, default = FALSE)
    if (is.na(choose_another) || !choose_another) {
      return(NULL)
    }
  }
  cat(sprintf("Choose a file to use as %s.\n", file_descriptor))
  return(file.choose())
}
