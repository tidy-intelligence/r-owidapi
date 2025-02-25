test_that("owid_get_catalog returns expected catalog structure", {
  skip_if_offline()

  result <- owid_get_catalog()

  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("owid_get_catalog handles snake_case", {
  skip_if_offline()

  result <- owid_get_catalog(snake_case = FALSE)

  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})
