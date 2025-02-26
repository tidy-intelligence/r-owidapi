#' Download metadata from Our World in Data
#'
#' Retrieves the metadata for a data set from Our World in Data (OWID) by
#' specifying a dataset name or direct URL.
#'
#' @param data_set Character string specifying the dataset to download
#'  (e.g., "life-expectancy"). Not required if `url` is provided.
#' @param url Direct URL to an OWID dataset. If provided, `data_set` is ignored.
#'
#' @return A list containing the requested OWID metadata.
#'
#' @examplesIf interactive()
#' \donttest{
#' # Download metadata using a data set
#' owid_get_metadata("life-expectancy")
#'
#' # Download metadata using an url
#' owid_get_metadata(
#'  url = "https://ourworldindata.org/grapher/civil-liberties-score-fh"
#' )
#' }
#' @export
owid_get_metadata <- function(
  data_set = NULL,
  url = NULL
) {
  if (is.null(url)) {
    base_url <- "https://ourworldindata.org/grapher/"

    req <- request(base_url) |>
      req_url_path_append(paste0(data_set, ".metadata.json"))
  } else {
    url_prepared <- prepare_url(url, ".metadata.json")
    req <- request(url_prepared)
  }

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
        call = call("owid_get_metadata")
      )
    }
  )

  metadata <- resp |>
    resp_body_json()
  metadata
}
