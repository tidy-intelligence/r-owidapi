test_that("owid_embed generates correct iframe HTML", {
  url <- "https://ourworldindata.org/grapher/co2-emissions-per-capita"
  result <- owid_embed(url)

  expected <- paste0(
    '<iframe src="',
    url,
    '" ',
    'loading="lazy" ',
    'style="width: 100%; height: 600px; border: 0px none;" ',
    'allow="web-share; clipboard-write"></iframe>'
  )

  expect_equal(result, expected)
})

test_that("owid_embed allows custom width and height", {
  url <- "https://ourworldindata.org/grapher/co2-emissions-per-capita"
  result <- owid_embed(url, width = "90%", height = "500px")

  expected <- paste0(
    '<iframe src="',
    url,
    '" ',
    'loading="lazy" ',
    'style="width: 90%; height: 500px; border: 0px none;" ',
    'allow="web-share; clipboard-write"></iframe>'
  )

  expect_equal(result, expected)
})

test_that("owid_embed rejects invalid URLs", {
  invalid_url <- "https://example.com/invalid-graph"

  expect_error(
    owid_embed(invalid_url),
    "URL must be from Our World in Data"
  )
})

test_that("owid_embed works with different graph URLs", {
  url <- "https://ourworldindata.org/grapher/gdp-per-capita"
  result <- owid_embed(url)

  expected <- paste0(
    '<iframe src="',
    url,
    '" ',
    'loading="lazy" ',
    'style="width: 100%; height: 600px; border: 0px none;" ',
    'allow="web-share; clipboard-write"></iframe>'
  )

  expect_equal(result, expected)
})
