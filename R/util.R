#' Helper function that sanitizes args by removing blank args (to be handled by
#' the Python client) and executing the corresponding Python client call.
#'
#' @param tool Tool to be used (python function, from reticulate-based python module).
#' @param args List containing keyword arguments to be passed in to tool.
.do.toolchest.call <- function(tool, args) {
  args <- args[!sapply(args, is.null)]
  output <- do.call(tool, args)
  return(output)
}
