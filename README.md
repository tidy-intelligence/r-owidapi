
<!-- README.md is generated from README.Rmd. Please edit that file -->

# owidapi

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/owidapi)](https://cran.r-project.org/package=owidapi)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/owidapi)](https://cran.r-project.org/package=owidapi)
![R CMD
Check](https://github.com/tidy-intelligence/r-owidapi/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/r-owidapi/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/r-owidapi/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/r-owidapi)
<!-- badges: end -->

Retrieve data from the Our World in Data (OWID) [Chart
API](https://docs.owid.io/projects/etl/api/). OWID provides public
access to more than 5,000 charts focusing on global problems such as
poverty, disease, hunger, climate change, war, existential risks, and
inequality.

The package is part of the
[econdataverse](https://www.econdataverse.org/) family of packages aimed
at helping economists and financial professionals work with
sovereign-level economic data.

> 💡 The ETL Catalog API is currently in beta and relies on internal
> APIs that change on a regular basis. Once the API is stable, it is
> planned to be included in this package.

## Installation

You can install `owidapi` from
[CRAN](https://cran.r-project.org/package=owidapi) via:

``` r
install.packages("owidapi")
```

You can install the development version of `owidapi` from
[GitHub](https://github.com/tidy-intelligence/r-owidapi) with:

``` r
# install.packages("pak")
pak::pak("tidy-intelligence/r-owidapi")
```

## Usage

Load the package:

``` r
library(owidapi)
```

Download the full life expectancy dataset:

``` r
owid_get("life-expectancy")
#> # A tibble: 21,565 × 4
#>    entity_name entity_id  year life_expectancy_0__sex_total__age_0
#>    <chr>       <chr>     <int>                               <dbl>
#>  1 Afghanistan AFG        1950                                28.2
#>  2 Afghanistan AFG        1951                                28.6
#>  3 Afghanistan AFG        1952                                29.0
#>  4 Afghanistan AFG        1953                                29.5
#>  5 Afghanistan AFG        1954                                29.7
#>  6 Afghanistan AFG        1955                                30.4
#>  7 Afghanistan AFG        1956                                30.8
#>  8 Afghanistan AFG        1957                                31.3
#>  9 Afghanistan AFG        1958                                31.8
#> 10 Afghanistan AFG        1959                                32.3
#> # ℹ 21,555 more rows
```

Get life expectancy data for Australia, Austria, and Germany:

``` r
owid_get("life-expectancy", entities = c("AUS", "AUT", "GER"))
#> # A tibble: 190 × 4
#>    entity_name entity_id  year life_expectancy_0__sex_total__age_0
#>    <chr>       <chr>     <int>                               <dbl>
#>  1 Australia   AUS        1885                                49.0
#>  2 Australia   AUS        1895                                53.0
#>  3 Australia   AUS        1905                                57  
#>  4 Australia   AUS        1921                                61.0
#>  5 Australia   AUS        1922                                62.8
#>  6 Australia   AUS        1923                                61.7
#>  7 Australia   AUS        1924                                62.5
#>  8 Australia   AUS        1925                                63.2
#>  9 Australia   AUS        1926                                62.9
#> 10 Australia   AUS        1927                                62.8
#> # ℹ 180 more rows
```

Download US life expectancy data from 1970 to 1980:

``` r
owid_get("life-expectancy", entities = "USA", start_date = 1970, end_date = 1980)
#> # A tibble: 11 × 4
#>    entity_name   entity_id  year life_expectancy_0__sex_total__age_0
#>    <chr>         <chr>     <int>                               <dbl>
#>  1 United States USA        1970                                70.7
#>  2 United States USA        1971                                71.1
#>  3 United States USA        1972                                71.2
#>  4 United States USA        1973                                71.4
#>  5 United States USA        1974                                72.0
#>  6 United States USA        1975                                72.5
#>  7 United States USA        1976                                72.8
#>  8 United States USA        1977                                73.2
#>  9 United States USA        1978                                73.4
#> 10 United States USA        1979                                73.8
#> 11 United States USA        1980                                73.7
```

Get daily COVID-19 vaccination doses per capita for Germany between
2020-12-28 and 2020-12-31:

``` r
owid_get(
  "daily-covid-vaccination-doses-per-capita",
  entities = "DEU",
  start_date = "2020-12-28",
  end_date = "2020-12-31"
)
#> # A tibble: 4 × 4
#>   entity_name entity_id day        daily_vaccinations_smoothed_per_million
#>   <chr>       <chr>     <date>                                       <dbl>
#> 1 Germany     DEU       2020-12-28                                  0.0215
#> 2 Germany     DEU       2020-12-29                                  0.0406
#> 3 Germany     DEU       2020-12-30                                  0.0525
#> 4 Germany     DEU       2020-12-31                                  0.0543
```

Download data directly using an URL from the website:

``` r
url <- paste0(
  "https://ourworldindata.org/grapher/civil-liberties-score-fh",
  "?tab=chart&time=earliest..2023&country=ARG~AUS~BWA~CHN~ALB~DEU"
)
owid_get(url = url)
#> # A tibble: 126 × 4
#>    entity_name entity_id  year civil.liberties.score
#>    <chr>       <chr>     <int>                 <int>
#>  1 Albania     ALB        2003                    42
#>  2 Albania     ALB        2004                    40
#>  3 Albania     ALB        2005                    38
#>  4 Albania     ALB        2006                    38
#>  5 Albania     ALB        2007                    39
#>  6 Albania     ALB        2008                    40
#>  7 Albania     ALB        2009                    39
#>  8 Albania     ALB        2010                    40
#>  9 Albania     ALB        2011                    39
#> 10 Albania     ALB        2012                    39
#> # ℹ 116 more rows
```

You can get metadata as a list by either provoding the data set name or
URL.

``` r
metadata <- owid_get_metadata("civil-liberties-score-fh")
metadata_url <- owid_get_metadata(url = url)
str(metadata)
#> List of 3
#>  $ chart         :List of 5
#>   ..$ title           : chr "Civil liberties score"
#>   ..$ subtitle        : chr "Based on the estimates and scoring by [Freedom House (2024)](#dod:freedom-house). It captures the extent of fre"| __truncated__
#>   ..$ citation        : chr "Freedom House (2025)"
#>   ..$ originalChartUrl: chr "https://ourworldindata.org/grapher/civil-liberties-score-fh"
#>   ..$ selection       :List of 4
#>   .. ..$ : chr "Argentina"
#>   .. ..$ : chr "Australia"
#>   .. ..$ : chr "Botswana"
#>   .. ..$ : chr "China"
#>  $ columns       :List of 1
#>   ..$ Civil liberties score:List of 13
#>   .. ..$ titleShort      : chr "Civil liberties score"
#>   .. ..$ titleLong       : chr "Civil liberties score"
#>   .. ..$ descriptionShort: chr "The variable identifies the fine-grained extent of freedom of expression and association, the rule of law, and "| __truncated__
#>   .. ..$ unit            : chr ""
#>   .. ..$ timespan        : chr "2003-2024"
#>   .. ..$ type            : chr "Integer"
#>   .. ..$ owidVariableId  : int 1039982
#>   .. ..$ shortName       : chr "civlibs_score"
#>   .. ..$ lastUpdated     : chr "2025-06-02"
#>   .. ..$ nextUpdate      : chr "2026-06-02"
#>   .. ..$ citationShort   : chr "Freedom House (2025) – processed by Our World in Data"
#>   .. ..$ citationLong    : chr "Freedom House (2025) – processed by Our World in Data. “Civil liberties score” [dataset]. Freedom House, “Freed"| __truncated__
#>   .. ..$ fullMetadata    : chr "https://api.ourworldindata.org/v1/indicators/1039982.metadata.json"
#>  $ dateDownloaded: chr "2025-06-23"
```

The only difference is in the `originalChartUrl` value:

``` r
all.equal(metadata, metadata_url)
#> [1] "Length mismatch: comparison on first 3 components"                     
#> [2] "Component \"chart\": Component \"originalChartUrl\": 1 string mismatch"
```

If you want to fetch the full catalog of available charts:

``` r
catalog <- owid_get_catalog()
catalog
#> # A tibble: 5,301 × 19
#>    rowid    id config_id            is_inheritance_enabled created_at updated_at
#>    <int> <int> <chr>                <lgl>                  <date>     <date>    
#>  1    26  8727 01978d86-beee-7595-… TRUE                   2025-06-20 2025-06-21
#>  2    25  8726 01978cf4-6363-7356-… FALSE                  2025-06-20 2025-06-21
#>  3    24  8725 01978ce6-0056-70d1-… TRUE                   2025-06-20 2025-06-21
#>  4    23  8724 01978c7e-4996-7d83-… TRUE                   2025-06-20 2025-06-21
#>  5    22  8723 01978878-d5b8-78c0-… FALSE                  2025-06-19 2025-06-19
#>  6    21  8722 01978873-eaf5-75c0-… FALSE                  2025-06-19 2025-06-19
#>  7    20  8721 019787a1-5f3e-7001-… FALSE                  2025-06-19 NA        
#>  8    19  8720 019782bc-b4ad-71d2-… TRUE                   2025-06-18 NA        
#>  9    18  8719 019781f9-87c8-7f47-… FALSE                  2025-06-18 2025-06-18
#> 10    17  8718 019781ec-db06-7b85-… TRUE                   2025-06-18 2025-06-18
#> # ℹ 5,291 more rows
#> # ℹ 13 more variables: last_edited_at <date>, published_at <date>,
#> #   last_edited_by_user_id <int>, published_by_user_id <int>,
#> #   is_indexable <lgl>, config <chr>, slug <chr>, type <chr>, title <chr>,
#> #   subtitle <chr>, note <chr>, title_plus_variant <chr>, is_published <lgl>
```

To search for keywords in the catalog, you can use the following helper:

``` r
owid_search(catalog, c("climate", "carbon"))
#> # A tibble: 206 × 19
#>    rowid    id config_id            is_inheritance_enabled created_at updated_at
#>    <int> <int> <chr>                <lgl>                  <date>     <date>    
#>  1  5166  8555 0195a9ea-1bb2-7af4-… FALSE                  2025-03-18 2025-03-18
#>  2  5131  8509 01950523-a967-7c01-… TRUE                   2025-02-14 2025-03-23
#>  3  5130  8508 01950523-a857-72c1-… TRUE                   2025-02-14 2025-03-23
#>  4  5105  8472 0194b2a8-e036-7c09-… FALSE                  2025-01-29 2025-04-07
#>  5  4900  8266 01933e25-e0bc-70e5-… FALSE                  2024-11-18 2024-11-22
#>  6  4869  8222 0192d85f-7e6f-7cbb-… FALSE                  2024-10-29 2025-04-07
#>  7  5059  8032 0191c217-8b0d-7612-… TRUE                   2024-09-05 2025-05-26
#>  8  5058  8031 0191c217-8a17-7cd8-… TRUE                   2024-09-05 2025-05-26
#>  9  5057  8030 0191c217-8916-71c6-… TRUE                   2024-09-05 2025-05-26
#> 10  5056  8029 0191c217-8831-7fc9-… TRUE                   2024-09-05 2025-05-26
#> # ℹ 196 more rows
#> # ℹ 13 more variables: last_edited_at <date>, published_at <date>,
#> #   last_edited_by_user_id <int>, published_by_user_id <int>,
#> #   is_indexable <lgl>, config <chr>, slug <chr>, type <chr>, title <chr>,
#> #   subtitle <chr>, note <chr>, title_plus_variant <chr>, is_published <lgl>
```

There are also a few experimental functions to embed OWID charts. For
instance, you can create the HTML to embed a chart:

``` r
owid_embed(url)
#> [1] "<iframe src=\"https://ourworldindata.org/grapher/civil-liberties-score-fh?tab=chart&time=earliest..2023&country=ARG~AUS~BWA~CHN~ALB~DEU\" loading=\"lazy\" style=\"width: 100%; height: 600px; border: 0px none;\" allow=\"web-share; clipboard-write\"></iframe>"
```

If you want to render embedded OWID charts in a Shiny app, you can use
`owid_output()` and `owid_server()`:

``` r
library(shiny)

ui <- fluidPage(
 owid_output("co2_chart")
)

server <- function(input, output) {
 owid_server(
   "co2_chart", 
   "https://ourworldindata.org/grapher/co2-emissions-per-capita"
  )
}

shinyApp(ui = ui, server = server)
```

## Relation to Existing Packages

The [`owidR`](https://github.com/piersyork/owidR) package is broken
since Our World in Data updated the API, has not received a commit since
November 2023, and uses a different set of dependencies (e.g.,
`data.table`, `httr`, `rvest`).
