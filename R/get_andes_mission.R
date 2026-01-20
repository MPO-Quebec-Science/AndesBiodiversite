
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
