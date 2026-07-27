#' Download data catalog of Our World in Data
#'
#' @description
#' Downloads the data catalog of Our World in Data (OWID) hosted on Datasette.
#' The catalog is retrieved page by page, so the complete set of charts is
#' returned rather than just the first page.
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
  tryCatch(
    {
      catalog_raw <- fetch_catalog()

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

#' @keywords internal
#' @noRd
fetch_catalog <- function(max_pages = 100) {
  pages <- list()
  last_id <- NULL

  for (page_number in seq_len(max_pages)) {
    page <- fetch_catalog_page(last_id)

    if (nrow(page) == 0) {
      return(combine_catalog_pages(pages))
    }

    if (!"id" %in% colnames(page)) {
      cli::cli_abort(
        c(
          "The OWID catalog no longer contains an {.field id} column.",
          "i" = "The catalog cannot be paged through without it."
        ),
        call = call("owid_get_catalog")
      )
    }

    pages[[page_number]] <- page

    # Datasette caps a single response at 1000 rows, so the catalog is paged
    # through by asking for ids above the highest one seen so far. Using the
    # highest id rather than the last row means a response that is cut short
    # is simply picked up again by the next request.
    last_id <- max(page$id, na.rm = TRUE)

    if (!is.finite(last_id)) {
      cli::cli_abort(
        "Received an OWID catalog page without a usable {.field id}.",
        call = call("owid_get_catalog")
      )
    }
  }

  cli::cli_abort(
    c(
      "The OWID catalog did not end after {max_pages} pages.",
      "i" = "This is unexpected - please report it as a bug."
    ),
    call = call("owid_get_catalog")
  )
}

#' @keywords internal
#' @noRd
fetch_catalog_page <- function(last_id = NULL) {
  base_url <- "https://datasette-public.owid.io/owid/charts.csv"

  req <- request(base_url) |>
    req_url_query(
      `_labels` = "on",
      `_size` = "max",
      `_sort` = "id"
    )

  if (!is.null(last_id)) {
    req <- req_url_query(req, id__gt = last_id)
  }

  resp <- perform_request(req, "owid_get_catalog")

  resp |>
    resp_body_string() |>
    textConnection() |>
    read.csv() |>
    tibble::as_tibble()
}

#' @keywords internal
#' @noRd
combine_catalog_pages <- function(pages) {
  if (length(pages) == 0) {
    return(tibble::tibble())
  }

  catalog <- do.call(rbind, pages)

  # Guard against a page boundary being served twice.
  catalog[!duplicated(catalog$id), ]
}
