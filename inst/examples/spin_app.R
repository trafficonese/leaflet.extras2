library(shiny)
library(leaflet)
# library(leaflet.extras2)
pkgload::load_all("C:/Users/kona1/Documents/Github_Forks/leaflet.extras2")


dlat <- 1 / 111000 * 100

ui <- fluidPage(
  tags$h2("Leaflet.Spin in Shiny"),
  tags$p("startSpinner/stopSpinner in renderLeaflet() cannot cover Sys.sleep() — use spinWhile()."),
  actionButton("load", "Load quakes (2s delay)"),
  actionButton("circles", "Add random circles"),
  leafletOutput("map", height = "500px")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(175.322, -37.789, zoom = 6) %>%
      addSpinner()
  })

  observeEvent(input$load, {
    spinWhile("map", {
      leafletProxy("map") %>%
        clearGroup("quakes") %>%
        addMarkers(
          data = quakes, ~long, ~lat, group = "quakes",
          popup = ~as.character(mag), label = ~as.character(mag)
        )
    }, options = list(lines = 7, length = 20, width = 10, radius = 10))
  })

  observeEvent(input$circles, {
    n <- ceiling(runif(1) * 400)
    spinWhile("map", {
      leafletProxy("map") %>%
        clearGroup("circles") %>%
        addCircles(
          lng = 175.322 + (runif(n) * 2 - 1) * dlat * 6,
          lat = -37.789 + (runif(n) * 2 - 1) * dlat * 1.5,
          radius = runif(n) * 80,
          group = "circles"
        )
    }, options = list(lines = 7, length = 40, width = 20, radius = 10))
  })
}

shinyApp(ui = ui, server = server)
