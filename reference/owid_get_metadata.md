# Download metadata from Our World in Data

Retrieves the metadata for a data set from Our World in Data (OWID) by
specifying a chart identifier or direct URL.

## Usage

``` r
owid_get_metadata(chart_id = NULL, url = NULL)
```

## Arguments

- chart_id:

  Character string specifying the chart identifier (e.g.,
  "life-expectancy"). Not required if `url` is provided.

- url:

  Direct URL to an OWID chart. If provided, `chart_id` is ignored.

## Value

A list containing the requested OWID metadata.

## Examples

``` r
# \donttest{
# Download metadata using a data set
owid_get_metadata("life-expectancy")
#> $chart
#> $chart$title
#> [1] "Life expectancy"
#> 
#> $chart$citation
#> [1] "Riley (2005); Zijdeman et al. (2015); HMD (2025); UN WPP (2024)"
#> 
#> $chart$originalChartUrl
#> [1] "https://ourworldindata.org/grapher/life-expectancy"
#> 
#> $chart$selection
#> $chart$selection[[1]]
#> [1] "World"
#> 
#> $chart$selection[[2]]
#> [1] "Americas"
#> 
#> $chart$selection[[3]]
#> [1] "Europe"
#> 
#> $chart$selection[[4]]
#> [1] "Africa"
#> 
#> $chart$selection[[5]]
#> [1] "Asia"
#> 
#> $chart$selection[[6]]
#> [1] "Oceania"
#> 
#> 
#> 
#> $columns
#> $columns$`Period life expectancy at birth`
#> $columns$`Period life expectancy at birth`$titleShort
#> [1] "Life expectancy"
#> 
#> $columns$`Period life expectancy at birth`$titleLong
#> [1] "Life expectancy - Riley; Zijdeman et al.; HMD; UN WPP – Long-run data"
#> 
#> $columns$`Period life expectancy at birth`$descriptionShort
#> [1] "Period life expectancy is the number of years the average person born in a certain year would live if they experienced the same chances of dying at each age as people did that year."
#> 
#> $columns$`Period life expectancy at birth`$descriptionKey
#> [1] "- Across the world, people are living longer. In 1900, the global average life expectancy was 32 years. By 2023, this had more than doubled to 73 years.\n- Countries around the world made big improvements, and life expectancy more than doubled in every region. This wasn’t just due to falling child mortality; people started living longer at all ages.\n- Even after World War II, there have been large drops in life expectancy, such as during the Great Leap Forward famine in China, the HIV/AIDS epidemic in sub-Saharan Africa, the Rwandan genocide, or the COVID-19 pandemic.\n- Period life expectancy is an indicator that summarizes death rates across all age groups in one particular year. It shows how long the average baby born in that year would be expected to live if they experienced the same chances of dying at each age as people did in that year.\n- This chart shows long-run estimates of life expectancy compiled by our team from several data sources. Before 1950, for country-level data, we rely on the [Human Mortality Database (2025)](https://www.mortality.org/Data/ZippedDataFiles) combined with [Zijdeman (2015)](https://clio-infra.eu/Indicators/LifeExpectancyatBirthTotal.html). For regional data, we use [Riley (2005)](https://doi.org/10.1111/j.1728-4457.2005.00083.x). From 1950 onward, we use the [United Nations World Population Prospects (2024)](https://population.un.org/wpp/downloads).\n- Detailed information on the source of each data point can be found on [this page](https://docs.google.com/spreadsheets/d/1LnrU1V3p2wq7sAPY4AHRdH1urol3cKev7prEvlLfSU4/edit?gid=0#gid=0)."
#> 
#> $columns$`Period life expectancy at birth`$descriptionProcessing
#> [1] "This chart combines data from several sources. For country-level data before 1950, we use the Human Mortality Database (2025) data and Zijdeman et al. (2015). For country-years where these sources overlap, we use the Human Mortality Database.\n\nFor regional data, before 1950, we use Riley's (2005) estimates.\n\nFrom 1950 onwards, we use the United Nations World Population Prospects (2024) for both country-level and regional data.\n\nDetailed information on the source of each data point can be found on [this page](https://docs.google.com/spreadsheets/d/1LnrU1V3p2wq7sAPY4AHRdH1urol3cKev7prEvlLfSU4/edit?gid=0#gid=0)."
#> 
#> $columns$`Period life expectancy at birth`$shortUnit
#> [1] "years"
#> 
#> $columns$`Period life expectancy at birth`$unit
#> [1] "years"
#> 
#> $columns$`Period life expectancy at birth`$timespan
#> [1] "1543-2023"
#> 
#> $columns$`Period life expectancy at birth`$type
#> [1] "Numeric"
#> 
#> $columns$`Period life expectancy at birth`$owidVariableId
#> [1] 1118466
#> 
#> $columns$`Period life expectancy at birth`$shortName
#> [1] "life_expectancy_0"
#> 
#> $columns$`Period life expectancy at birth`$lastUpdated
#> [1] "2025-10-22"
#> 
#> $columns$`Period life expectancy at birth`$nextUpdate
#> [1] "2026-10-22"
#> 
#> $columns$`Period life expectancy at birth`$citationShort
#> [1] "Riley (2005); Zijdeman et al. (2015); HMD (2025); UN WPP (2024) – with major processing by Our World in Data"
#> 
#> $columns$`Period life expectancy at birth`$citationLong
#> [1] "Riley (2005); Zijdeman et al. (2015); HMD (2025); UN WPP (2024) – with major processing by Our World in Data. “Life expectancy – Riley; Zijdeman et al.; HMD; UN WPP – Long-run data” [dataset]. Human Mortality Database, “Human Mortality Database”; United Nations, “World Population Prospects”; United Nations, “World Population Prospects - Interim Update”; Zijdeman et al., “Life Expectancy at birth v2”; James C. Riley, “Estimates of Regional and Global Life Expectancy, 1800-2001” [original data]."
#> 
#> $columns$`Period life expectancy at birth`$fullMetadata
#> [1] "https://api.ourworldindata.org/v1/indicators/1118466.metadata.json"
#> 
#> 
#> 
#> $dateDownloaded
#> [1] "2026-07-28"
#> 

# Download metadata using an url
owid_get_metadata(
 url = "https://ourworldindata.org/grapher/civil-liberties-score-fh"
)
#> $chart
#> $chart$title
#> [1] "Civil Liberties Score"
#> 
#> $chart$subtitle
#> [1] "Data by Freedom House. The score captures the extent of freedom of expression and association, the rule of law, and personal autonomy. Higher scores indicate more liberties."
#> 
#> $chart$citation
#> [1] "Freedom House (2026)"
#> 
#> $chart$originalChartUrl
#> [1] "https://ourworldindata.org/grapher/civil-liberties-score-fh"
#> 
#> $chart$selection
#> $chart$selection[[1]]
#> [1] "Argentina"
#> 
#> $chart$selection[[2]]
#> [1] "Australia"
#> 
#> $chart$selection[[3]]
#> [1] "Botswana"
#> 
#> $chart$selection[[4]]
#> [1] "China"
#> 
#> 
#> 
#> $columns
#> $columns$`Civil liberties score`
#> $columns$`Civil liberties score`$titleShort
#> [1] "Civil liberties score"
#> 
#> $columns$`Civil liberties score`$titleLong
#> [1] "Civil liberties score"
#> 
#> $columns$`Civil liberties score`$descriptionShort
#> [1] "The variable identifies the fine-grained extent of freedom of expression and association, the rule of law, and personal autonomy. Higher scores indicate more liberties."
#> 
#> $columns$`Civil liberties score`$unit
#> [1] ""
#> 
#> $columns$`Civil liberties score`$timespan
#> [1] "2003-2025"
#> 
#> $columns$`Civil liberties score`$type
#> [1] "Integer"
#> 
#> $columns$`Civil liberties score`$owidVariableId
#> [1] 1210109
#> 
#> $columns$`Civil liberties score`$shortName
#> [1] "civlibs_score"
#> 
#> $columns$`Civil liberties score`$lastUpdated
#> [1] "2026-03-23"
#> 
#> $columns$`Civil liberties score`$nextUpdate
#> [1] "2027-03-23"
#> 
#> $columns$`Civil liberties score`$citationShort
#> [1] "Freedom House (2026) – processed by Our World in Data"
#> 
#> $columns$`Civil liberties score`$citationLong
#> [1] "Freedom House (2026) – processed by Our World in Data. “Civil liberties score” [dataset]. Freedom House, “Freedom in the World” [original data]."
#> 
#> $columns$`Civil liberties score`$fullMetadata
#> [1] "https://api.ourworldindata.org/v1/indicators/1210109.metadata.json"
#> 
#> 
#> $columns$`World region according to OWID`
#> $columns$`World region according to OWID`$titleShort
#> [1] "World region according to OWID"
#> 
#> $columns$`World region according to OWID`$titleLong
#> [1] "World region according to OWID"
#> 
#> $columns$`World region according to OWID`$descriptionShort
#> [1] "Regions defined by Our World in Data, which are used in OWID charts and maps."
#> 
#> $columns$`World region according to OWID`$unit
#> [1] ""
#> 
#> $columns$`World region according to OWID`$timespan
#> [1] "2023-2023"
#> 
#> $columns$`World region according to OWID`$type
#> [1] "Continent"
#> 
#> $columns$`World region according to OWID`$owidVariableId
#> [1] 900801
#> 
#> $columns$`World region according to OWID`$shortName
#> [1] "owid_region"
#> 
#> $columns$`World region according to OWID`$lastUpdated
#> [1] "2023-01-01"
#> 
#> $columns$`World region according to OWID`$citationShort
#> [1] "Our World in Data – processed by Our World in Data"
#> 
#> $columns$`World region according to OWID`$citationLong
#> [1] "Our World in Data – processed by Our World in Data. “World region according to OWID” [dataset]. Our World in Data, “Regions” [original data]."
#> 
#> $columns$`World region according to OWID`$fullMetadata
#> [1] "https://api.ourworldindata.org/v1/indicators/900801.metadata.json"
#> 
#> 
#> 
#> $dateDownloaded
#> [1] "2026-07-28"
#> 
# }
```
