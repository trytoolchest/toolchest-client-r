#' Add Database
#'
#' Adds a custom database and attaches it to a tool.
#' The new database version is returned immediately after initialization.
#'
#' This executes just like any other tool, except:
#' - the success status is `complete` instead of `ready_to_transfer_to_client`
#' - `is_async` is True by default
#'
#' Note that it may take 24-48 hours for the custom database to be ready for use.
#'
#' @param database_path Path or list of paths (local or S3) to be passed in as inputs.
#' @param tool Toolchest tool with which you use the database (e.g. `toolchest$tools$Kraken2``).
#' @param database_name Name of the new database.
#'
#' @export
add_database <- function(database_path, tool, database_name, ...) {
  toolchest_args <- c(
    list(
      database_path = database_path,
      tool = tool,
      database_name = database_name
    ),
    list(...)
  )
  output <- .do.toolchest.call(toolchest_client$add_database, toolchest_args)
  return(output)
}

#' Update Database
#'
#' Updates a custom database. The new database version is returned immediately after initialization.
#'
#' This executes just like any other tool, except:
#' - the success status is `complete` instead of `ready_to_transfer_to_client`
#' - `is_async` is True by default
#'
#' Note that it may take 24-48 hours for the custom database to be ready for use.
#'
#' @param database_path Path or list of paths (local or S3) to be passed in as inputs.
#' @param tool Toolchest tool with which you use the database (e.g. `toolchest$tools$Kraken2``).
#' @param database_name Name of the new database.
#'
#' @export
update_database <- function(database_path, tool, database_name, ...) {
  toolchest_args <- c(
    list(
      database_path = database_path,
      tool = tool,
      database_name = database_name
    ),
    list(...)
  )
  output <- .do.toolchest.call(toolchest_client$update_database, toolchest_args)
  return(output)
}
