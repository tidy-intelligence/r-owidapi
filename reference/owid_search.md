# Search for keywords in OWID catalog data

This function searches for a vector of keywords within specified columns
of an OWID catalog data frame. If no columns are specified, it searches
all character and factor columns.

## Usage

``` r
owid_search(data, keywords, columns = NULL)
```

## Arguments

- data:

  A data frame, typically obtained from
  [owid_get_catalog](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get_catalog.md).

- keywords:

  A character vector of one or more keywords to search for. The search
  is case-insensitive.

- columns:

  An optional character vector of column names to search within. If NULL
  (default), all character and factor columns are searched.

## Value

A filtered data frame containing only rows that match at least one of
the keywords in at least one of the specified columns.

## Examples

``` r
# \donttest{
# Get the OWID catalog
catalog <- owid_get_catalog()

# owid_get_catalog() returns NULL if the API is unreachable
if (!is.null(catalog)) {
  # Search for climate or carbon in all text columns
  print(owid_search(catalog, c("climate", "carbon")))

  # Search only in the title column
  print(owid_search(catalog, c("climate", "carbon"), c("title")))
}
#> # A tibble: 205 × 17
#>    rowid    id config_id        is_inheritance_enabled force_datapage created_at
#>    <int> <int> <chr>            <lgl>                  <lgl>          <date>    
#>  1   498   488 0191b6c7-37aa-7… TRUE                   FALSE          2017-04-07
#>  2   500   530 0191b6c7-37ce-7… TRUE                   FALSE          2017-04-19
#>  3   657   784 0191b6c7-38c5-7… FALSE                  FALSE          2017-07-22
#>  4   163  1108 0191b6c7-3a46-7… FALSE                  FALSE          2017-09-08
#>  5   165  1129 0191b6c7-3a55-7… FALSE                  FALSE          2017-09-10
#>  6   710  1277 0191b6c7-3aeb-7… FALSE                  FALSE          2017-10-05
#>  7    76  1362 0191b6c7-3b27-7… FALSE                  FALSE          2017-10-14
#>  8   161  1366 0191b6c7-3b2a-7… FALSE                  FALSE          2017-10-15
#>  9   448  1421 0191b6c7-3b5f-7… FALSE                  FALSE          2017-10-23
#> 10  2014  2245 0191b6c7-3e77-7… FALSE                  FALSE          2018-02-20
#> # ℹ 195 more rows
#> # ℹ 11 more variables: updated_at <date>, last_edited_at <date>,
#> #   published_at <date>, config <chr>, slug <chr>, type <chr>, title <chr>,
#> #   subtitle <chr>, note <chr>, title_plus_variant <chr>, is_published <lgl>
#> # A tibble: 47 × 17
#>    rowid    id config_id        is_inheritance_enabled force_datapage created_at
#>    <int> <int> <chr>            <lgl>                  <lgl>          <date>    
#>  1   500   530 0191b6c7-37ce-7… TRUE                   FALSE          2017-04-19
#>  2   657   784 0191b6c7-38c5-7… FALSE                  FALSE          2017-07-22
#>  3   161  1366 0191b6c7-3b2a-7… FALSE                  FALSE          2017-10-15
#>  4  1345  2823 0191b6c7-4123-7… FALSE                  FALSE          2018-06-25
#>  5  2672  3302 0191b6c7-4367-7… FALSE                  FALSE          2019-02-03
#>  6  2689  4135 0191b6c7-4716-7… FALSE                  FALSE          2020-04-17
#>  7  2267  4267 0191b6c7-4782-7… TRUE                   FALSE          2020-07-01
#>  8  1262  4303 0191b6c7-47a5-7… FALSE                  FALSE          2020-07-12
#>  9  1264  4305 0191b6c7-47a7-7… FALSE                  FALSE          2020-07-12
#> 10  2080  4315 0191b6c7-47b1-7… FALSE                  FALSE          2020-07-18
#> # ℹ 37 more rows
#> # ℹ 11 more variables: updated_at <date>, last_edited_at <date>,
#> #   published_at <date>, config <chr>, slug <chr>, type <chr>, title <chr>,
#> #   subtitle <chr>, note <chr>, title_plus_variant <chr>, is_published <lgl>
# }
```
