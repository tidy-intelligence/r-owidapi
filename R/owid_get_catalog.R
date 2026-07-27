#' Download data catalog of Our World in Data
#'
#' @description
#' Downloads the data catalog of Our World in Data (OWID) hosted on Datasette.
#'
#' @param snake_case Logical. If TRUE (default), converts column names to
#'  lowercase.
#'
#' @return A tibble containing the OWID catalog.
#' @examplesIf curl::has_internet()
#' \donttest{
#' # Download a full table
#' owid_get_catalog()
#' }
#' @export
owid_get_catalog <- function(
  snake_case = TRUE
) {
  base_url <- c(
    "https://datasette-public.owid.io/owid/charts.csv?_labels=on&_size=max"
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
