#' Kraken 2 Client
#'
#' Starts a query for Kraken 2 using Toolchest.
#'
#' If left unspecified, input_path and output_path can be selected by the user
#' manually while running the kraken2() function.
#'
#' @param kraken2_args Custom arguments given to function.
#' @param input_path Local path of input file (to be uploaded to AWS).
#' @param output_path Local path of output file (to be downloaded from AWS).
#' @param input_name Name of input file inside input AWS S3 bucket.
#' @param output_name Name of output file to be uploaded to output AWS S3 bucket.
#'
#'
#' @export
kraken2 <- function(kraken2_args = "", input_path = NULL, output_path = NULL,
                     input_name = "input.fastq", output_name = "output.fastq") {
  toolchest::query("kraken", "2.1.1", kraken2_args, input_path, output_path, input_name, output_name)
}
