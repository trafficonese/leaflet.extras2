library(shiny)
library(leaflet)
library(htmlwidgets)
library(leaflet.extras2)

## Mapbox
# url = "https://{s}.tiles.mapbox.com/v4/mapbox.mapbox-streets-v6/{z}/{x}/{y}.vector.pbf?access_token={key}"
# key = 'MAPBOX_APIKEY';

## ESRI
# url = "https://basemaps.arcgis.com/v1/arcgis/rest/services/World_Basemap/VectorTileServer/tile/{z}/{y}/{x}.pbf";
## Needs different styling: See https://github.com/Leaflet/Leaflet.VectorGrid/blob/master/docs/demo-vectortiles.html

## Maptiler
url = "https://api.maptiler.com/tiles/v3/{z}/{x}/{y}.pbf?key={key}";
# key = "MAPTILER_APIKEY"

## Nextzen
# url = "https://tile.nextzen.org/tilezen/vector/v1/512/all/{z}/{x}/{y}.mvt?api_key={key}"
# key = 'NEXTZEN_APIKEY';


ui <- fluidPage(
  leafletOutput("map", height = "600px"),
  actionButton("remov", "Remove by layerId"),
  actionButton("clear", "Clear"),
  verbatimTextOutput("click_ev")
)

styling <- vectorStyling()
styling$water$fillColor <- "#0033ff"
styling$water$fillOpacity <- 0.8
styling$buildings$color <- "red"
styling$buildings$fillColor <- "red"
styling$buildings$fillOpacity <- 1
styling$place <- htmlwidgets::JS("function(foo) {
                                    return {icon: new L.Icon.Default()}
                                 }")

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addMapPane("myPane", 200) %>%
      addProtobuf(
        urlTemplate = url,
        key = key,
        attribution = "Mapbox/Nextzen/Maptiler",
        interactive = TRUE,
        layerId = "uniqueID",
        popup = "class",
        styling = styling,
        options = tileOptions(tileSize = 256,
                              noWrap=TRUE,
                              pane = "myPane"),
        group="protobuf"
        ) %>%
      setView(-74.163208,40.9994639, 14)
  })

  observeEvent(input$remov, {
    leafletProxy("map", session) %>%
      removeVectorgrid("uniqueID")
  })
  observeEvent(input$clear, {
    leafletProxy("map", session) %>%
      clearVectorgrid()
  })
  output$click_ev <- renderPrint({
    txt <- req(input$map_vectorgrid_pbf_click)
    print(txt)
  })
}

shinyApp(ui, server)
