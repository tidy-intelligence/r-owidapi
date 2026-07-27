# Download data from Our World in Data

Retrieves data from Our World in Data (OWID) by specifying a chart
identifier or direct URL. Allows filtering by entities and time periods.

## Usage

``` r
owid_get(
  chart_id = NULL,
  entities = NULL,
  start_date = NULL,
  end_date = NULL,
  url = NULL,
  use_column_short_names = TRUE,
  snake_case = TRUE
)
```

## Arguments

- chart_id:

  Character string specifying the chart identifier (e.g.,
  "life-expectancy"). Not required if `url` is provided.

- entities:

  Vector of entity codes (e.g., c("USA", "DEU")). If NULL, data for all
  available entities is returned.

- start_date:

  Start date for filtering data. Can be a date string or a year. If
  NULL, starts from the earliest available data.

- end_date:

  End date for filtering data. Can be a date string or a year. If NULL,
  ends with the latest available data.

- url:

  Direct URL to an OWID dataset. If provided, `chart_id` is ignored.

- use_column_short_names:

  Logical. If TRUE (default), uses short column names.

- snake_case:

  Logical. If TRUE (default), converts column names to lowercase.

## Value

A tibble containing the requested OWID data.

## Examples

``` r
# \donttest{
# Download a full table
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

# Download a table only for selected entities
owid_get("life-expectancy", c("AUS", "AUT", "GER"))
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

# Download a table only for selected time periods
owid_get("life-expectancy", c("USA"), 1970, 1980)
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

# Download daily data for selected time periods
owid_get(
 "daily-covid-vaccination-doses-per-capita", "DEU",
 "2020-12-28", "2020-12-31"
)
#> # A tibble: 4 × 4
#>   entity_name entity_id day        daily_vaccinations_smoothed_per_million
#>   <chr>       <chr>     <date>                                       <dbl>
#> 1 Germany     DEU       2020-12-28                                  0.0215
#> 2 Germany     DEU       2020-12-29                                  0.0406
#> 3 Germany     DEU       2020-12-30                                  0.0525
#> 4 Germany     DEU       2020-12-31                                  0.0543

# Download a table by just providing an URL (with or without .csv)
owid_get(
 url = paste0(
   "https://ourworldindata.org/grapher/civil-liberties-score-fh",
   "?tab=chart&time=earliest..2023&country=ARG~AUS~BWA~CHN~ALB~DEU"
 )
)
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
owid_get(
 url = paste0(
   "https://ourworldindata.org/grapher/civil-liberties-score-fh.csv",
   "?tab=chart&time=earliest..2023"
 )
)
#> # A tibble: 4,803 × 5
#>    entity_name entity_id  year civil.liberties.score world.region.according.to…¹
#>    <chr>       <chr>     <int>                 <int> <chr>                      
#>  1 Abkhazia    OWID_ABK   2003                    21 ""                         
#>  2 Abkhazia    OWID_ABK   2004                    21 ""                         
#>  3 Abkhazia    OWID_ABK   2005                    21 ""                         
#>  4 Abkhazia    OWID_ABK   2006                    21 ""                         
#>  5 Abkhazia    OWID_ABK   2007                    21 ""                         
#>  6 Abkhazia    OWID_ABK   2008                    21 ""                         
#>  7 Abkhazia    OWID_ABK   2009                    21 ""                         
#>  8 Abkhazia    OWID_ABK   2010                    22 ""                         
#>  9 Abkhazia    OWID_ABK   2011                    22 ""                         
#> 10 Abkhazia    OWID_ABK   2012                    22 ""                         
#> # ℹ 4,793 more rows
#> # ℹ abbreviated name: ¹​world.region.according.to.owid
# }
```
