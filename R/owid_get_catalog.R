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
        call = call("owid_get_catalog")
      )
    }
  )

  catalog_raw <- resp |>
    resp_body_string() |>
    textConnection() |>
    read.csv() |>
    tibble::as_tibble()

  if (snake_case) {
    catalog <- to_snake_case(catalog_raw)
  } else {
    catalog <- catalog_raw
  }

  catalog
}
