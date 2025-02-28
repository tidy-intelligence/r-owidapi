#' Search for keywords in OWID catalog data
#'
#' @description
#' This function searches for a vector of keywords within specified columns of
#' an OWID catalog data frame. If no columns are specified, it
#' searches all character and factor columns.
#'
#' @param data A data frame, typically obtained from \link{owid_get_catalog}.
#' @param keywords A character vector of one or more keywords to search for.
#'  The search is case-insensitive.
#' @param columns An optional character vector of column names to search within.
#'  If NULL (default), all character and factor columns are searched.
#'
#' @return A filtered data frame containing only rows that match at least one of
#'  the keywords in at least one of the specified columns.
#'
#' @examplesIf curl::has_internet()
#' \donttest{
#' # Get the OWID catalog
#' catalog <- owid_get_catalog()
#'
#' # Search for climate or carbon in all text columns
#' owid_search(catalog, c("climate", "carbon"))
#'
#' # Search only in the title column
#' owid_search(catalog, c("climate", "carbon"), c("title"))
#' }
#' @export
owid_search <- function(data, keywords, columns = NULL) {
  if (!is.data.frame(data)) {
    cli::cli_abort("Input 'data' must be a data frame")
  }

  if (!is.character(keywords) || length(keywords) == 0) {
    cli::cli_abort("'keywords' must be a non-empty character vector")
  }

  if (is.null(columns)) {
    columns <- names(data)[
      sapply(data, function(x) is.character(x) || is.factor(x))
    ]
  } else if (!all(columns %in% names(data))) {
    cli::cli_abort("Some specified columns do not exist in the data")
  }

  match_rows <- apply(data[, columns, drop = FALSE], 1, function(row) {
    any(sapply(keywords, function(keyword) {
      any(grepl(keyword, row, ignore.case = TRUE))
    }))
  })

  data[match_rows, ]
}
