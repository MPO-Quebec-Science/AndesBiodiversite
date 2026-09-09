#' a merge that preserves row and column order
#'
#' shamelessly stolen from https://stackoverflow.com/questions/17878048/merge-two-data-frames-while-keeping-the-original-row-order
#' @param x the "left" dataframe (all.x=TRUE)
#' @param y the "right" dataframe
#' @param ... Additional arguments passed on to methgods
#' @export
left_join_preserve_order <- function(x, y, ...) {
  x$join_id_ <- seq_len(nrow(x))
  joined <- merge(x = x, y = y, all.x = TRUE, sort = FALSE, ...)

  cols <- unique(c(colnames(x), colnames(y)))
  joined <- joined[
    order(joined$join_id),
    cols[cols %in% colnames(joined) & cols != "join_id_"]
  ]
  rownames(joined) <- NULL
  return(joined)
}
