#' Get a mission dataframe
#'
#' This function queries the andes database and returns a dataframe containing the mission data.
#' TODO: The mission filter is not yet implemented everywhere, but should be added in the future. It currently uses the active mission
#'
#' @param andes_db_connection A connection object to the ANDES database.
#' @return a dataframe containing andes catch rows
#' @seealso [andes_db_connect()] for getting a connection object to the ANDES database.
#' @family {Andesdb query functions}
#' @export
get_andes_mission <- function(andes_db_connection) {
  sql_query <- "
    SELECT * FROM shared_models_mission
    WHERE is_active = 1"
  result <- DBI::dbSendQuery(andes_db_connection, sql_query)
  df <- DBI::dbFetch(result, n = Inf)
  DBI::dbClearResult(result)
  return(df)
}
