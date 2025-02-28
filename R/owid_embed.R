#' Embed Our World in Data Chart in HTML
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Creates HTML code to embed an interactive chart from Our World in Data
#' into an HTML document using an iframe.
#'
#' @param url A character string containing the URL of the Our World in
#'  Data chart. Must begin with "https://ourworldindata.org/grapher/".
#' @param width A character string specifying the width of the iframe.
#'  Default is "100%".
#' @param height A character string specifying the height of the iframe.
#'  Default is "600px".
#'
#' @return A character string containing the HTML iframe to embed the chart.
#'
#' @examples
#' owid_embed(
#'   "https://ourworldindata.org/grapher/co2-emissions-per-capita",
#'   width = "90%",
#'   height = "500px"
#' )
#'
#' @export
owid_embed <- function(url, width = "100%", height = "600px") {
  if (!grepl("^https://ourworldindata.org/grapher/", url)) {
    cli_abort(
      "URL must be from Our World in Data (https://ourworldindata.org/grapher/)"
    )
  }

  #nolint start
  iframe_html <- paste0(
    '<iframe src="',
    url,
    '" ',
    'loading="lazy" ',
    'style="width: ',
    width,
    '; height: ',
    height,
    '; border: 0px none;" ',
    'allow="web-share; clipboard-write"></iframe>'
  )
  #nolint end

  iframe_html
}
