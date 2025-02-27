test_that("owid_get_metadata works with chart_id parameter", {
  skip_if_offline()

  result <- owid_get_metadata("life-expectancy")

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true(!is.null(result$chart))
})

test_that("owid_get_metadata works with URL parameter", {
  skip_if_offline()

  url <- "https://ourworldindata.org/grapher/civil-liberties-score-fh"
  result <- owid_get_metadata(url = url)

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true(!is.null(result$chart))
})

test_that("owid_get_metadata prioritizes url over chart_id", {
  skip_if_offline()

  chart_id <- "life-expectancy"
  url <- "https://ourworldindata.org/grapher/civil-liberties-score-fh"

  expected_result <- owid_get_metadata(url = url)
  actual_result <- owid_get_metadata(chart_id = chart_id, url = url)

  expect_equal(actual_result, expected_result)
})

test_that("owid_get_metadata handles invalid chart_id parameter", {
  skip_if_offline()

  chart_id <- "non-existent-dataset-123456789"

  expect_error(
    owid_get_metadata(chart_id = chart_id),
    "Failed to retrieve data from Our World in Data"
  )
})

test_that("owid_get_metadata handles invalid URL parameter", {
  skip_if_offline()

  url <- "https://ourworldindata.org/grapher/non-existent-dataset-123456789"

  expect_error(
    owid_get_metadata(url = url),
    "Failed to retrieve data from Our World in Data"
  )
})

test_that("owid_get_metadata throws error when both chart_id & url are NULL", {
  expect_error(
    owid_get_metadata(chart_id = NULL, url = NULL),
    "Failed to retrieve data from Our World in Data"
  )
})

test_that("owid_get_metadata correctly handles different URL formats", {
  skip_if_offline()

  url_with_params <- paste0(
    "https://ourworldindata.org/grapher/civil-liberties-score-fh?tab=chart"
  )
  result <- owid_get_metadata(url = url_with_params)

  expect_type(result, "list")
  expect_true(length(result) > 0)
})
