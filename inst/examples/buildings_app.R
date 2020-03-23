library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(leafletOutput("map", height = "700px"))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addBuildings() %>%
      addMarkers(data = breweries91)
  })
}
shinyApp(ui, server)
