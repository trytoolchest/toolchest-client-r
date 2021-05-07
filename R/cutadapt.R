#' Cutadapt Client
#'
#' Starts a query for Cutadapt using Toolchest.
#'
#' Currently, only a single .fastq file is supported as input.
#' The output will be downloaded to output_path if specified.
#'
#' If left unspecified, input_path and output_path can be selected by the user
#' manually while running the cutadapt() function.
#'
#' @param cutadapt_args Custom arguments given to function (e.g., adapters: "-a AATTCCGG").
#' @param input_path Local path of input file (to be uploaded to AWS).
#' @param output_path Local path of output file (to be downloaded from AWS).
#' @param input_name Name of input file inside input AWS S3 bucket.
#' @param output_name Name of output file to be uploaded to output AWS S3 bucket.
#'
#' @examples
#' \dontrun{
#' cutadapt("-a AATTCCGG")
#' cutadapt("-a AATTCCGG", input_path = "C://Users/YourName/Documents/my_input_file.fastq")
#' }
#'
#' @export
cutadapt <- function(cutadapt_args, input_path = NULL, output_path = NULL,
                     input_name = "input.fastq", output_name = "output.fastq") {
  toolchest::query("cutadapt", "1.0", cutadapt_args, input_path, output_path, input_name, output_name)
}
