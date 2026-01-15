
get_biodiv_data_db <- function(andes_db_connection) {

    # query <- readr::read_file(system.file("sql_queries",
    #                                       "biodiv_data.sql",
    #                                       package = "ANDESBiodiv"))
    query <- readr::read_file("inst/sql_queries/biodiv_data.sql")

    # add mission filter
    # use the active misison, one day you can choose a different mission,
    # query <- paste(query, "WHERE shared_models_mission.is_active=1")

    result <- DBI::dbSendQuery(andes_db_connection, query)
    df <- DBI::dbFetch(result, n = Inf)
    DBI::dbClearResult(result)
    return(df)
}


get_biodiv_data <- function(andes_db_connection) {

    biodiv_data <- get_biodiv_data_db(andes_db_connection)

    # there are catches that are for the commercial survey,
    # normally they can be weeded out by filtering using the basket class
    # BUT! there aren't always baskets for cases that have relative abundances

    # has_abundance_category <- !is.na(biodiv_data$relative_abundance)
    # has_biodiv_basket <- biodiv_data$class == 9
    # to_keep <- has_biodiv_basket | has_abundance_category

    # biodiv_data <- biodiv_data[to_keep]
    biodiv_data$scientificNameID <- paste0("urn:lsid:marinespecies.org:taxname:", biodiv_data$scientificNameID)

    # construction du EventID
    #  - fieldNumber (nom de la station)
    # TODO: ajout 16E et ou 16F?
    biodiv_data$eventID <- paste(biodiv_data$mission, biodiv_data$fieldNumber, sep = "-")

    # FRACTION_DENOMINATOR en fonction du from_mixed_catch
    biodiv_data$FRACTION_DENOMINATOR[biodiv_data$from_mixed_catch == 1] <- 1
    biodiv_data$FRACTION_DENOMINATOR[is.na(biodiv_data$from_mixed_catch)] <- 4



    # effacer les colonnes inutiles / uniquement conserver les bonnes colonnes
    cols_to_keep <- c(
        "eventID",
        "scientificName",
        "scientificNameID",
        "VALIDATED_FINAL_COUNT",
        "VALIDATED_FINAL_MASS_G",
        "VALIDATED_FRACTION_COUNT",
        "VALIDATED_FRACTION_MASS_G",
        "FRACTION_DENOMINATOR",
        "REL_ABUNDANCE_CODE",
        "REL_ABUNDANCE_DESC",
        "ANDES_SET",
        "occurrenceRemarks",
        "eventRemarks",
        "recordNumber",
        "fieldNumber"
    )
    biodiv_data <- biodiv_data[, cols_to_keep]


    return(biodiv_data)

}
