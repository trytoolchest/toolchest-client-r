#' Bowtie 2 Client
#'
#' Starts a query for Bowtie 2 (for alignment) using Toolchest.
#'
#' If left unspecified, inputs and output_path can be selected by the user
#' manually.
#'
#' @param inputs Path or list of paths (client-side) to be passed in as input.
#' @param output_path Path (client-side) where the output file will be downloaded.
#' @param database_name Name (string) of database to use for Bowtie 2 alignment.
#' @param database_version Version (string) of database to use for Bowtie 2 alignment.
#' @param tool_args (optional) Additional arguments to be passed to Bowtie 2.
#'
#' @export
bowtie2 <- function(inputs = NULL, output_path = NULL, database_name, database_version, tool_args = "") {
  inputs <- .validate.inpath(inputs)
  output_path <- .validate.outpath(output_path)
  toolchest_client$bowtie2(inputs, output_path, database_name, database_version, tool_args)
}

#' Cutadapt Client
#'
#' Starts a query for Cutadapt using Toolchest.
#'
#' Currently, only a single .fastq file is supported as input.
#' The output will be downloaded to output_path if specified.
#'
#' If left unspecified, inputs and output_path can be selected by the user
#' manually.
#'
#' @param inputs Path or list of paths (client-side) to be passed in as input.
#' @param output_path Path (client-side) where the output file will be downloaded.
#' @param tool_args Additional arguments to be passed to Cutadapt.
#'
#' @examples
#' \dontrun{
#' cutadapt(tool_args = "-a AATTCCGG")
#' cutadapt(input_path = "C://Users/YourName/Documents/my_input_file.fastq", tool_args = "-a AATTCCGG")
#' }
#'
#' @export
cutadapt <- function(inputs = NULL, output_path = NULL, tool_args) {
  inputs <- .validate.inpath(inputs)
  output_path <- .validate.outpath(output_path)
  toolchest_client$cutadapt(inputs, output_path, tool_args)
}

#' Kraken 2 Client
#'
#' Starts a query for Kraken 2 using Toolchest.
#'
#' (Currently, only single .fastq inputs are supported.)
#'
#' If left unspecified, inputs and output_path can be selected by the user
#' manually.
#'
#' @param inputs Path or list of paths (client-side) to be passed in as input.
#' @param output_path Path (client-side) where the output will be downloaded.
#' @param tool_args (optional) Additional arguments to be passed to Kraken 2.
#'
#' @export
kraken2 <- function(inputs = NULL, output_path = NULL, tool_args = "") {
  inputs <- .validate.inpath(inputs)
  output_path <- .validate.outpath(output_path)
  toolchest_client$kraken2(inputs, output_path, tool_args)
}

#' Test Pipeline Segment
#'
#' Run a test pipeline segment via Toolchest. A plain text file containing 'success' is returned."
#'
#' @param tool_args Additional arguments, present to maintain a consistent interface. This is disregarded.
#' @param inputs Path or list of paths (client-side) to be passed in as input.
#' @param output_path Path (client-side) where the output file will be downloaded.
#'
#' @export
test <- function(inputs = NULL, output_path = NULL, tool_args = "") {
  inputs <- .validate.inpath(inputs)
  output_path <- .validate.outpath(output_path)
  toolchest_client$test(inputs, output_path, tool_args)
}
