#' Download
#'
#' Downloads the output of a previously run job.
#'
#' One of `s3_uri` or `pipeline_segment_instance_id` must be provided.
#'
#' @param output_path Output path to which the file(s) will be downloaded.
#' This should be a directory that already exists, but direct filenames
#' are also supported.
#' @param s3_uri URI of file contained in S3. This can be passed from
#' the parameter `output$s3_uri` from the `output` returned by a previous
#' job.
#' @param pipeline_segment_instance_id Pipeline segment instance ID of the job
#' producing the output you would like to download.
#' @param skip_decompression Whether to skip decompression of the downloaded file archive.
#'
#' @export
download <- function(output_path, s3_uri = NULL, pipeline_segment_instance_id = NULL,
                     skip_decompression = NULL) {
  output_path <- .validate.outpath(output_path)
  toolchest_args <- list(
    output_path = output_path,
    s3_uri = s3_uri,
    pipeline_segment_instance_id = pipeline_segment_instance_id,
    skip_decompression = skip_decompression,
  )
  .do.toolchest.call(toolchest_client$download, toolchest_args)
}
