test_data <- data.frame(
  title = c(
    "Climate Change",
    "Carbon Emissions",
    "Global Warming",
    "Economic Growth"
  ),
  description = c(
    "Data about climate.",
    "Emissions data.",
    "Warming trends.",
    "GDP statistics."
  ),
  category = factor(c("Environment", "Environment", "Environment", "Economy")),
  stringsAsFactors = FALSE
)

test_that("Search finds matching rows across all text columns", {
  result <- owid_search(test_data, c("climate", "carbon"))
  expect_equal(nrow(result), 2)
  expect_true(all(result$title %in% c("Climate Change", "Carbon Emissions")))
})

test_that("Search within specific column works", {
  result <- owid_search(test_data, c("climate"), columns = c("title"))
  expect_equal(nrow(result), 1)
  expect_equal(result$title, "Climate Change")
})

test_that("Search is case-insensitive", {
  result <- owid_search(test_data, c("CLIMATE"))
  expect_equal(nrow(result), 1)
  expect_equal(result$title, "Climate Change")
})

test_that("Search returns empty data frame if no matches", {
  result <- owid_search(test_data, c("biodiversity"))
  expect_equal(nrow(result), 0)
})

test_that("Function throws error for non-data frame input", {
  expect_error(
    owid_search(
      list(a = 1),
      c("climate")
    ),
    "Input 'data' must be a data frame"
  )
})

test_that("Function throws error for invalid keywords", {
  expect_error(
    owid_search(test_data, NULL),
    "'keywords' must be a non-empty character vector"
  )
  expect_error(
    owid_search(test_data, 123),
    "'keywords' must be a non-empty character vector"
  )
})

test_that("Function throws error for non-existent columns", {
  expect_error(
    owid_search(
      test_data,
      c("climate"),
      columns = c("nonexistent")
    ),
    "Some specified columns do not exist in the data"
  )
})

test_that("Search works with factor columns", {
  result <- owid_search(test_data, c("environment"), columns = c("category"))
  expect_equal(nrow(result), 3)
  expect_true(all(result$category == "Environment"))
})
