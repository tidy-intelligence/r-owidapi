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
    "life-expectancy",
    entities = "USA",
    start_date = start_year,
    end_date = end_year
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

test_that("convert_day_columns handles lowercase 'day' column", {
  test_data <- data.frame(
    id = 1:3,
    day = c("2023-01-01", "2023-01-02", "2023-01-03"),
    value = c(10, 20, 30)
  )
  result <- convert_day_columns(test_data)
  expect_true(inherits(result$day, "Date"))
  expect_equal(
    as.character(result$day),
    c("2023-01-01", "2023-01-02", "2023-01-03")
  )
  expect_equal(result$id, test_data$id)
  expect_equal(result$value, test_data$value)
})

test_that("convert_day_columns handles uppercase 'Day' column", {
  test_data <- data.frame(
    id = 1:3,
    Day = c("2023-01-01", "2023-01-02", "2023-01-03"),
    value = c(10, 20, 30)
  )
  result <- convert_day_columns(test_data)
  expect_true(inherits(result$Day, "Date"))
  expect_equal(
    as.character(result$Day),
    c("2023-01-01", "2023-01-02", "2023-01-03")
  )
  expect_equal(result$id, test_data$id)
  expect_equal(result$value, test_data$value)
})

test_that("convert_day_columns handles data without day column", {
  test_data <- data.frame(
    id = 1:3,
    value = c(10, 20, 30)
  )
  result <- convert_day_columns(test_data)
  expect_identical(result, test_data)
})

test_that("convert_day_columns handles different date formats", {
  test_data <- data.frame(
    id = 1:3,
    day = c("2023/01/01", "01/02/2023", "2023-01-03"),
    stringsAsFactors = FALSE
  )
  result <- convert_day_columns(test_data)
  expect_true(inherits(result$day, "Date"))
})

test_that("convert_day_columns preserves row order", {
  test_data <- data.frame(
    id = c(3, 1, 2),
    day = c("2023-01-03", "2023-01-01", "2023-01-02"),
    value = c(30, 10, 20)
  )
  result <- convert_day_columns(test_data)
  expect_equal(result$value, c(30, 10, 20))
  expect_equal(
    as.character(result$day),
    c("2023-01-03", "2023-01-01", "2023-01-02")
  )
})

test_that("convert_day_columns handles empty dataframe", {
  test_data <- data.frame(day = character(0))
  result <- convert_day_columns(test_data)
  expect_true(is.data.frame(result))
  expect_true(inherits(result$day, "Date"))
  expect_equal(nrow(result), 0)
})
