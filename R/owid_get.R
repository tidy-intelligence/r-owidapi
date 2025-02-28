#' Download data from Our World in Data
#'
#' @description
#' Retrieves data from Our World in Data (OWID) by specifying a chart identifier
#' or direct URL. Allows filtering by entities and time periods.
#'
#' @param chart_id Character string specifying the chart identifier
#'  (e.g., "life-expectancy"). Not required if `url` is provided.
#' @param entities Vector of entity codes (e.g., c("USA", "DEU")).
#'   If NULL, data for all available entities is returned.
#' @param start_date Start date for filtering data. Can be a date string or
#'   a year. If NULL, starts from the earliest available data.
#' @param end_date End date for filtering data. Can be a date string or a year.
#'   If NULL, ends with the latest available data.
#' @param url Direct URL to an OWID dataset. If provided, `chart_id` is ignored.
#' @param use_column_short_names Logical. If TRUE (default), uses short column
#'  names.
#' @param snake_case Logical. If TRUE (default), converts column names to
#'  lowercase.
#'
#' @return A tibble containing the requested OWID data.
#'
#' @examplesIf curl::has_internet()
#' \donttest{
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
#'    "?tab=chart&time=earliest..2023"
#'  )
#' )
#' }
#' @export
owid_get <- function(
  chart_id = NULL,
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
        !is.null(start_date),
        format_date(start_date),
        "earliest"
      )
      time_end <- ifelse(
        !is.null(end_date),
        format_date(end_date),
        "latest"
      )
      params$time <- paste0(time_start, "..", time_end)
    }

    if (use_column_short_names) {
      params$useColumnShortNames <- "true"
    }

    req <- request(base_url) |>
      req_url_path_append(paste0(chart_id, ".csv")) |>
      req_url_query(!!!params)
  } else {
    url_prepared <- prepare_url(url, ".csv")
    req <- request(url_prepared)
  }

  resp <- get_chart_data(req)
  data_raw <- read_chart_body(resp)

  if (snake_case) {
    colnames(data_raw) <- tolower(colnames(data_raw))
    colnames(data_raw)[colnames(data_raw) == "entity"] <- "entity_name"
    colnames(data_raw)[colnames(data_raw) == "code"] <- "entity_id"
  }

  data <- convert_day_columns(data_raw)

  data
}

#' @keywords internal
#' @noRd
get_chart_data <- function(req) {
  tryCatch(
    {
      resp <- req |>
        req_user_agent(
          "owidapi R package (https://github.com/tidy-intelligence/r-owidapi)"
        ) |>
        req_perform()
      resp
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
    }
  )
}

#' @keywords internal
#' @noRd
read_chart_body <- function(resp) {
  resp |>
    resp_body_string() |>
    textConnection() |>
    read.csv() |>
    tibble::as_tibble()
}

#' @keywords internal
#' @noRd
convert_day_columns <- function(data) {
  if ("day" %in% colnames(data)) {
    day_col <- "day"
  } else if ("Day" %in% colnames(data)) {
    day_col <- "Day"
  } else {
    day_col <- NULL
  }

  if (!is.null(day_col)) {
    data[[day_col]] <- as.Date(data[[day_col]])
  }

  data
}
