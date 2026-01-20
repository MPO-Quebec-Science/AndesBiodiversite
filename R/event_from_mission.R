
#' @export
event_from_mission <- function(mission, parent = NULL) {
    message("initialising top-event from mission : ", mission$mission_number)

    # if (is.nan(mission)) {
    #     stop("_init_from_mission needs a valid mission")
    # }

    event <- list()
    class(event) <- c("OBISEvent")
    event$parentEventID <- NULL
    # event$parentEventID <- parent

    event$eventID <- mission$mission_number

    event$start_dt_p <- 3
    event$start_dt <- obis_datetime_str(mission$start_date, precision = event$start_dt_p)

    event$end_dt_p <- 3
    event$end_dt <- obis_datetime_str(mission$end_date, precision = event$end_dt_p)

    # use cruise bounding box
    event$decimalLatitude <- 0.5 * (mission$max_lat + mission$min_lat)
    event$decimalLongitude <- 0.5 * (mission$max_lng + mission$min_lng)
    # use half of great-circle distance (converted to metres)
    coordinateUncertaintyInMeters <- 1852 * 0.5 * .calc_nautical_dist(
                                                    p1_lat = mission$max_lat,
                                                    p1_lon = mission$max_lng,
                                                    p2_lat = mission$min_lat,
                                                    p2_lon = mission$min_lng
                                                )
    event$coordinateUncertaintyInMeters = round(coordinateUncertaintyInMeters, 3)

    event$fieldNumber <- mission$mission_number

    mission_notes <- mission$notes
    # remove line breaks
    mission_notes <- gsub("[\r\n]", " ", mission_notes)
    event$eventRemarks <- mission_notes

    # Hard-coded values
    event$eventType <- "Project"  # https://registry.gbif-uat.org/vocabulary/EventType/concepts
    event$continent <- "North America"
    event$language <- "En"
    event$coordinatePrecision <- NA
    event$license <- "http://creativecommons.org/licenses/by/4.0/legalcode"
    event$rightsHolder <- "His Majesty the King in right of Canada, as represented by the Minister of Fisheries and Oceans"
    event$institutionID <- "https://edmo.seadatanet.org/report/4160"
    event$institutionCode <- "IML"
    event$datasetName <- NA
    event$countryCode <- "CA"
    event$country <- "Canada"

    return(event)
}
