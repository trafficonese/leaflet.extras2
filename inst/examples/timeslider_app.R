library(sf)
library(geojsonsf)
library(leaflet)
library(leaflet.extras2)
library(shiny)

data <- sf::st_as_sf(leaflet::atlStorms2005[1,])
data <- st_cast(data, "POINT")
data$time = as.POSIXct(
  seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))

ui <- fluidPage(
  leafletOutput("map", height = "800px"),
  actionButton("rm", "Remove Time Slider")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addTimeslider(data = data,
                    options = timesliderOptions(
                      range = FALSE)) %>%
      setView(-72, 22, 4)
  })
  observeEvent(input$rm, {
    leafletProxy("map", session) %>%
      removeTimeslider()
  })
}
shinyApp(ui, server)
