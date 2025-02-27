
<!-- README.md is generated from README.Rmd. Please edit that file -->

# owidapi

<!-- badges: start -->

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

You can install `wbwdi` from CRAN via:

``` r
install.packages("owidapi")
```

You can install the development version of `owidapi` from GitHub with:

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
#> # A tibble: 114 × 4
#>    entity_name entity_id  year civil.liberties.score
#>    <chr>       <chr>     <int>                 <int>
#>  1 Albania     ALB        2005                    38
#>  2 Albania     ALB        2006                    38
#>  3 Albania     ALB        2007                    39
#>  4 Albania     ALB        2008                    40
#>  5 Albania     ALB        2009                    39
#>  6 Albania     ALB        2010                    40
#>  7 Albania     ALB        2011                    39
#>  8 Albania     ALB        2012                    39
#>  9 Albania     ALB        2013                    40
#> 10 Albania     ALB        2014                    40
#> # ℹ 104 more rows
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
#>   ..$ citation        : chr "Freedom House (2024)"
#>   ..$ originalChartUrl: chr "https://ourworldindata.org/grapher/civil-liberties-score-fh"
#>   ..$ selection       :List of 4
#>   .. ..$ : chr "Argentina"
#>   .. ..$ : chr "Australia"
#>   .. ..$ : chr "Botswana"
#>   .. ..$ : chr "China"
#>  $ columns       :List of 1
#>   ..$ Civil liberties score:List of 14
#>   .. ..$ titleShort      : chr "Civil liberties score"
#>   .. ..$ titleLong       : chr "Civil liberties score"
#>   .. ..$ descriptionShort: chr "The variable identifies the fine-grained extent of freedom of expression and association, the rule of law, and "| __truncated__
#>   .. ..$ descriptionKey  : list()
#>   .. ..$ unit            : chr ""
#>   .. ..$ timespan        : chr "2005-2023"
#>   .. ..$ type            : chr "Integer"
#>   .. ..$ owidVariableId  : int 901305
#>   .. ..$ shortName       : chr "civlibs_score_fh"
#>   .. ..$ lastUpdated     : chr "2024-05-16"
#>   .. ..$ nextUpdate      : chr "2025-05-16"
#>   .. ..$ citationShort   : chr "Freedom House (2024) – processed by Our World in Data"
#>   .. ..$ citationLong    : chr "Freedom House (2024) – processed by Our World in Data. “Civil liberties score” [dataset]. Freedom House, “Freed"| __truncated__
#>   .. ..$ fullMetadata    : chr "https://api.ourworldindata.org/v1/indicators/901305.metadata.json"
#>  $ dateDownloaded: chr "2025-02-27"
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
#> # A tibble: 5,012 × 18
#>       id slug     type  config created_at updated_at last_edited_at published_at
#>    <int> <chr>    <chr> <chr>  <chr>      <chr>      <chr>          <chr>       
#>  1  7968 militar… Line… "{\"i… 2024-07-3… 2024-07-3… 2024-07-31 08… "2024-07-30…
#>  2  7967 militar… Line… "{\"i… 2024-07-3… 2024-07-3… 2024-07-30 12… ""          
#>  3  7966 militar… Line… "{\"i… 2024-07-3… 2024-07-3… 2024-07-30 12… ""          
#>  4  7965 militar… Line… "{\"i… 2024-07-3… 2024-07-3… 2024-07-31 08… "2024-07-30…
#>  5  7964 militar… Line… "{\"i… 2024-07-3… 2024-07-3… 2024-07-31 10… "2024-07-30…
#>  6  7963 relativ… Stac… "{\"i… 2024-07-2… 2024-07-2… 2024-07-29 15… ""          
#>  7  7962 tree-co… Stac… "{\"i… 2024-07-2… 2024-07-2… 2024-07-29 15… ""          
#>  8  7961 hdi-lan… Line… "{\"i… 2024-07-2… 2024-07-2… 2024-07-28 15… "2024-07-28…
#>  9  7960 hdi-per… Scat… "{\"i… 2024-07-2… 2024-07-2… 2024-07-28 13… "2024-07-28…
#> 10  7959 are-con… Line… "{\"i… 2024-07-2… 2024-07-2… 2024-07-28 12… ""          
#> # ℹ 5,002 more rows
#> # ℹ 10 more variables: last_edited_by_user_id <int>,
#> #   last_edited_by_user_id_label <chr>, published_by_user_id <int>,
#> #   published_by_user_id_label <chr>, is_indexable <int>, title <chr>,
#> #   subtitle <chr>, note <chr>, title_plus_variant <chr>,
#> #   config_with_defaults <chr>
```

To search for keywords in the catalog, you can use the following helper:

``` r
owid_search(catalog, c("climate", "carbon"))
#> # A tibble: 210 × 18
#>       id slug     type  config created_at updated_at last_edited_at published_at
#>    <int> <chr>    <chr> <chr>  <chr>      <chr>      <chr>          <chr>       
#>  1  7953 hdi-vs-… Line… "{\"i… 2024-07-2… 2024-07-2… 2024-07-28 13… "2024-07-26…
#>  2  7947 low-car… Scat… "{\"i… 2024-07-2… 2024-07-2… 2024-07-22 10… "2024-07-22…
#>  3  7943 tempera… Scat… "{\"i… 2024-07-1… 2024-07-1… 2024-07-19 08… ""          
#>  4  7926 global-… Stac… "{\"i… 2024-07-0… 2024-07-1… 2024-07-19 09… "2024-07-03…
#>  5  7925 spring-… Stac… "{\"i… 2024-07-0… 2024-07-0… 2024-07-05 08… "2024-07-03…
#>  6  7924 autumn-… Stac… "{\"i… 2024-07-0… 2024-07-0… 2024-07-05 08… "2024-07-03…
#>  7  7923 winter-… Stac… "{\"i… 2024-07-0… 2024-07-0… 2024-07-05 08… "2024-07-03…
#>  8  7922 summer-… Stac… "{\"i… 2024-07-0… 2024-07-0… 2024-07-05 08… "2024-07-03…
#>  9  7921 country… Stac… "{\"i… 2024-07-0… 2024-07-1… 2024-07-10 10… "2024-07-03…
#> 10  7917 materia… Stac… "{\"i… 2024-07-0… 2024-07-2… 2024-07-24 11… "2024-07-14…
#> # ℹ 200 more rows
#> # ℹ 10 more variables: last_edited_by_user_id <int>,
#> #   last_edited_by_user_id_label <chr>, published_by_user_id <int>,
#> #   published_by_user_id_label <chr>, is_indexable <int>, title <chr>,
#> #   subtitle <chr>, note <chr>, title_plus_variant <chr>,
#> #   config_with_defaults <chr>
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
