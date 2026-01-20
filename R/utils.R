
#' Convert a datetime to an OBIS-compliant datetime string based on precision
#'
#' @param dt A POSIXct datetime object.
#' @param precision An integer indicating the precision level (1-7).
#' @param tz An optional timezone string.
#' @return A string formatted according to OBIS standards.
#' @export
obis_datetime_str <- function(dt, precision, tz = NULL) {
  if (!is.null(tz)) {
    dt_in_user_timezone <- lubridate::with_tz(dt, tzone = tz)
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
    format_str <- "%Y-%m-%dT%H:%M:%S.%f%z"
  } else {
    stop("Precision not implemented")
  }
  return(lubridate::format_ISO8601(dt_in_user_timezone, usetz = TRUE, format = format_str)
)
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
    dt_in_user_timezone <- lubridate::with_tz(dt, tzone = tz)
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
    format_str <- "%H:%M:%S.%f%z"
  } else {
    stop("Precision not implemented")
  }
  return(lubridate::format_ISO8601(dt_in_user_timezone, usetz = TRUE, format = format_str)
)
