# Helpers to mock the OWID API with httr2, so that the test suite never
# needs an internet connection.

read_fixture <- function(name) {
  paste(
    readLines(testthat::test_path("fixtures", name), warn = FALSE),
    collapse = "\n"
  )
}

mock_response <- function(body, status_code = 200, content_type = "text/csv") {
  httr2::response(
    status_code = status_code,
    headers = list(`Content-Type` = paste0(content_type, "; charset=UTF-8")),
    body = charToRaw(enc2utf8(body))
  )
}

# Mocks req_perform() for the duration of the calling frame and records every
# request the package sends, so that tests can also assert on the URLs that
# are constructed.
#
# `body` may be a character vector, in which case each request is answered with
# the next element - needed for paged endpoints such as the catalog. Once the
# bodies run out, the last one is repeated.
local_mocked_owid <- function(
  body = "",
  status_code = 200,
  content_type = "text/csv",
  env = parent.frame()
) {
  bodies <- as.character(body)
  recorder <- new.env(parent = emptyenv())
  recorder$urls <- character()

  httr2::local_mocked_responses(
    function(req) {
      recorder$urls <- c(recorder$urls, req$url)
      index <- min(length(recorder$urls), length(bodies))
      mock_response(bodies[[index]], status_code, content_type)
    },
    env = env
  )

  recorder
}

# The bodies a full catalog download expects: one page of charts followed by
# an empty page that ends the pagination.
catalog_pages <- function(...) {
  c(
    vapply(c(...), read_fixture, character(1)),
    read_fixture("catalog-empty.csv")
  )
}
