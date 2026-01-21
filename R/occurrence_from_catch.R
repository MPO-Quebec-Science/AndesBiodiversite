#' Create an OBISOccurence from an Andes catch
#'
#' This function creates an OBISOccurence object representing a catch from the Andes database.
#' It maps certain fields to a corresponding DwC event fields, and addes hard-coded values where necessary.
#'
#' @param catch A dataframe (single row) containing a catch data from an Andes database
#' @param event The parent event of class OBISEvent (default is NULL). The mission OBISevent is usually usually the top-level event and has no parent.
#' @param quiet Supress console messages (default is FALSE).
#'
#' @return an occurrence of class OBISOccurence representing the catch.
#' @family {OBISOccurrence creation functions}
#' @export
occurrence_from_catch <- function(catch, event = NULL, quiet = FALSE) {
  if (quiet == FALSE) {
    message("creating occurence from catch : ", catch$catch_id, " ", event$eventID)
  }
  if (is.null(event)) {
    stop("An event must be provided to create an occurrence")
  }

  occurrence <- list()
  class(occurrence) <- c("OBISOccurrence")
  occurrence$eventID <- event$eventID

  occurrence$occurenceID <- paste0(occurrence$eventID, "_", catch$catch_id)
  occurrence$basisOfRecord <- "HumanObservation"
  occurrence$occurrenceStatus <- "present"

  occurrence$associatedMedia <- NA
  occurrence$taxonRemarks <- NA
  occurrence$identificationRemarks <- NA

  occurrence$verbatimIdentification <- catch$scientific_name
  occurrence$scientificName <- catch$scientific_name
  occurrence$scientificNameID <- paste0(
    "urn:lsid:marinespecies.org:taxname:",
    catch$aphia_id
  )

  occurrence$recordNumber <- catch$catch_id

  occurrence$occurrenceRemarks <- catch$notes

  return(occurrence)
}
