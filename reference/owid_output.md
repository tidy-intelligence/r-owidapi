# Create OWID chart output elements in Shiny

**\[experimental\]**

This function creates an HTML output element for embedding Our World in
Data (OWID) charts in a Shiny application. It should be used in the UI
definition of your Shiny app.

## Usage

``` r
owid_output(id)

owid_server(id, url, width = "100%", height = "600px")
```

## Arguments

- id:

  Character string. The ID of the output element.

- url:

  Character string. The URL of the OWID chart to embed.

- width:

  Character string. The width of the chart (default: "100%").

- height:

  Character string. The height of the chart (default: "600px").

## Value

A Shiny HTML output element where the OWID chart will be rendered.

## Examples

``` r
if (FALSE) { # interactive() & curl::has_internet()
library(shiny)

ui <- fluidPage(
 owid_output("gdp_chart"),
 owid_output("co2_chart")
)

server <- function(input, output) {
 owid_server(
   "gdp_chart",
   "https://ourworldindata.org/grapher/gdp-per-capita-worldbank?tab=line"
 )
 owid_server(
   "co2_chart",
   "https://ourworldindata.org/grapher/co2-emissions-per-capita",
   height = "500px"
 )
}

shinyApp(ui = ui, server = server)
}
```
