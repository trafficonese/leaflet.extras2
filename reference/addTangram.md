# Adds a Tangram layer to a Leaflet map in a Shiny App.

Adds a Tangram layer to a Leaflet map in a Shiny App.

## Usage

``` r
addTangram(map, scene = NULL, layerId = NULL, group = NULL, options = NULL)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- scene:

  Path to a required **.yaml** or **.zip** file. If the file is within
  the `/www` folder of a Shiny-App, only the filename must be given,
  otherwise the full path is needed. See the [Tangram
  repository](https://github.com/tangrams/tangram) or the [Tangram
  docs](https://tangrams.readthedocs.io/en/latest/) for further
  information on how to edit such a .yaml file.

- layerId:

  the layer id

- group:

  the name of the group the newly created layers should belong to (for
  [`clearGroup()`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl()`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g., markers and polygons) can share the same group
  name.

- options:

  A list of further options. See the app in the `examples/tangram`
  folder or the
  [docs](https://tangrams.readthedocs.io/en/latest/Overviews/Tangram-Overview/#leaflet)
  for further information.

## Value

the new `map` object

## Note

Only works correctly in a Shiny-App environment.

## References

<https://github.com/tangrams/tangram>

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)
library(leaflet)
library(leaflet.extras2)

## In the /www folder of a ShinyApp. Must contain the Nextzen API-key
scene <- "scene.yaml"

ui <- fluidPage(leafletOutput("map"))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      addTangram(scene = scene, group = "tangram") %>%
      addCircleMarkers(data = breweries91, group = "brews") %>%
      setView(11, 49.4, 14) %>%
      addLayersControl(
        baseGroups = c("tangram", "base"),
        overlayGroups = c("brews")
      )
  })
}

shinyApp(ui, server)
} # }
```
