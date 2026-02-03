# Function to remove cells with values of zero (i.e. cells with no species present) in a PresenceAbscence object
# Bruno Vilela

.removeCells <- function(x) {
  start_col <- which(apply(x, 2, function(col) all(col %in% c(0, 1, NA))))[1]
  
  if (is.na(start_col)) {
    start_col <- 3
  }
  rem <- which(rowSums(x[, start_col:ncol(x), drop = FALSE]) == 0)
  if (length(rem) > 0) {
    x <- x[-rem, , drop = FALSE]
  }
  if(nrow(x) == 0) {
    stop("No cells left after removing cells without occurrences")
  }
  return(x)
}