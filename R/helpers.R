#' @keywords internal
#' @noRd
prepare_url <- function(url, ending = ".csv") {
  if (grepl(paste0("\\", ending, "\\?"), url)) {
    return(url)
  } else {
    parts <- strsplit(url, "\\?", fixed = FALSE)[[1]]
    needs_filtered_param <- grepl("time|country", url, ignore.case = TRUE)

    if (length(parts) == 1) {
      base_url <- paste0(url, ending)

      if (needs_filtered_param) {
        return(paste0(base_url, "?csvType=filtered"))
      } else {
        return(base_url)
      }
    }

    base_url <- paste0(parts[1], ending)
    query_params <- parts[-1]

    if (
      needs_filtered_param &&
        !grepl("csvType=filtered", paste(query_params, collapse = "?"))
    ) {
      modified_url <- paste0(
        base_url,
        "?csvType=filtered&",
        paste(query_params, collapse = "?")
      )
    } else {
      modified_url <- paste0(
        base_url,
        "?",
        paste(query_params, collapse = "?")
      )
    }

    return(modified_url)
  }
}

#' @keywords internal
#' @noRd
format_date <- function(date) {
  if (!is.na(date) && grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    date
  } else {
    as.character(date)
  }
}

#' @keywords internal
#' @noRd
to_snake_case <- function(df) {
  convert_string <- function(x) {
    x <- gsub("_", " ", x)
    x <- gsub("([a-z])([A-Z])", "\\1 \\2", x)
    x <- tolower(x)
    x <- gsub(" ", "_", x)
  }
  colnames(df) <- sapply(colnames(df), convert_string)
  df
}
