library(shiny)
library(leaflet)
library(leaflet.extras2)
library(sf)
library(colourvalues)

data <- sf::st_read(paste0(system.file(package = "leaflet.extras2"),"/examples/www/eu-countries.geo.json"))
data$fillColor <- colourvalues::color_values(data$labelrank, palette = "viridis", include_alpha = FALSE)


ui <- fluidPage(
  leafletOutput("map", height = "800px"),
  actionButton("remov", "Remove by layerId"),
  actionButton("clear", "Clear"),
  verbatimTextOutput("click_ev")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      addVectorgrid(
        data = data,
        layerId=~admin,
        label=~economy,
        group="group",
        color = "black", weight = 3, opacity = 0.5, fill = TRUE,
        fillOpacity = 0.5) %>%
      setView(lng = 10.5, lat = 49.5, zoom = 6)
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
    txt <- req(input$map_vectorgrid_click)
    print(txt)
  })
}

shinyApp(ui, server)
