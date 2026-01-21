
#' Convert a datetime to an OBIS-compliant datetime string based on precision
#'
#' @param dt A POSIXct datetime object.
#' @param precision An integer indicating the precision level (1-7).
#' @param tz An optional timezone string. Interpret the passed `dt` in this `tz`, ignoring its embedded timezone
#' @return A string formatted according to OBIS standards.
#' @export
obis_datetime_str <- function(dt, precision = 6, tz = NULL) {
  if (!is.null(tz)) {
    # interpret the passed datetime in EST, ignoring its tz attribute)
    dt_in_user_timezone <- lubridate::force_tz(dt, tzone = tz)
  } else {
    dt_in_user_timezone <- dt
  }
  if (precision == 1) {
    format_str <- "%Y"
  } else if (precision == 2) {
    format_str <- "%Y-%m"
  } else if (precision == 3) {
    format_str <- "%Y-%m-%d"
  } else if (precision == 4) {
    format_str <- "%Y-%m-%dT%H%z"
  } else if (precision == 5) {
    format_str <- "%Y-%m-%dT%H:%M%z"
  } else if (precision == 6) {
    format_str <- "%Y-%m-%dT%H:%M:%S%z"
  } else if (precision == 7) {
    # Annoying bug with floating point representation and the lack of rounding in the formatting.
    # for example, test "2024-06-01 13:14:15.10" vs "2024-06-01 13:14:15.11"
    format_str <- "%Y-%m-%dT%H:%M:%OS6%z"
  } else {
    stop("Precision not implemented")
  }
  return(format(dt_in_user_timezone, format = format_str))
}


#' Convert a datetime to an OBIS-compliant time string based on precision
#'
#' @param dt A POSIXct datetime object.
#' @param precision An integer indicating the precision level (1-7).
#' @param tz An optional timezone string.
#' @return A string formatted according to OBIS standards.
#' @export
obis_time_str <- function(dt, precision, tz = NULL) {
  if (!is.null(tz)) {
    # interpret the passed datetime in EST, ignoring its tz attribute)
    dt_in_user_timezone <- lubridate::force_tz(dt, tzone = tz)
  } else {
    dt_in_user_timezone <- dt
  }

  if (precision == 4) {
    format_str <- "%H%z"
  } else if (precision == 5) {
    format_str <- "%H:%M%z"
  } else if (precision == 6) {
    format_str <- "%H:%M:%S%z"
  } else if (precision == 7) {
    # Annoying bug with floating point representation and the lack of rounding in the formatting.
    # for example, test "2024-06-01 13:14:15.10" vs "2024-06-01 13:14:15.11"
    format_str <- "%H:%M:%OS6%z"
  } else {
    stop("Precision not implemented")
  }
  return(format(dt_in_user_timezone, format = format_str))
}

#' @export
.calc_nautical_dist <- function(p1_lat, p1_lon, p2_lat, p2_lon) {
  # Haversine formula
  R <- 6371  # Earth radius in km
  delta_lat <- (p2_lat - p1_lat) * (pi / 180)
  delta_lon <- (p2_lon - p1_lon) * (pi / 180)
  a <- sin(delta_lat / 2) * sin(delta_lat / 2) +
    cos(p1_lat * (pi / 180)) * cos(p2_lat * (pi / 180)) *
    sin(delta_lon / 2) * sin(delta_lon / 2)
  c <- 2 * atan2(sqrt(a), sqrt(1 - a))
  distance_km <- R * c
  distance_nautical_miles <- distance_km / 1.852
  return(distance_nautical_miles)

}

#' rbind, but allow different columns names
#' Make a union of the rows filling missing columns with NA
#' 
#'  https://stackoverflow.com/questions/3402371/combine-two-data-frames-by-rows-rbind-when-they-have-different-sets-of-columns
row_union <- function(df1, df2) {
  # special case when the first df is NULL
  if (is.null(df1) && !is.null(df2)) {
    return(df2)
  }

  res <- rbind(
    data.frame(c(df1, sapply(setdiff(names(df2), names(df1)), function(x) NA))),
    data.frame(c(df2, sapply(setdiff(names(df1), names(df2)), function(x) NA)))
  )
  return(res)
}