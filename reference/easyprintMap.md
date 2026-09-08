# easyprintMap

Print or export a map programmatically (e.g. in a Shiny environment).

## Usage

``` r
easyprintMap(map, sizeModes = "A4Portrait", filename = "map")
```

## Arguments

- map:

  the map widget

- sizeModes:

  Must match one of the given `sizeMode` names in
  [`easyprintOptions`](https://trafficonese.github.io/leaflet.extras2/reference/easyprintOptions.md).
  The options are: `CurrentSize`, `A4Portrait` or `A4Landscape`. If you
  want to print the map with a `Custom` sizeMode you need to pass the
  Custom className. Default is `A4Portrait`

- filename:

  Name of the file if `exportOnly` option is `TRUE`.

## Value

A leaflet map object

## See also

Other EasyPrint Functions:
[`addEasyprint()`](https://trafficonese.github.io/leaflet.extras2/reference/addEasyprint.md),
[`easyprintOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/easyprintOptions.md),
[`removeEasyprint()`](https://trafficonese.github.io/leaflet.extras2/reference/removeEasyprint.md)

## Examples

``` r
## Only run examples in interactive R sessions
if (interactive()) {
  library(shiny)
  library(leaflet)
  library(leaflet.extras2)

  ui <- fluidPage(
    leafletOutput("map"),
    selectInput("scene", "Select Scene", choices = c("CurrentSize", "A4Landscape", "A4Portrait")),
    actionButton("print", "Print Map")
  )

  server <- function(input, output, session) {
    output$map <- renderLeaflet({
      input$print
      leaflet() %>%
        addTiles() %>%
        setView(10, 50, 9) %>%
        addEasyprint(options = easyprintOptions(
          exportOnly = TRUE
        ))
    })
    observeEvent(input$print, {
      leafletProxy("map") %>%
        easyprintMap(sizeModes = input$scene)
    })
  }

  shinyApp(ui, server)
}
```
