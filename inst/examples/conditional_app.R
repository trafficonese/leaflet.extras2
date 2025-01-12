library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)

breweries91 <- st_as_sf(breweries91)
lines <- st_as_sf(atlStorms2005)
polys <- st_as_sf(leaflet::gadmCHE)
groups <- c("storms","breweries","polys")

ui <- fluidPage(
  leafletOutput("map", height = 900)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      leafem::addMouseCoordinates() %>%
      addPolylines(data = lines, label = ~Name, group = groups[1]) %>%
      addCircleMarkers(data = breweries91, label = ~brewery, group = groups[2]) %>%
      addPolygons(data = polys, label = ~NAME_1, group = groups[3]) %>%
      addLayerGroupConditional(groups = groups,
                               conditions = list(
                                 "(zoomLevel) => zoomLevel < 4" = groups[1],
                                 "(zoomLevel) => zoomLevel >= 4 & zoomLevel < 6 " = groups[2],
                                 "(zoomLevel) => zoomLevel >= 6" = c(groups[3])
                               )) %>%
      hideGroup(groups) %>%
      addLayersControl(overlayGroups = groups,
                       options = layersControlOptions(collapsed=FALSE))
  })
}
shinyApp(ui, server)
