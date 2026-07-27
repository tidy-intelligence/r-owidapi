metadata_fixture <- function() {
  read_fixture("life-expectancy-metadata.json")
}

test_that("owid_get_metadata works with chart_id parameter", {
  recorder <- local_mocked_owid(
    metadata_fixture(),
    content_type = "application/json"
  )

  result <- owid_get_metadata("life-expectancy")

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true(!is.null(result$chart))
  expect_equal(result$chart$title, "Life expectancy")
  expect_match(recorder$urls, "life-expectancy\\.metadata\\.json")
})

test_that("owid_get_metadata works with URL parameter", {
  recorder <- local_mocked_owid(
    metadata_fixture(),
    content_type = "application/json"
  )

  url <- "https://ourworldindata.org/grapher/civil-liberties-score-fh"
  result <- owid_get_metadata(url = url)

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true(!is.null(result$chart))
  expect_match(
    recorder$urls,
    "civil-liberties-score-fh\\.metadata\\.json"
  )
})

test_that("owid_get_metadata prioritizes url over chart_id", {
  recorder <- local_mocked_owid(
    metadata_fixture(),
    content_type = "application/json"
  )

  chart_id <- "life-expectancy"
  url <- "https://ourworldindata.org/grapher/civil-liberties-score-fh"

  expected_result <- owid_get_metadata(url = url)
  actual_result <- owid_get_metadata(chart_id = chart_id, url = url)

  expect_equal(actual_result, expected_result)
  expect_equal(recorder$urls[1], recorder$urls[2])
  expect_false(any(grepl("life-expectancy", recorder$urls)))
})

test_that("owid_get_metadata handles invalid chart_id parameter", {
  local_mocked_owid(status_code = 404)

  expect_error(
    owid_get_metadata(chart_id = "non-existent-dataset-123456789"),
    "Failed to retrieve data from Our World in Data"
  )
})

test_that("owid_get_metadata handles invalid URL parameter", {
  local_mocked_owid(status_code = 404)

  url <- "https://ourworldindata.org/grapher/non-existent-dataset-123456789"

  expect_error(
    owid_get_metadata(url = url),
    "Failed to retrieve data from Our World in Data"
  )
})

test_that("owid_get_metadata throws error when both chart_id & url are NULL", {
  local_mocked_owid(status_code = 404)

  expect_error(
    owid_get_metadata(chart_id = NULL, url = NULL),
    "Failed to retrieve data from Our World in Data"
  )
})

test_that("owid_get_metadata correctly handles different URL formats", {
  recorder <- local_mocked_owid(
    metadata_fixture(),
    content_type = "application/json"
  )

  url_with_params <- paste0(
    "https://ourworldindata.org/grapher/civil-liberties-score-fh?tab=chart"
  )
  result <- owid_get_metadata(url = url_with_params)

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_match(recorder$urls, "civil-liberties-score-fh\\.metadata\\.json")
  expect_match(recorder$urls, "tab=chart")
})
