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
