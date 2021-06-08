#' Toolchest Client Query
#'
#' Starts a generic query using Toolchest.
#'
#' (For a specific tool, call toolchest::toolname() instead. This function
#' is used for processing queries and should not be called by the user itself.)
#'
#' @param tool_name Toolchest tool name to use (e.g., cutadapt).
#' @param tool_version Toolchest tool version.
#' @param tool_args Custom arguments given to function.
#' @param input_path Local path of input file (to be uploaded to AWS).
#' @param output_path Local path of output file (downloaded from AWS).
#' @param input_name Name of input file inside input AWS S3 bucket.
#' @param output_name Name of output file to be uploaded to output AWS S3 bucket.
#' @export
query <- function(tool_name, tool_version, tool_args, input_path, output_path,
                  input_name, output_name) {
  # Confirm authentication
  key <- Sys.getenv("TOOLCHEST_KEY")
  if (identical(key, "")) {
    stop(
      "Please set env var TOOLCHEST_KEY to your specified Toolchest authentication key.",
      call. = FALSE
    )
  }

  base_url <- "http://toolchest.us-east-1.elasticbeanstalk.com"
  pipeline_url <- "/pipeline-segment-instances"
  headers <- httr::add_headers(Authorization = paste("Key", key))

  # Get info from initial POST response
  tryCatch(
    {
      token <- get_token(tool_name, tool_version, tool_args, input_name,
                         output_name, base_url, pipeline_url, headers)
    },
    error = function(cnd) {
      stop(cnd$message, call. = FALSE)
    }
  )

  # Upload with PUT request
  tryCatch(
    {
      upload(input_path, token)
    },
    error = function(cnd) {
      error_message <- paste("Upload error:", cnd$message)
      stop(error_message, call. = FALSE)
    }
  )

  # Wait for job to execute
  cat("Executing job...\n")
  wait_for_job(token)
  cat("Job complete!\n")

  # Download with GET
  tryCatch(
    {
      download(output_path, token)
    },
    error = function(cnd) {
      error_message <- paste("Download error:", cnd$message)
      stop(error_message, call. = FALSE)
    }
  )
}

get_token <- function(tool_name, tool_version, tool_args, input_name,
                      output_name, base_url, pipeline_url, headers) {
  api_url <- paste(base_url, pipeline_url, sep = "")
  create_body <- list(
    tool_name = tool_name,
    tool_version = tool_version,
    database_name = NULL,
    database_version = NULL,
    input_file_name = input_name,
    output_file_name = output_name
  )

  create_response <- httr::POST(
    url = api_url,
    config = headers,
    body = create_body,
    encode = "json"
  )
  create_status <- httr::status_code(create_response)
  if (create_status != 201) {
    stop(
      paste("Initial query failed. Status code", create_status),
      call. = FALSE
    )
  }

  create_content <- httr::content(create_response, "parsed", encoding = "UTF-8")
  customer_id <- create_content$id
  status_url <- paste(api_url, customer_id, "status", sep = "/")
  token <- list(
    base_url = base_url,
    pipeline_url = pipeline_url,
    headers = headers,
    api_url = api_url,
    customer_id = customer_id,
    status_url = status_url,
    input_url = create_content$input_file_upload_location
  )
  message(customer_id)
  return(token)
}

# Upload input file to the AWS URL.
upload <- function(input_path = NULL, token) {
  if (is.null(input_path)) {
    cat("Choose a file to upload as input.\n")
    input_path <- file.choose()
  } else {
    if (!file.exists(input_path)) {
      stop("Input file does not exist.", call. = FALSE)
    }
  }
  message(input_path)

  update_status("transferring_from_client", token)

  cat("Uploading (this may take a few moments)...\n")
  upload_response <- httr::PUT(
    url = token$input_url,
    body = httr::upload_file(input_path, type = ""),
    httr::progress(type = "up", con = stdout())
  )
  upload_status <- httr::status_code(upload_response)
  if (upload_status != 200) {
    stop(
      paste("Input upload failed. Status code", toString(upload_status)),
      call. = FALSE
    )
  }
  # get_job_status(token)

  update_status("transferred_from_client", token)

  cat("Uploaded!\n")
}

update_status <- function(new_status, token) {
  response <- httr::PUT(
    url = token$status_url,
    config = token$headers,
    body = list(status = new_status),
    encode = "json"
  )
  if (httr::status_code(response) != 200) {
    response_content <- httr::content(response, "parsed", encoding = "UTF-8")

    # Check if there are specific errors (e.g., data limits).
    if ("success" %in% names(response_content)) {
      if (!response_content$success) {
        stop(response_content$error, call. = FALSE)
      }
    }

    stop(paste("Unsuccessful task status update."), call. = FALSE)
  }
}

# Wait for job to run after uploading.
wait_for_job <- function(token) {
  status <- get_job_status(token)
  while (status != "ready_to_transfer_to_client") {
    Sys.sleep(15)
    status <- get_job_status(token)
  }
}

get_job_status <- function(token) {
  job_response <- httr::GET(
    url = token$status_url,
    config = token$headers
  )
  if (httr::status_code(job_response) != 200) {
    return(toString(httr::status_code(job_response)))
  }

  job_response_content <- httr::content(job_response, "parsed", encoding = "UTF-8")
  job_status <- job_response_content$status
  message(job_status)
  return(job_status)
}

# Download output file from AWS once job is complete.
download <- function(output_path = NULL, token) {
  tryCatch(
    {
      signed_url <- get_signed_url(token)
    },
    error = function(cnd) {
      stop(cnd$message)
    }
  )

  if (is.null(output_path)) {
    cat("Choose a destination for the output file.\n")
    output_path <- file.choose()
  }
  message(output_path)

  update_status("transferring_to_client", token)

  cat("Downloading (this may take a few moments)...\n")
  download_response <- httr::GET(
    url = signed_url,
    httr::write_disk(output_path, overwrite = TRUE),
    httr::progress(type = "down", con = stdout())
  )
  download_status <- httr::status_code(download_response)
  if (download_status != 200) {
    stop(
      paste("Output download failed. Status code", toString(download_status)),
      call. = FALSE
    )
  }

  update_status("transferred_to_client", token)

  cat("Downloaded!\n")
}

get_signed_url <- function(token) {
  download_url <- paste(token$api_url, token$customer_id, "downloads", sep = "/")
  download_response <- httr::GET(
    url = download_url,
    config = token$headers,
    encode = "json"
  )
  download_status <- httr::status_code(download_response)
  if (download_status != 200) {
    stop(
      paste("Download API Error. Status code", toString(download_status)),
      call. = FALSE
    )
  }
  download_content <- httr::content(download_response, "parsed", encoding = "UTF-8")
  return(download_content[[1]]$signed_url)
}
