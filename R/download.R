#' Download Functionality
#'
#' If output download is skipped or halted unexpectedly during any Toolchest job,
#' the output file(s) can be downloaded manually via the following functions:
#' \itemize{
#' \item{`toolchest::download(output_path, ...)`}{As a base function}
#' \item{`output$download(output_path)`}{From the `output` returned by any
#' Toolchest job, invoking `download` as a function
#' }
#' }
#'
#' @details If `toolchest::download()` is used, one of `s3_uri` or
#' `run_id` must be provided. These can be found as variables of the
#' output object returned from a previous Toolchest function call.
#' Contact Toolchest for assistance if the output details cannot
#' be recovered.
#'
#' If `output$download()` is used from the `output` returned by any
#' `toolchest::tool()` function call, then only `output_path` needs to be specified.
#'
#' @param output_path Path to a local directory where the file(s) will be downloaded.
#' @param s3_uri URI of file contained in S3. This can be passed from
#' the parameter `output$s3_uri` from the `output` returned by a previous
#' job.
#' @param run_id Run ID of the job producing the output you would like to download.
#' @param skip_decompression Whether to skip decompression of the downloaded file archive.
#' @return Path(s) to downloaded and decompressed files. If `skip_decompression` is enabled,
#' returns the path to the archive.
#'
#'
#' @examples
#' \dontrun{
#' output <- toolchest::test(...)
#' output$download(output_path = path)
#'
#' output <- toolchest::test(...)
#' toolchest::download(output_path = path, s3_uri = output$s3_uri)
#' }
#'
#' @export
download <- function(output_path, s3_uri = NULL, run_id = NULL,
                     pipeline_segment_instance_id = NULL, skip_decompression = FALSE) {
  if (!is.null(pipeline_segment_instance_id)) {
    lifecycle::deprecate_warn("0.7.12", "download(pipeline_segment_instance_id)", "download(run_id)")
    if (is.null(run_id)) {
      run_id <- pipeline_segment_instance_id
    }
  }
  toolchest_args <- list(
    output_path = output_path,
    s3_uri = s3_uri,
    run_id = run_id,
    skip_decompression = skip_decompression
  )
  output <- .do.toolchest.call(toolchest_client$download, toolchest_args)
  return(output)
}
