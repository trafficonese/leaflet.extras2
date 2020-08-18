library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(leafletOutput("map", height = "700px"))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addBuildings(apikey = "asd") %>%
      addMarkers(data = breweries91) %>%
      setView(lng = 13.40438, lat = 52.51836, zoom = 16)
  })
}
shinyApp(ui, server)
