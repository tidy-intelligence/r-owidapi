test_that("owid_get basic functionality works", {
  local_mocked_owid(read_fixture("life-expectancy.csv"))

  result <- owid_get("life-expectancy")

  expect_s3_class(result, "tbl_df")
  expect_true("entity_id" %in% names(result))
  expect_true("entity_name" %in% names(result))
  expect_true(any(grepl("year|date", names(result))))
  expect_equal(nrow(result), 6)
})

test_that("owid_get builds the chart URL from chart_id", {
  recorder <- local_mocked_owid(read_fixture("life-expectancy.csv"))

  owid_get("life-expectancy")

  expect_match(
    recorder$urls,
    "ourworldindata\\.org/grapher/life-expectancy\\.csv"
  )
  expect_match(recorder$urls, "csvType=full")
  expect_match(recorder$urls, "useColumnShortNames=true")
})

test_that("owid_get passes entities to the API", {
  recorder <- local_mocked_owid(read_fixture("life-expectancy.csv"))

  owid_get("life-expectancy", entities = c("USA", "DEU"))

  expect_match(recorder$urls, "csvType=filtered")
  expect_match(recorder$urls, "country=USA~DEU", fixed = TRUE)
})

test_that("owid_get passes dates to the API", {
  recorder <- local_mocked_owid(read_fixture("life-expectancy.csv"))

  owid_get(
    "life-expectancy",
    entities = "USA",
    start_date = 1960,
    end_date = 1965
  )

  expect_match(recorder$urls, "csvType=filtered")
  expect_match(recorder$urls, "time=1960\\.\\.1965")
})

test_that("owid_get defaults open-ended date ranges", {
  recorder <- local_mocked_owid(read_fixture("life-expectancy.csv"))

  owid_get("life-expectancy", start_date = 1960)
  owid_get("life-expectancy", end_date = 1965)

  expect_match(recorder$urls[1], "time=1960\\.\\.latest")
  expect_match(recorder$urls[2], "time=earliest\\.\\.1965")
})

test_that("owid_get converts day columns to dates", {
  local_mocked_owid(read_fixture("daily-covid-vaccinations.csv"))

  result <- owid_get(
    "daily-covid-vaccination-doses-per-capita",
    entities = "DEU",
    start_date = "2020-12-28",
    end_date = "2020-12-31"
  )

  expect_s3_class(result$day, "Date")
  expect_equal(min(result$day), as.Date("2020-12-28"))
  expect_equal(max(result$day), as.Date("2020-12-31"))
})

test_that("owid_get handles URLs directly", {
  recorder <- local_mocked_owid(read_fixture("life-expectancy.csv"))

  url <- "https://ourworldindata.org/grapher/civil-liberties-score-fh?tab=chart"
  result <- owid_get(url = url)

  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
  expect_match(recorder$urls, "civil-liberties-score-fh\\.csv")
})

test_that("owid_get prioritises url over chart_id", {
  recorder <- local_mocked_owid(read_fixture("life-expectancy.csv"))

  owid_get(
    chart_id = "life-expectancy",
    url = "https://ourworldindata.org/grapher/civil-liberties-score-fh"
  )

  expect_match(recorder$urls, "civil-liberties-score-fh\\.csv")
  expect_false(grepl("life-expectancy", recorder$urls))
})

test_that("owid_get handles column name formatting", {
  local_mocked_owid(read_fixture("life-expectancy-long-names.csv"))

  result_uppercase <- owid_get("life-expectancy", snake_case = FALSE)
  expect_true(any(grepl("[A-Z]", names(result_uppercase))))

  result_lowercase <- owid_get("life-expectancy", snake_case = TRUE)
  expect_true(all(grepl("^[a-z]", names(result_lowercase))))
  expect_true(all(c("entity_name", "entity_id") %in% names(result_lowercase)))
})

test_that("owid_get handles column short names", {
  recorder <- local_mocked_owid(read_fixture("life-expectancy.csv"))

  owid_get("life-expectancy", use_column_short_names = TRUE)
  owid_get("life-expectancy", use_column_short_names = FALSE)

  expect_match(recorder$urls[1], "useColumnShortNames=true")
  expect_false(grepl("useColumnShortNames", recorder$urls[2]))
})

test_that("owid_get handles errors appropriately", {
  local_mocked_owid(status_code = 404)

  expect_error(
    owid_get("non-existent-dataset-12345"),
    "Failed to retrieve data from Our World in Data"
  )
  expect_error(
    owid_get(url = "https://ourworldindata.org/invalid-url"),
    "Failed to retrieve data from Our World in Data"
  )
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
