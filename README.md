
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
#>    entity_name entity_id  year life_expectancy_0
#>    <chr>       <chr>     <int>             <dbl>
#>  1 Afghanistan AFG        1950              28.2
#>  2 Afghanistan AFG        1951              28.6
#>  3 Afghanistan AFG        1952              29.0
#>  4 Afghanistan AFG        1953              29.5
#>  5 Afghanistan AFG        1954              29.7
#>  6 Afghanistan AFG        1955              30.4
#>  7 Afghanistan AFG        1956              30.8
#>  8 Afghanistan AFG        1957              31.3
#>  9 Afghanistan AFG        1958              31.8
#> 10 Afghanistan AFG        1959              32.3
#> # ℹ 21,555 more rows
```

Get life expectancy data for Australia, Austria, and Germany:

``` r
owid_get("life-expectancy", entities = c("AUS", "AUT", "GER"))
#> # A tibble: 190 × 4
#>    entity_name entity_id  year life_expectancy_0
#>    <chr>       <chr>     <int>             <dbl>
#>  1 Australia   AUS        1885              49.0
#>  2 Australia   AUS        1895              53.0
#>  3 Australia   AUS        1905              57  
#>  4 Australia   AUS        1921              61.0
#>  5 Australia   AUS        1922              62.8
#>  6 Australia   AUS        1923              61.7
#>  7 Australia   AUS        1924              62.5
#>  8 Australia   AUS        1925              63.2
#>  9 Australia   AUS        1926              62.9
#> 10 Australia   AUS        1927              62.8
#> # ℹ 180 more rows
```

Download US life expectancy data from 1970 to 1980:

``` r
owid_get(
  "life-expectancy",
  entities = "USA",
  start_date = 1970,
  end_date = 1980
)
#> # A tibble: 11 × 4
#>    entity_name   entity_id  year life_expectancy_0
#>    <chr>         <chr>     <int>             <dbl>
#>  1 United States USA        1970              70.7
#>  2 United States USA        1971              71.1
#>  3 United States USA        1972              71.2
#>  4 United States USA        1973              71.4
#>  5 United States USA        1974              72.0
#>  6 United States USA        1975              72.5
#>  7 United States USA        1976              72.8
#>  8 United States USA        1977              73.2
#>  9 United States USA        1978              73.4
#> 10 United States USA        1979              73.8
#> 11 United States USA        1980              73.7
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
#> # A tibble: 126 × 5
#>    entity_name entity_id  year civil.liberties.score world.region.according.to…¹
#>    <chr>       <chr>     <int>                 <int> <chr>                      
#>  1 Albania     ALB        2003                    42 Europe                     
#>  2 Albania     ALB        2004                    40 Europe                     
#>  3 Albania     ALB        2005                    38 Europe                     
#>  4 Albania     ALB        2006                    38 Europe                     
#>  5 Albania     ALB        2007                    39 Europe                     
#>  6 Albania     ALB        2008                    40 Europe                     
#>  7 Albania     ALB        2009                    39 Europe                     
#>  8 Albania     ALB        2010                    40 Europe                     
#>  9 Albania     ALB        2011                    39 Europe                     
#> 10 Albania     ALB        2012                    39 Europe                     
#> # ℹ 116 more rows
#> # ℹ abbreviated name: ¹​world.region.according.to.owid
```

You can get metadata as a list by either provoding the data set name or
URL.

``` r
metadata <- owid_get_metadata("civil-liberties-score-fh")
metadata_url <- owid_get_metadata(url = url)
str(metadata)
#> List of 3
#>  $ chart         :List of 5
#>   ..$ title           : chr "Civil Liberties Score"
#>   ..$ subtitle        : chr "Data by Freedom House. The score captures the extent of freedom of expression and association, the rule of law,"| __truncated__
#>   ..$ citation        : chr "Freedom House (2026)"
#>   ..$ originalChartUrl: chr "https://ourworldindata.org/grapher/civil-liberties-score-fh"
#>   ..$ selection       :List of 4
#>   .. ..$ : chr "Argentina"
#>   .. ..$ : chr "Australia"
#>   .. ..$ : chr "Botswana"
#>   .. ..$ : chr "China"
#>  $ columns       :List of 2
#>   ..$ Civil liberties score         :List of 13
#>   .. ..$ titleShort      : chr "Civil liberties score"
#>   .. ..$ titleLong       : chr "Civil liberties score"
#>   .. ..$ descriptionShort: chr "The variable identifies the fine-grained extent of freedom of expression and association, the rule of law, and "| __truncated__
#>   .. ..$ unit            : chr ""
#>   .. ..$ timespan        : chr "2003-2025"
#>   .. ..$ type            : chr "Integer"
#>   .. ..$ owidVariableId  : int 1210109
#>   .. ..$ shortName       : chr "civlibs_score"
#>   .. ..$ lastUpdated     : chr "2026-03-23"
#>   .. ..$ nextUpdate      : chr "2027-03-23"
#>   .. ..$ citationShort   : chr "Freedom House (2026) – processed by Our World in Data"
#>   .. ..$ citationLong    : chr "Freedom House (2026) – processed by Our World in Data. “Civil liberties score” [dataset]. Freedom House, “Freed"| __truncated__
#>   .. ..$ fullMetadata    : chr "https://api.ourworldindata.org/v1/indicators/1210109.metadata.json"
#>   ..$ World region according to OWID:List of 12
#>   .. ..$ titleShort      : chr "World region according to OWID"
#>   .. ..$ titleLong       : chr "World region according to OWID"
#>   .. ..$ descriptionShort: chr "Regions defined by Our World in Data, which are used in OWID charts and maps."
#>   .. ..$ unit            : chr ""
#>   .. ..$ timespan        : chr "2023-2023"
#>   .. ..$ type            : chr "Continent"
#>   .. ..$ owidVariableId  : int 900801
#>   .. ..$ shortName       : chr "owid_region"
#>   .. ..$ lastUpdated     : chr "2023-01-01"
#>   .. ..$ citationShort   : chr "Our World in Data – processed by Our World in Data"
#>   .. ..$ citationLong    : chr "Our World in Data – processed by Our World in Data. “World region according to OWID” [dataset]. Our World in Da"| __truncated__
#>   .. ..$ fullMetadata    : chr "https://api.ourworldindata.org/v1/indicators/900801.metadata.json"
#>  $ dateDownloaded: chr "2026-07-27"
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
#> # A tibble: 4,458 × 17
#>    rowid    id config_id        is_inheritance_enabled force_datapage created_at
#>    <int> <int> <chr>            <lgl>                  <lgl>          <date>    
#>  1  3973  9219 019f80d3-3f2b-7… TRUE                   FALSE          2026-07-20
#>  2  2875  9216 019f665e-c39b-7… FALSE                  FALSE          2026-07-15
#>  3  2417  9214 019f6508-98e7-7… FALSE                  FALSE          2026-07-15
#>  4  4143  9177 019ee12a-5aeb-7… TRUE                   FALSE          2026-06-19
#>  5  4142  9176 019ee12a-5952-7… TRUE                   FALSE          2026-06-19
#>  6  2385  9157 019eda63-9d51-7… TRUE                   FALSE          2026-06-18
#>  7  2205  9137 019e68bc-1945-7… TRUE                   FALSE          2026-05-27
#>  8  4131  9123 019e4623-a4a5-7… TRUE                   FALSE          2026-05-20
#>  9  4128  9122 019e4622-9161-7… TRUE                   FALSE          2026-05-20
#> 10  4129  9121 019e4622-8fe3-7… TRUE                   FALSE          2026-05-20
#> # ℹ 4,448 more rows
#> # ℹ 11 more variables: updated_at <date>, last_edited_at <date>,
#> #   published_at <date>, config <chr>, slug <chr>, type <chr>, title <chr>,
#> #   subtitle <chr>, note <chr>, title_plus_variant <chr>, is_published <lgl>
```

To search for keywords in the catalog, you can use the following helper:

``` r
owid_search(catalog, c("climate", "carbon"))
#> # A tibble: 205 × 17
#>    rowid    id config_id        is_inheritance_enabled force_datapage created_at
#>    <int> <int> <chr>            <lgl>                  <lgl>          <date>    
#>  1  2384  9058 019cc336-627f-7… TRUE                   FALSE          2026-03-06
#>  2  4348  8968 019b09ed-a018-7… TRUE                   FALSE          2025-12-10
#>  3  4347  8509 01950523-a967-7… TRUE                   FALSE          2025-02-14
#>  4  4346  8508 01950523-a857-7… TRUE                   FALSE          2025-02-14
#>  5  3187  8472 0194b2a8-e036-7… FALSE                  FALSE          2025-01-29
#>  6  3225  8222 0192d85f-7e6f-7… FALSE                  FALSE          2024-10-29
#>  7  4419  8032 0191c217-8b0d-7… TRUE                   FALSE          2024-09-05
#>  8  4418  8031 0191c217-8a17-7… TRUE                   FALSE          2024-09-05
#>  9  4417  8030 0191c217-8916-7… TRUE                   FALSE          2024-09-05
#> 10  4416  8029 0191c217-8831-7… TRUE                   FALSE          2024-09-05
#> # ℹ 195 more rows
#> # ℹ 11 more variables: updated_at <date>, last_edited_at <date>,
#> #   published_at <date>, config <chr>, slug <chr>, type <chr>, title <chr>,
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
