# Embed Our World in Data Chart in HTML

**\[experimental\]**

Creates HTML code to embed an interactive chart from Our World in Data
into an HTML document using an iframe.

## Usage

``` r
owid_embed(url, width = "100%", height = "600px")
```

## Arguments

- url:

  A character string containing the URL of the Our World in Data chart.
  Must begin with "https://ourworldindata.org/grapher/".

- width:

  A character string specifying the width of the iframe. Default is
  "100%".

- height:

  A character string specifying the height of the iframe. Default is
  "600px".

## Value

A character string containing the HTML iframe to embed the chart.

## Examples

``` r
owid_embed(
  "https://ourworldindata.org/grapher/co2-emissions-per-capita",
  width = "90%",
  height = "500px"
)
#> [1] "<iframe src=\"https://ourworldindata.org/grapher/co2-emissions-per-capita\" loading=\"lazy\" style=\"width: 90%; height: 500px; border: 0px none;\" allow=\"web-share; clipboard-write\"></iframe>"
```
