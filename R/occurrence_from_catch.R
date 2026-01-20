

#' @export
occurrence_from_catch <- function(catch, event = NULL) {
  message("creating occurence from catch : ", catch$catch_id, " ", event$eventID)
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

  occurrence$occurrenceRemarks <- catch$notes

  return(occurrence)

}

    # scientificNameID,
    # scientificName,
    # ANDES_SET,
    # eventRemarks,
    # fieldNumber,
    # mission,
    # recordNumber,
    # REL_ABUNDANCE_DESC,
    # REL_ABUNDANCE_CODE,
    # occurrenceRemarks,
    # class,
    # from_mixed_catch
