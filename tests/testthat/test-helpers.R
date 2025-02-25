test_that("format_date handles different date formats correctly", {
  expect_equal(format_date("2020-01-01"), "2020-01-01")
  expect_equal(format_date(2020), "2020")
  expect_equal(format_date("2020"), "2020")
  expect_equal(format_date(NA), NA_character_)
})

test_that("prepare_url adds ending to URL with no query parameters", {
  url <- "https://ourworldindata.org/grapher/life-expectancy"
  result <- prepare_url(url)
  expected <- "https://ourworldindata.org/grapher/life-expectancy.csv"
  expect_equal(result, expected)
})

test_that("prepare_url handles custom endings", {
  url <- "https://ourworldindata.org/grapher/life-expectancy"
  result <- prepare_url(url, ending = ".metadata.json")
  expected <- "https://ourworldindata.org/grapher/life-expectancy.metadata.json"
  expect_equal(result, expected)
})

test_that("prepare_url preserves URL if it already contains the ending", {
  url <- "https://ourworldindata.org/grapher/life-expectancy.csv?country=USA"
  result <- prepare_url(url)
  expect_equal(result, url)
})

test_that("prepare_url adds ending and preserves query parameters", {
  url <- "https://ourworldindata.org/grapher/life-expectancy?country=USA"
  result <- prepare_url(url)
  expected <- paste0(
    "https://ourworldindata.org/grapher/life-expectancy.csv",
    "?csvType=filtered&country=USA"
  )
  expect_equal(result, expected)
})

test_that("prepare_url adds csvType=filtered for URLs containing 'time'", {
  url <- "https://ourworldindata.org/grapher/time-series-data"
  result <- prepare_url(url)
  expected <- paste0(
    "https://ourworldindata.org/grapher/time-series-data.csv?csvType=filtered"
  )
  expect_equal(result, expected)
})

test_that("prepare_url adds csvType=filtered for URLs containing 'country'", {
  url <- "https://ourworldindata.org/grapher/country-indicators"
  result <- prepare_url(url)
  expected <- paste(
    "https://ourworldindata.org/grapher/country-indicators.csv?csvType=filtered"
  )
  expect_equal(result, expected)
})

test_that("prepare_url handles case insensitivity for 'time' and 'country'", {
  url <- "https://ourworldindata.org/grapher/Time-series"
  result <- prepare_url(url)
  expected <- paste(
    "https://ourworldindata.org/grapher/Time-series.csv?csvType=filtered"
  )
  expect_equal(result, expected)

  url <- "https://ourworldindata.org/grapher/COUNTRY-comparison"
  result <- prepare_url(url)
  expected <- paste(
    "https://ourworldindata.org/grapher/COUNTRY-comparison.csv?csvType=filtered"
  )
  expect_equal(result, expected)
})

test_that("prepare_url doesn't add csvType=filtered twice", {
  url <- "https://ourworldindata.org/grapher/country-data?csvType=filtered"
  result <- prepare_url(url)
  expected <- paste(
    "https://ourworldindata.org/grapher/country-data.csv?csvType=filtered"
  )
  expect_equal(result, expected)
})

test_that("prepare_url handles multiple query parameters", {
  url <- "https://ourworldindata.org/grapher/data?country=USA&time=2020"
  result <- prepare_url(url)
  expected <- paste0(
    "https://ourworldindata.org/grapher/data.csv",
    "?csvType=filtered&country=USA&time=2020"
  )
  expect_equal(result, expected)
})

test_that("prepare_url correctly handles URLs with special characters", {
  url <- "https://ourworldindata.org/grapher/data-with-spaces%20and%20symbols"
  result <- prepare_url(url)
  expected <- paste(
    "https://ourworldindata.org/grapher/data-with-spaces%20and%20symbols.csv"
  )
  expect_equal(result, expected)
})

test_that("prepare_url with both 'time' and existing csvType parameter", {
  url <- paste(
    "https://ourworldindata.org/grapher/data?csvType=filtered&time=2020"
  )
  result <- prepare_url(url)
  expected <- paste(
    "https://ourworldindata.org/grapher/data.csv?csvType=filtered&time=2020"
  )
  expect_equal(result, expected)
})
