test_that("owid_get basic functionality works", {
  skip_if_offline()

  result <- owid_get("life-expectancy")
  expect_true(is.data.frame(result))
  expect_true("entity_id" %in% names(result))
  expect_true(any(grepl("year|date", names(result))))
  expect_true(nrow(result) > 0)
})

test_that("owid_get filters entities correctly", {
  skip_if_offline()

  entities <- c("USA", "DEU")
  result <- owid_get("life-expectancy", entities = entities)
  expect_true(is.data.frame(result))
  expect_true(all(unique(result$entity_id) %in% entities))
})

test_that("owid_get filters dates correctly", {
  skip_if_offline()

  start_year <- 1960
  end_year <- 1965
  result <- owid_get(
    "life-expectancy", entities = "USA",
    start_date = start_year, end_date = end_year
  )
  expect_true(is.data.frame(result))
  expect_true(all(result$year >= start_year & result$year <= end_year))

  start_date <- "2020-12-28"
  end_date <- "2020-12-31"
  result <- owid_get(
    "daily-covid-vaccination-doses-per-capita",
    entities = "DEU",
    start_date = start_date,
    end_date = end_date
  )
  expect_true(is.data.frame(result))
  expect_true(
    all(
      as.Date(result$day) >= as.Date(start_date) &
        as.Date(result$day) <= as.Date(end_date)
    )
  )
})


test_that("owid_get handles URLs directly", {
  skip_if_offline()

  url <- "https://ourworldindata.org/grapher/civil-liberties-score-fh?tab=chart"
  result <- owid_get(url = url)
  expect_true(is.data.frame(result))
  expect_true(nrow(result) > 0)
})

test_that("owid_get handles column name formatting", {
  skip_if_offline()

  result_uppercase <- owid_get("life-expectancy", snake_case = FALSE)
  expect_true(any(grepl("[A-Z]", names(result_uppercase))))

  result_lowercase <- owid_get("life-expectancy", snake_case = TRUE)
  expect_true(all(grepl("^[a-z]", names(result_lowercase))))
})

test_that("owid_get handles column short names", {
  skip_if_offline()

  result_short <- owid_get("life-expectancy", use_column_short_names = TRUE)

  result_long <- owid_get("life-expectancy", use_column_short_names = FALSE)

  expect_true(is.data.frame(result_short))
  expect_true(is.data.frame(result_long))
})

test_that("owid_get handles errors appropriately", {

  expect_error(owid_get("non-existent-dataset-12345"))

  expect_error(owid_get(url = "https://ourworldindata.org/invalid-url"))
})
