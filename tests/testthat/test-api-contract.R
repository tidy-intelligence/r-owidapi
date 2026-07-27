# These tests hit the real OWID API and are the only ones that need an
# internet connection. They are skipped on CRAN so that a change on the OWID
# side can never turn into a CRAN check failure, but they still catch schema
# drift in CI - which is what broke owid_get_catalog() in version 0.1.1.

test_that("the OWID catalog still has the columns we parse", {
  skip_on_cran()
  skip_if_offline()

  catalog <- owid_get_catalog(snake_case = FALSE)

  skip_if(is.null(catalog), "OWID catalog is currently unreachable")

  expect_s3_class(catalog, "tbl_df")
  expect_gt(nrow(catalog), 0)
  expect_true(all(c("slug", "title", "isPublished") %in% names(catalog)))
  expect_type(catalog$isPublished, "logical")
  expect_s3_class(catalog$createdAt, "Date")
})

test_that("owid_get_catalog is not truncated by the Datasette row cap", {
  skip_on_cran()
  skip_if_offline()

  catalog <- owid_get_catalog()

  skip_if(is.null(catalog), "OWID catalog is currently unreachable")

  # Datasette caps `_size=max` at max_returned_rows (1000 here), so landing on
  # exactly that number means the catalog was silently truncated again.
  expect_gt(nrow(catalog), 1000)
  expect_equal(nrow(catalog), length(unique(catalog$id)))

  # Cross-check against the row count Datasette reports for the table.
  count_url <- paste0(
    "https://datasette-public.owid.io/owid/charts.json",
    "?_size=0&_shape=objects"
  )
  reported <- tryCatch(
    httr2::request(count_url) |>
      httr2::req_perform() |>
      httr2::resp_body_json(),
    error = function(e) NULL
  )
  skip_if(is.null(reported), "Datasette row count is currently unreachable")

  # Allow for OWID publishing a chart between the two requests. The failures
  # this guards against - the 1000-row cap, or a response cut short mid-stream
  # - are off by hundreds of rows, not by a handful.
  expect_lt(abs(nrow(catalog) - reported$filtered_table_rows_count), 25)
})

test_that("the OWID chart API still returns the expected columns", {
  skip_on_cran()
  skip_if_offline()

  result <- owid_get("life-expectancy", entities = c("USA", "DEU"))

  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
  expect_true(all(c("entity_name", "entity_id", "year") %in% names(result)))
  expect_setequal(unique(result$entity_id), c("USA", "DEU"))
})

test_that("the OWID metadata API still returns a chart element", {
  skip_on_cran()
  skip_if_offline()

  metadata <- owid_get_metadata("life-expectancy")

  expect_type(metadata, "list")
  expect_false(is.null(metadata$chart))
})
