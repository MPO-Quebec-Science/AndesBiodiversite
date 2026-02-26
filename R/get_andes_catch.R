#' Get a catch dataframe
#'
#' This function queries the andes database and returns a dataframe containing the catch data.
#' TODO: The mission filter is not yet implemented everywhere, but should be added in the future. It currently uses the active mission
#'
#' @param andes_db_connection A connection object to the ANDES database.
#' @param mission_id A string or integer representing the mission ID to filter the catches (default is NULL, which retrieves all catches).
#'
#' @return a dataframe containing andes catch rows
#' @seealso [andes_db_connect()] for getting a connection object to the ANDES database.
#' @family {Andesdb query functions}
#' @export
get_andes_catch <- function(andes_db_connection, mission_id = NULL) {
  sql_query <- readr::read_file(system.file(
    "sql_queries",
    "obis_andes_catch.sql",
    package = "AndesBiodiversite"
  ))
  # add mission_id filter
  # if (! is.null(mission_id)) {
  #     sql_query <- gsub("input_mission_id", mission_id, sql_query)
  #     sql_query <- paste(sql_query, sprintf("WHERE mission_id = %d", mission_id))
  # }

  result <- DBI::dbSendQuery(andes_db_connection, sql_query)
  df <- DBI::dbFetch(result, n = Inf)
  DBI::dbClearResult(result)

  # remove mixed catch?
  # AND shared_models_referencecatch.is_mixed_catch=0

  return(df)
}
