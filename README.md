
<!-- README.md is generated from README.Rmd. Please edit that file -->

# owidapi

<!-- badges: start -->
<!-- badges: end -->

Retrieve datasets from Our World in Data (OWID) [Chart API and ETL
Catalog API](https://docs.owid.io/projects/etl/api/).

## Installation

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
#>    entity      code   year life_expectancy_0__sex_total__age_0
#>    <chr>       <chr> <int>                               <dbl>
#>  1 Afghanistan AFG    1950                                28.2
#>  2 Afghanistan AFG    1951                                28.6
#>  3 Afghanistan AFG    1952                                29.0
#>  4 Afghanistan AFG    1953                                29.5
#>  5 Afghanistan AFG    1954                                29.7
#>  6 Afghanistan AFG    1955                                30.4
#>  7 Afghanistan AFG    1956                                30.8
#>  8 Afghanistan AFG    1957                                31.3
#>  9 Afghanistan AFG    1958                                31.8
#> 10 Afghanistan AFG    1959                                32.3
#> # ℹ 21,555 more rows
```

Get life expectancy data for Australia, Austria, and Germany:

``` r
owid_get("life-expectancy", entities = c("AUS", "AUT", "GER"))
#> # A tibble: 190 × 4
#>    entity    code   year life_expectancy_0__sex_total__age_0
#>    <chr>     <chr> <int>                               <dbl>
#>  1 Australia AUS    1885                                49.0
#>  2 Australia AUS    1895                                53.0
#>  3 Australia AUS    1905                                57  
#>  4 Australia AUS    1921                                61.0
#>  5 Australia AUS    1922                                62.8
#>  6 Australia AUS    1923                                61.7
#>  7 Australia AUS    1924                                62.5
#>  8 Australia AUS    1925                                63.2
#>  9 Australia AUS    1926                                62.9
#> 10 Australia AUS    1927                                62.8
#> # ℹ 180 more rows
```

Download US life expectancy data from 1970 to 1980:

``` r
owid_get("life-expectancy", entities = "USA", start_date = 1970, end_date = 1980)
#> # A tibble: 11 × 4
#>    entity        code   year life_expectancy_0__sex_total__age_0
#>    <chr>         <chr> <int>                               <dbl>
#>  1 United States USA    1970                                70.7
#>  2 United States USA    1971                                71.1
#>  3 United States USA    1972                                71.2
#>  4 United States USA    1973                                71.4
#>  5 United States USA    1974                                72.0
#>  6 United States USA    1975                                72.5
#>  7 United States USA    1976                                72.8
#>  8 United States USA    1977                                73.2
#>  9 United States USA    1978                                73.4
#> 10 United States USA    1979                                73.8
#> 11 United States USA    1980                                73.7
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
#>   entity  code  day        daily_vaccinations_smoothed_per_million
#>   <chr>   <chr> <chr>                                        <dbl>
#> 1 Germany DEU   2020-12-28                                  0.0215
#> 2 Germany DEU   2020-12-29                                  0.0406
#> 3 Germany DEU   2020-12-30                                  0.0525
#> 4 Germany DEU   2020-12-31                                  0.0543
```

Download data directly using a URL:

``` r
owid_get(
  url = paste0(
    "https://ourworldindata.org/grapher/civil-liberties-score-fh",
    "?tab=chart&time=earliest..2023&country=ARG~AUS~BWA~CHN~ALB~DEU"
  )
)
#> # A tibble: 3,971 × 4
#>    entity   code      year civil.liberties.score
#>    <chr>    <chr>    <int>                 <int>
#>  1 Abkhazia OWID_ABK  2005                    21
#>  2 Abkhazia OWID_ABK  2006                    21
#>  3 Abkhazia OWID_ABK  2007                    21
#>  4 Abkhazia OWID_ABK  2008                    21
#>  5 Abkhazia OWID_ABK  2009                    21
#>  6 Abkhazia OWID_ABK  2010                    22
#>  7 Abkhazia OWID_ABK  2011                    22
#>  8 Abkhazia OWID_ABK  2012                    22
#>  9 Abkhazia OWID_ABK  2013                    22
#> 10 Abkhazia OWID_ABK  2014                    23
#> # ℹ 3,961 more rows
```
