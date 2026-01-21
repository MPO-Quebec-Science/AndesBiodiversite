
#' Gets biodiversity data from ANDES database
#'
#' This function executes a SQL query to retrieve the needed andes data to construct a Biodiversity table.
#' TODO: The mission filter is not yet implemented everywhere, but should be added in the future. It currently uses the active mission 
#' The current ANDES active mission will determine for which mission the data are returned.
#'
#' @param andes_db_connection a connection object to the ANDES database.
#' 
#' @return a dataframe containing andes biodiveristy data
#' @seealso [andes_db_connect()] for getting a connection object to the ANDES database.
#' @family {Andesdb query functions}
#' @export
get_biodiv_data <- function(andes_db_connection) {

    query <- readr::read_file(system.file("sql_queries",
                                          "biodiv_data.sql",
                                          package = "AndesBiodiversite"))

    # add mission filter
    # use the active misison, one day you can choose a different mission,
    # query <- paste(query, "WHERE shared_models_mission.is_active=1")

    result <- DBI::dbSendQuery(andes_db_connection, query)
    biodiv_data <- DBI::dbFetch(result, n = Inf)
    DBI::dbClearResult(result)

    # there are catches that are for the commercial survey,
    # normally they can be weeded out by filtering using the basket class
    # BUT! there aren't always baskets for cases that have relative abundances

    # has_abundance_category <- !is.na(biodiv_data$relative_abundance)
    # has_biodiv_basket <- biodiv_data$class == 9
    # to_keep <- has_biodiv_basket | has_abundance_category

    # biodiv_data <- biodiv_data[to_keep]
    biodiv_data$scientificNameID <- paste0("urn:lsid:marinespecies.org:taxname:", biodiv_data$scientificNameID)

    # construction du EventID
    #  - mission (numéro de la mission)
    #  - fieldNumber (nom de la station)
    # TODO: ajout 16E et ou 16F pour Petoncle Minagnie
    biodiv_data$eventID <- paste(biodiv_data$mission, biodiv_data$fieldNumber, biodiv_data$sample_number, sep = "-")

    # FRACTION_DENOMINATOR en fonction du from_mixed_catch
    biodiv_data$FRACTION_DENOMINATOR[biodiv_data$from_mixed_catch == 1] <- 4
    biodiv_data$FRACTION_DENOMINATOR[is.na(biodiv_data$from_mixed_catch)] <- 1


    # conversion en colonnes numériques
    biodiv_data$VALIDATED_SUBSAMPLE_MASS_G <- as.numeric(biodiv_data$VALIDATED_SUBSAMPLE_MASS_G)
    biodiv_data$VALIDATED_SUBSAMPLE_COUNT <- as.numeric(biodiv_data$VALIDATED_SUBSAMPLE_COUNT)
    biodiv_data$basket_wt_kg <- as.numeric(biodiv_data$basket_wt_kg)
    biodiv_data$unmeasured_specimen_count <- as.numeric(biodiv_data$unmeasured_specimen_count)


    has_subsample <- !is.na(biodiv_data$VALIDATED_SUBSAMPLE_COUNT) & !is.na(biodiv_data$VALIDATED_SUBSAMPLE_MASS_G)
    has_no_fractional_count <- is.na(biodiv_data$unmeasured_specimen_count) | biodiv_data$unmeasured_specimen_count == 0

    needs_fraction_extrapolation <- has_subsample & has_no_fractional_count
    # Extrapolate the fractional count
    # basket_wt_kg should have been entered
    biodiv_data$VALIDATED_FRACTION_MASS_G[needs_fraction_extrapolation] <- biodiv_data$basket_wt_kg[needs_fraction_extrapolation]
    biodiv_data$VALIDATED_FRACTION_COUNT[needs_fraction_extrapolation] <- biodiv_data$VALIDATED_FRACTION_MASS_G[needs_fraction_extrapolation] *
        biodiv_data$VALIDATED_SUBSAMPLE_COUNT[needs_fraction_extrapolation] / 
        biodiv_data$VALIDATED_SUBSAMPLE_MASS_G[needs_fraction_extrapolation]

    # For others, use the basket weight and count directly
    biodiv_data$VALIDATED_FRACTION_MASS_G[!needs_fraction_extrapolation] <- biodiv_data$basket_wt_kg[!needs_fraction_extrapolation]
    biodiv_data$VALIDATED_FRACTION_COUNT[!needs_fraction_extrapolation] <- biodiv_data$unmeasured_specimen_count[!needs_fraction_extrapolation]

    # calculate final values
    biodiv_data$VALIDATED_FINAL_MASS_G <- biodiv_data$VALIDATED_FRACTION_MASS_G * biodiv_data$FRACTION_DENOMINATOR
    biodiv_data$VALIDATED_FINAL_COUNT <- biodiv_data$VALIDATED_FRACTION_COUNT * biodiv_data$FRACTION_DENOMINATOR

    # convert kg to g
    biodiv_data$VALIDATED_FINAL_MASS_G <- biodiv_data$VALIDATED_FINAL_MASS_G * 1000
    biodiv_data$VALIDATED_FRACTION_MASS_G <- biodiv_data$VALIDATED_FRACTION_MASS_G * 1000
    biodiv_data$VALIDATED_SUBSAMPLE_MASS_G <- biodiv_data$VALIDATED_SUBSAMPLE_MASS_G * 1000

    # remove line breaks from comments field (replace with space)
    # biodiv_data$eventRemarks <- gsub("[\r\n]", " ", biodiv_data$eventRemarks)
    biodiv_data$occurrenceRemarks <- gsub("[\r\n]", " ", biodiv_data$occurrenceRemarks)

    biodiv_data$ANDES_SET <- biodiv_data$sample_number
    # effacer les colonnes inutiles / uniquement conserver les bonnes colonnes
    cols_to_keep <- c(
        "eventID",
        "scientificName",
        "scientificNameID",
        "VALIDATED_FINAL_COUNT",
        "VALIDATED_FINAL_MASS_G",
        "VALIDATED_FRACTION_COUNT",
        "VALIDATED_FRACTION_MASS_G",
        "VALIDATED_SUBSAMPLE_COUNT",
        "VALIDATED_SUBSAMPLE_MASS_G",
        "FRACTION_DENOMINATOR",
        "REL_ABUNDANCE_CODE",
        "REL_ABUNDANCE_DESC",
        "ANDES_SET",
        "occurrenceRemarks",
        "recordNumber",
        "fieldNumber"
    )
    biodiv_data <- biodiv_data[, cols_to_keep]

    return(biodiv_data)
}
