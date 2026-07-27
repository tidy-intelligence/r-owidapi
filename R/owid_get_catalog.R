#' Download data catalog of Our World in Data
#'
#' @description
#' Downloads the data catalog of Our World in Data (OWID) hosted on Datasette.
#'
#' @param snake_case Logical. If TRUE (default), converts column names to
#'  lowercase.
#'
#' @return A tibble containing the OWID catalog, with one row per chart.
#' @examplesIf curl::has_internet()
#' \donttest{
#' # Download a full table
#' owid_get_catalog()
#' }
#' @export
owid_get_catalog <- function(
  snake_case = TRUE
) {
  # `_stream=on` is required to get the complete catalog: Datasette caps
  # `_size=max` at its max_returned_rows setting (1000 for this instance),
  # which silently truncated the catalog to a fraction of the charts.
  base_url <- c(
    "https://datasette-public.owid.io/owid/charts.csv?_labels=on&_stream=on"
  )

  req <- request(base_url)

  tryCatch(
    {
      resp <- perform_request(req, "owid_get_catalog")

      catalog_raw <- resp |>
        resp_body_string() |>
        textConnection() |>
        read.csv() |>
        tibble::as_tibble()

      catalog_parsed <- parse_catalog_columns(catalog_raw)

      if (snake_case) {
        catalog <- to_snake_case(catalog_parsed)
      } else {
        catalog <- catalog_parsed
      }

      catalog
    },
    error = function(e) {
      cli_alert(
        conditionMessage(e)
      )
      invisible(NULL)
    }
  )
}
