#' Retrieves the Toolchest key, if it is set.
#'
#' @return Value of key.
#' @export
get_key <- function() {
  return(toolchest_client$get_key())
}

#' Sets the value for the Toolchest key.
#'
#' @param key Value of key, or filenpath to a file containing key value.
#' @export
set_key <- function(key) {
  toolchest_client$set_key(key)
}
