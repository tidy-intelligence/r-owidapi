#' Create OWID chart output elements in Shiny
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function creates an HTML output element for embedding Our World in Data
#' (OWID) charts in a Shiny application. It should be used in the UI definition
#' of your Shiny app.
#'
#' @param id Character string. The ID to use for the output element.
#' @return A Shiny HTML output element where the OWID chart will be rendered.
#'
#' @examplesIf interactive() & curl::has_internet()
#' library(shiny)
#'
#' ui <- fluidPage(
#'  owid_output("gdp_chart"),
#'  owid_output("co2_chart")
#' )
#'
#' server <- function(input, output) {
#'  owid_server(
#'    "gdp_chart",
#'    "https://ourworldindata.org/grapher/gdp-per-capita-worldbank?tab=line"
#'  )
#'  owid_server(
#'    "co2_chart",
#'    "https://ourworldindata.org/grapher/co2-emissions-per-capita",
#'    height = "500px"
#'  )
#' }
#'
#' shinyApp(ui = ui, server = server)
#'
#' @export
owid_output <- function(id) {
  # nocov start
  shiny::htmlOutput(id)
  # nocov end
}

#' @rdname owid_output
#' @param id Character string. The ID of the output element.
#' @param url Character string. The URL of the OWID chart to embed.
#' @param width Character string. The width of the chart (default: "100%").
#' @param height Character string. The height of the chart (default: "600px").
#' @export
owid_server <- function(id, url, width = "100%", height = "600px") {
  # nocov start
  output <- get("output", envir = parent.frame())
  output[[id]] <- shiny::renderUI({
    html_content <- owid_embed(url, width, height)
    shiny::HTML(html_content)
  })
  # nocov end
}
