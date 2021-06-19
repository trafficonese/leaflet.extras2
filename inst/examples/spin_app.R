library(shiny)
library(leaflet)
library(leaflet.extras2)

# From https://stackoverflow.com/questions/61532955/cant-get-leaflet-spin-plugin-working-in-r-shiny/

dlat <- 1 / 111000 * 100 # degrees per metre

ui <- fluidRow(
  tags$h2("Using Leaflet.Spin in Shiny"),
  actionButton("plotbutton", label = "Show Spinner While Adding Markers"),
  leafletOutput("map")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(175.322, -37.789, zoom = 17) %>%
      addSpinner()
  })

  observeEvent(input$plotbutton, {
    n <- ceiling(runif(1) * 10000)
    n <- 10000
    leafletProxy("map") %>%
      startSpinner(list("lines" = 7, "length" = 40, "width" = 20, "radius" = 10)) %>%
      clearShapes() %>%
      addCircles(
        lng = 175.322 + (runif(n) * 2 - 1) * dlat * 6,
        lat = -37.789 + (runif(n) * 2 - 1) * dlat * 1.5,
        radius = dlat * runif(n) * dlat
      ) %>%
      stopSpinner()
  })
}

shinyApp(ui = ui, server = server)
