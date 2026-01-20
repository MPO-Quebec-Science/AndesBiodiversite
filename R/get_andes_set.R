
#' @export
get_andes_set <- function(andes_db_connection, mission_id) {
    sql_query <- readr::read_file(system.file("sql_queries",
                                          "obis_andes_set.sql",
                                          package = "AndesBiodiversite"))
    # add mission_id filter
    # if (! is.null(mission_id)) {
    #     sql_query <- gsub("input_mission_id", mission_id, sql_query)
    #     sql_query <- paste(sql_query, sprintf("WHERE mission_id = %d", mission_id))
    # }

    result <- DBI::dbSendQuery(andes_db_connection, sql_query)
    df <- DBI::dbFetch(result, n = Inf)
    DBI::dbClearResult(result)
    return(df)
}
