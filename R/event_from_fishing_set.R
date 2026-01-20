
#' @export
event_from_fishing_set <- function(set, parent_event = NULL) {
        message("creating event from set : ", set$sample_number)

        # if (is.null(set)) {
        #     stop("need a valid set")
        # }

        # if len(set.operations.filter(is_fishing=True)) == 0:
        #     logging.getLogger(__name__).warning("%s has no fishing operations", my_set)
        #     raise ValueError

        event <- list()
        class(event) <- c("OBISEvent")
        event$eventID <- paste(parent_event$eventID, set$sample_number, sep = "-")
        event$parentEventID <- parent_event$eventID

        event$start_dt_p <- 6
        event$start_dt <- obis_datetime_str(set$start_date, precision = event$start_dt_p)

        event$end_dt_p <- 6
        event$end_dt <- obis_datetime_str(set$end_date, precision = event$end_dt_p)

        # use set bounding box
        event$decimalLatitude <- 0.5 * (set$start_latitude + set$end_latitude)
        event$decimalLongitude <- 0.5 * (set$start_longitude + set$end_longitude)
        # use half of great-circle distance (converted to metres)
        coordinateUncertaintyInMeters <-1852 * 0.5 * .calc_nautical_dist(
                p1_lat = set$start_latitude,
                p1_lon = set$start_longitude,
                p2_lat = set$end_latitude,
                p2_lon = set$end_longitude
            )

        event$coordinateUncertaintyInMeters = round(coordinateUncertaintyInMeters, digits = 3)

        set_remarks <- set$remarks
        # remove line breaks
        set_remarks <- gsub("[\r\n]", " ", set_remarks)
        event$eventRemarks <- set_remarks


        event$footprintWKT <- make_set_wkt(set)
        event$fieldNumber <- set$station_name

        event$maximumDepthInMeters <- as.numeric(set$max_depth_m)
        event$minimumDepthInMeters <- as.numeric(set$min_depth_m)

        # hard-coded values
        event$eventType <- "SiteVisit"  # https://registry.gbif-uat.org/vocabulary/EventType/concepts

        return(event)
}
