#' Download data from Our World in Data
#'
#' Retrieves datasets from Our World in Data (OWID) by specifying a dataset name
#' or direct URL. Allows filtering by entities and time periods.
#'
#' @param data_set Character string specifying the dataset to download
#'  (e.g., "life-expectancy"). Not required if `url` is provided.
#' @param entities Vector of entity codes (e.g., c("USA", "DEU")).
#'   If NULL, data for all available entities is returned.
#' @param start_date Start date for filtering data. Can be a date string or
#'   a year. If NULL, starts from the earliest available data.
#' @param end_date End date for filtering data. Can be a date string or a year.
#'   If NULL, ends with the latest available data.
#' @param url Direct URL to an OWID dataset. If provided, `data_set` is ignored.
#' @param use_column_short_names Logical. If TRUE (default), uses short column
#'  names.
#' @param snake_case Logical. If TRUE (default), converts column names to
#'  lowercase.
#'
#' @return A tibble containing the requested OWID data.
#'
#' @examplesIf interactive()
#'
#' # Download a full table
#' owid_get("life-expectancy")
#'
#' # Download a table only for selected entities
#' owid_get("life-expectancy", c("AUS", "AUT", "GER"))
#'
#' # Download a table only for selected time periods
#' owid_get("life-expectancy", c("USA"), 1970, 1980)
#'
#' # Download daily data for selected time periods
#' owid_get(
#'  "daily-covid-vaccination-doses-per-capita", "DEU",
#'  "2020-12-28", "2020-12-31"
#' )
#'
#' # Download a table by just providing an URL (with or without .csv)
#' owid_get(
#'  url = paste0(
#'    "https://ourworldindata.org/grapher/civil-liberties-score-fh",
#'    "?tab=chart&time=earliest..2023&country=ARG~AUS~BWA~CHN~ALB~DEU"
#'  )
#' )
#' owid_get(
#'  url = paste0(
#'    "https://ourworldindata.org/grapher/civil-liberties-score-fh.csv",
#'    "?tab=chart"
#'  )
#' )
#'
#' @export
#'
owid_get <- function(
  data_set = NULL,
  entities = NULL,
  start_date = NULL,
  end_date = NULL,
  url = NULL,
  use_column_short_names = TRUE,
  snake_case = TRUE
) {

  if (is.null(url)) {
    base_url <- "https://ourworldindata.org/grapher/"

    params <- list(
      v = "1",
      tab = "chart"
    )

    if (!is.null(entities) || !is.null(start_date) || !is.null(end_date)) {
      params$csvType <- "filtered"
    } else {
      params$csvType <- "full"
    }

    if (!is.null(entities)) {
      params$country <- paste(entities, collapse = "~")
    }

    if (!is.null(start_date) || !is.null(end_date)) {
      time_start <- ifelse(
        !is.null(start_date), format_date(start_date), "earliest"
      )
      time_end <- ifelse(
        !is.null(end_date), format_date(end_date), "latest"
      )
      params$time <- paste0(time_start, "..", time_end)
    }

    if (use_column_short_names) {
      params$useColumnShortNames <- "true"
    }

    req <- request(base_url) |>
      req_url_path_append(paste0(data_set, ".csv")) |>
      req_url_query(!!!params)
  } else {
    url_prepared <- prepare_url(url)
    req <- request(url_prepared)
  }

  tryCatch({
    resp <- req |>
      req_user_agent(
        "owidapi R package (https://github.com/tidy-intelligence/r-owidapi)"
      ) |>
      req_perform()
  },
  error = function(e) {
    cli::cli_abort(
      c(
        "Failed to retrieve data from Our World in Data.",
        "i" = "Error message: {conditionMessage(e)}",
        "i" = "Check your internet connection and the dataset or URL."
      ),
      call = call("owid_get")
    )
    return(invisible(NULL))
  })

  data_raw <- resp |>
    resp_body_string() |>
    textConnection() |>
    read.csv() |>
    tibble::as_tibble()

  if (snake_case) {
    colnames(data_raw) <- tolower(colnames(data_raw))
  }

  data_raw

}

#' @keywords internal
#' @noRd
prepare_url <- function(url) {
  if (grepl("\\.csv\\?", url)) {
    return(url)
  } else {
    parts <- strsplit(url, "\\?", fixed = FALSE)[[1]]
    if (length(parts) == 1) {
      return(paste0(url, ".csv"))
    }
    modified_url <- paste0(parts[1], ".csv?", paste(parts[-1], collapse = "?"))
    return(modified_url)
  }
}

#' @keywords internal
#' @noRd
format_date <- function(date) {
  if (!is.na(date) && grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    return(date)
  } else {
    return(as.character(date))
  }
}
