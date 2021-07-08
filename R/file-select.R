#' Helper function that allows user to select output path
#' if `output_file` for a tool is not specified.
#'
#' @param inputs User-specified value for `inputs` variable.
#' @return Input filepath(s).
.validate.inpath <- function(inputs) {
  if (is.null(inputs)) {
    cat("Choose file(s) to upload as input.\n")
    inputs <- file.choose()
  }
  return(inputs)
}

#' Helper function that allows user to select input path(s)
#' if `inputs` for a tool is not specified.
#'
#' @param output_path User-specified value for `output_path` variable.
#' @return Output filepath.
.validate.outpath <- function(output_path) {
  if (is.null(output_path)) {
    cat("Choose a destination for the output file.\n")
    output_path <- file.choose()
  }
}
