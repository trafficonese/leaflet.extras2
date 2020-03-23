library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(leafletOutput("map", height = "700px"))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      setView(9, 50, 6) %>%
      addOpenweatherTiles(layers = c("clouds", "pressure",
                                     "precipitation", "rain", "wind"))
  })
}

shinyApp(ui, server)
