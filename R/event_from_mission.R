#' Create an OBISEvent from an Andes mission
#'
#' This function creates an OBISEvent object representing a mission from the Andes database.
#' It maps certain fields to a corresponding DwC event fields, and addes hard-coded values where necessary.
#'
#' @param mission A dataframe (single row) containing a mission set from an Andes database
#' @param parent_event The parent event of class OBISEvent (default is NULL). The mission OBISevent is usually usually the top-level event and has no parent.
#' @param quiet Supress console messages (default is FALSE).
#'
#' @return an event of class OBISEvent representing a mission.
#' @seealso [get_andes_mission()] for getting a list of missions  (usualy only a single active mission) from the Andes DB.
#' @family {OBISEvent creation functions}
#' @export
event_from_mission <- function(mission, parent = NULL, quiet = FALSE) {
  if (quiet == FALSE) {
    message("initialising top-event from mission : ", mission$mission_number)
  }
  # if (is.nan(mission)) {
  #     stop("_init_from_mission needs a valid mission")
  # }

  event <- list()
  class(event) <- c("OBISEvent")
  event$parentEventID <- NULL
  # event$parentEventID <- parent

  event$eventID <- mission$mission_number

  event$start_dt <- obis_datetime_str(mission$start_date, precision = 3)

  event$end_dt <- obis_datetime_str(mission$end_date, precision = 3)

  # use cruise bounding box
  event$decimalLatitude <- 0.5 * (mission$max_lat + mission$min_lat)
  event$decimalLongitude <- 0.5 * (mission$max_lng + mission$min_lng)
  # use half of great-circle distance (converted to metres)
  coordinateUncertaintyInMeters <- 1852 *
    0.5 *
    .calc_nautical_dist(
      p1_lat = mission$max_lat,
      p1_lon = mission$max_lng,
      p2_lat = mission$min_lat,
      p2_lon = mission$min_lng
    )
  event$coordinateUncertaintyInMeters <- round(coordinateUncertaintyInMeters, 3)

  event$fieldNumber <- mission$mission_number

  mission_notes <- mission$notes
  # remove line breaks
  mission_notes <- gsub("[\r\n]", " ", mission_notes)
  event$eventRemarks <- mission_notes

  # Hard-coded values
  event$eventType <- "Project" # https://registry.gbif-uat.org/vocabulary/EventType/concepts
  event$continent <- "North America"
  event$language <- "En"
  event$coordinatePrecision <- NA
  event$license <- "http://creativecommons.org/licenses/by/4.0/legalcode"
  event$rightsHolder <- "His Majesty the King in right of Canada, as represented by the Minister of Fisheries and Oceans"
  event$institutionID <- "https://edmo.seadatanet.org/report/4160"
  event$institutionCode <- "IML"
  event$datasetName <- NA
  event$datasetID <- NA
  event$countryCode <- "CA"
  event$country <- "Canada"

  return(event)
}
