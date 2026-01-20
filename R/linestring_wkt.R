# defing this here instead of using the package sf to avoid dependency
# If we ever import sf or wellknown, we can replace this function
#' @export
linestring_wkt <- function(p1, p2, fmt = 3) {
    wkt_string <-  "LINESTRING EMPTY"
    if ("lon" %in% names(p1) && "lat" %in% names(p1) &&
        "lon" %in% names(p2) && "lat" %in% names(p2)) {

        if ("z" %in% names(p1) && "z" %in% names(p2)) {
            wkt_string <- sprintf(
                "LINESTRING Z(%.5f %.5f %.5f, %.5f %.5f %.5f)",
                p1$lon, p1$lat, p1$z,
                p2$lon, p2$lat, p2$z
            )
        } else {
            wkt_string <- sprintf(
                "LINESTRING(%.5f %.5f, %.5f %.5f)",
                p1$lon, p1$lat,
                p2$lon, p2$lat
            )
        }
    }
    return(wkt_string)
}
