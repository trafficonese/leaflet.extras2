library(shiny)
library(leaflet)
library(leaflet.extras2)

# Official OSM Shortbread vector tiles (no API key).
# OpenFreeMap is TileJSON, not XYZ: see https://tiles.openfreemap.org/planet
url <- "https://vector.openstreetmap.org/shortbread_v1/{z}/{x}/{y}.mvt"

styling <- vectorStyling()
styling$water_polygons$fillOpacity <- 0.55
styling$streets$weight <- 2
styling$streets$opacity <- 1

ui <- fluidPage(
  tags$p("Vector tiles: zoom 10–14. Below 10 nothing is fetched; above 14, z=14 tiles are scaled."),
  leafletOutput("map", height = "700px"),
  actionButton("remov", "Remove layer"),
  actionButton("clear", "Clear"),
  verbatimTextOutput("click_ev")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProtobuf(
        urlTemplate = url,
        layerId = "osm-pbf",
        group = "vector",
        attribution = "&copy; OpenStreetMap contributors",
        interactive = TRUE,
        popup = "name",
        label = "name",
        styling = styling,
        options = tileOptions(
          minZoom = 10,
          maxZoom = 22,
          maxNativeZoom = 14
        )
      ) %>%
      setView(9.2, 48.8, 12)
  })

  observeEvent(input$remov, {
    leafletProxy("map") %>%
      removeVectorgrid("osm-pbf")
  })
  observeEvent(input$clear, {
    leafletProxy("map") %>%
      clearVectorgrid()
  })
  output$click_ev <- renderPrint({
    print(req(input$map_vectorgrid_pbf_click))
  })
}

shinyApp(ui, server)
