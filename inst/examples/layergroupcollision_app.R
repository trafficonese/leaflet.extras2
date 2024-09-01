library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)

# data <- sf::st_as_sf(breweries91)
data <- sf::st_as_sf(mapview::trails[1:100,])
data <- st_transform(data, 4326)
data <- st_cast(data, "POINT")
data <- data[1:300,]

ui <- fluidPage(
  leafletOutput("map", height = 800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      leaflet::addLayersControl(overlayGroups = "markers") %>%
      addMarkers(data = data
                 , group = "markers"
                 , label = ~FGN) %>%
      addLayerGroupCollision(group = "markers")
  })
}
shinyApp(ui, server)
