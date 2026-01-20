#' @export
make_set_wkt <- function(set) {
    if (!is.null(set$start_depth_m) && !is.null(set$end_depth_m)) {
        # convert depth to elevation from mean-sea level by making it negative
        start_coord <- list(
            lon = set$start_longitude,
            lat = set$start_latitude,
            z = -1 * as.numeric(set$start_depth_m)
        )
        end_coord <- list(
            lon = set$end_longitude,
            lat = set$end_latitude,
            z = -1 * as.numeric(set$end_depth_m)
        )
    } else { # if no depth, just use 2D coords
        start_coord <- list(
            lon = set$start_longitude,
            lat = set$start_latitude
        )
        end_coord <- list(lon = set$end_longitude, lat = set$end_latitude)
    }
    return(linestring_wkt(
        p1 = start_coord,
        p2 = end_coord,
        fmt = 6
    ))
}
