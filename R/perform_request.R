#' @keywords internal
#' @noRd
perform_request <- function(req, context) {
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
        call = call(context)
      )
    }
  )
}
