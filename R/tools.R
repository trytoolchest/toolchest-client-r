#' Bowtie 2 Client
#'
#' Starts a query for Bowtie 2 (for alignment) using Toolchest.
#'
#' If left unspecified, inputs and output_path can be selected by the user
#' manually.
#'
#' @param tool_args (optional) Additional arguments to be passed to Bowtie 2.
#' @param inputs Path or list of paths (client-side) to be passed in as input.
#' @param output_path Path (client-side) where the output file will be downloaded.
#' @param database_name Name (string) of database to use for Bowtie 2 alignment.
#' @param database_version Version (string) of database to use for Bowtie 2 alignment.
#'
#' @export
bowtie2 <- function(tool_args = "", inputs = NULL, output_path = NULL, database_name, database_version) {
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
#' @param tool_args Additional arguments to be passed to Cutadapt.
#' @param inputs Path or list of paths (client-side) to be passed in as input.
#' @param output_path Path (client-side) where the output file will be downloaded.
#'
#' @examples
#' \dontrun{
#' cutadapt(tool_args = "-a AATTCCGG")
#' cutadapt(input_path = "C://Users/YourName/Documents/my_input_file.fastq", tool_args = "-a AATTCCGG")
#' }
#'
#' @export
cutadapt <- function(tool_args, inputs = NULL, output_path = NULL) {
  inputs <- .validate.inpath(inputs)
  output_path <- .validate.outpath(output_path)
  toolchest_client$cutadapt(inputs, output_path, tool_args)
}

#' Kraken 2 Client
#'
#' Starts a query for Kraken 2 using Toolchest.
#'
#' If left unspecified, inputs and output_path can be selected by the user
#' manually.
#'
#' @param tool_args (optional) Additional arguments to be passed to Kraken 2.
#' @param inputs Path or list of paths (client-side) to be passed in as input.
#' @param output_path Path (client-side) where the output will be downloaded.
#'
#' @export
kraken2 <- function(tool_args = "", inputs = NULL, output_path = NULL) {
  inputs <- .validate.inpath(inputs, choose_multiple = TRUE)
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
test <- function(tool_args = "", inputs = NULL, output_path = NULL) {
  inputs <- .validate.inpath(inputs)
  output_path <- .validate.outpath(output_path)
  toolchest_client$test(inputs, output_path, tool_args)
}

#' Unicycler Client
#'
#' Runs Unicycler via Toolchest.
#'
#' @note If some but not all of `read_one`, `read_two`, or `long_reads` are
#' unspecified, Toolchest will assume that they are intended to be blank.
#' If all are left blank, the user will be prompted to provide input file(s)
#' and option(s).
#'
#' At least one input filepath is needed for Toolchest to run Unicycler.
#'
#' The output path is needed. An option will pop up to select a filepath
#' if `output_path` is unspecified.
#'
#' @param tool_args (optional) Additional arguments to be passed to Unicycler.
#' @param read_one Path of input file (FASTQ) to be passed in as Read 1 (-1).
#' @param read_two Path of input file (FASTQ) to be passed in as Read 2 (-2).
#' @param long_reads Path of input file (FASTA) to be passed in as long reads (-l).
#' @param output_path Path (client-side) where the output file will be downloaded.
#'
#' @export
unicycler <- function(tool_args = "", read_one = NULL, read_two = NULL,
                      long_reads = NULL, output_path = NULL) {
  if (is.null(read_one) && is.null(read_two) && is.null(long_reads)) {
    read_one <- .choose.path(is_optional = TRUE, file_descriptor = "read 1 (-1)")
    read_two <- .choose.path(is_optional = TRUE, file_descriptor = "read 2 (-2)")
    long_reads <- .choose.path(is_optional = TRUE, file_descriptor = "long reads (-l)")
  }
  output_path <- .validate.outpath(output_path)
  toolchest_client$unicycler(output_path, read_one, read_two, long_reads, tool_args)
}
