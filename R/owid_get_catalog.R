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

      # Parse logicals
      catalog_raw$isInheritanceEnabled <- catalog_raw$isInheritanceEnabled ==
        "True"
      catalog_raw$isIndexable <- catalog_raw$isIndexable == "True"
      catalog_raw$isPublished <- catalog_raw$isPublished == "True"

      # Parse dates
      catalog_raw$createdAt <- as.Date(catalog_raw$createdAt)
      catalog_raw$updatedAt <- as.Date(catalog_raw$updatedAt)
      catalog_raw$lastEditedAt <- as.Date(catalog_raw$lastEditedAt)
      catalog_raw$publishedAt <- as.Date(catalog_raw$publishedAt)

      if (snake_case) {
        catalog <- to_snake_case(catalog_raw)
      } else {
        catalog <- catalog_raw
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
