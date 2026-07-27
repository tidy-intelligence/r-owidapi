test_that("owid_get_catalog returns expected catalog structure", {
  local_mocked_owid(read_fixture("catalog.csv"))

  result <- owid_get_catalog()

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 3)
  expect_true(all(c("slug", "title", "is_published") %in% names(result)))
})

test_that("owid_get_catalog requests the datasette endpoint", {
  recorder <- local_mocked_owid(read_fixture("catalog.csv"))

  owid_get_catalog()

  expect_length(recorder$urls, 1)
  expect_match(recorder$urls, "datasette-public\\.owid\\.io/owid/charts\\.csv")
  expect_match(recorder$urls, "_size=max")
})

test_that("owid_get_catalog parses logicals and dates", {
  local_mocked_owid(read_fixture("catalog.csv"))

  result <- owid_get_catalog(snake_case = FALSE)

  expect_type(result$isPublished, "logical")
  expect_equal(result$isPublished, c(TRUE, TRUE, FALSE))
  expect_type(result$isInheritanceEnabled, "logical")
  expect_equal(result$forceDatapage, c(FALSE, FALSE, TRUE))

  expect_s3_class(result$createdAt, "Date")
  expect_equal(result$createdAt[[1]], as.Date("2026-07-20"))
  expect_s3_class(result$publishedAt, "Date")
  expect_true(is.na(result$publishedAt[[3]]))
})

test_that("owid_get_catalog handles snake_case", {
  local_mocked_owid(read_fixture("catalog.csv"))

  result <- owid_get_catalog(snake_case = TRUE)
  expect_true(all(c("is_published", "title_plus_variant") %in% names(result)))
  expect_false(any(grepl("[A-Z]", names(result))))

  result_raw <- owid_get_catalog(snake_case = FALSE)
  expect_true("isPublished" %in% names(result_raw))
})

test_that("owid_get_catalog handles request errors gracefully", {
  local_mocked_owid(status_code = 500)

  expect_message(
    result <- owid_get_catalog(),
    regexp = "Failed to retrieve data from Our World in Data\\."
  )
  expect_null(result)
})

test_that("parse_catalog_columns tolerates a changing OWID schema", {
  # Regression test: OWID dropped the `isIndexable` column, which made
  # owid_get_catalog() fail in version 0.1.1.
  without_is_indexable <- data.frame(
    isPublished = c("True", "False"),
    createdAt = c("2026-07-20 18:39:16", "2026-07-21 18:39:16"),
    stringsAsFactors = FALSE
  )

  result <- expect_no_error(parse_catalog_columns(without_is_indexable))
  expect_equal(result$isPublished, c(TRUE, FALSE))
  expect_s3_class(result$createdAt, "Date")
  expect_false("isIndexable" %in% names(result))
})

test_that("parse_catalog_columns still parses columns that reappear", {
  with_is_indexable <- data.frame(
    isIndexable = c("True", "False"),
    publishedAt = c("2026-07-20 18:39:16", ""),
    stringsAsFactors = FALSE
  )

  result <- parse_catalog_columns(with_is_indexable)
  expect_equal(result$isIndexable, c(TRUE, FALSE))
  expect_equal(result$publishedAt, as.Date(c("2026-07-20", NA)))
})

test_that("parse_catalog_columns leaves unknown columns untouched", {
  data <- data.frame(
    slug = "life-expectancy",
    id = 1L,
    stringsAsFactors = FALSE
  )

  expect_equal(parse_catalog_columns(data), data)
})
