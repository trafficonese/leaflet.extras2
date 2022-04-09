library(shiny)
library(leaflet)
library(leaflet.extras2)
library(sf)
library(mapview)

coords <- mapview::trails[1:100, ]
coords <- sf::st_transform(coords, 4326)

pal <- colorQuantile("viridis", domain = as.numeric(coords$FKN))
cols <- pal(as.numeric(coords$FKN))

ui <- fluidPage(
  leafletOutput("map", height = "500px"),
  actionButton("group", "Clear Group"),
  actionButton("clear", "Clear Antpath"),
  actionButton("remov", "Remove Antpath")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addAntpath(data = coords,
                 layerId = ~FGN,
                 label = ~sprintf("Ant-Colony of %s", district),
                 group = "antgroup",
                 color = cols,
                 weight = 2 + (1:nrow(coords))/30,
                 popup = ~FGN,
                 opacity = 1,
                 options = antpathOptions(
                   pulseColor = colorNumeric("Reds",
                     domain = as.numeric(coords$FKN))(as.numeric(coords$FKN)),
                   delay = c(rep(300, 50), rep(3000, 50)),
                   paused = FALSE,
                   reverse = TRUE,
                   dashArray = c(40, 50),
                   hardwareAccelerated = T,
                   interactive = TRUE,
                   lineCap = "butt",
                   lineJoin = "butt",
                   pointerEvents = "fill",
                   className = "antopt"))
  })
  observeEvent(input$group, {
    leafletProxy("map", session) %>%
      clearGroup("antgroup")
  })
  observeEvent(input$clear, {
    leafletProxy("map", session) %>%
      clearAntpath()
  })
  observeEvent(input$remov, {
    leafletProxy("map", session) %>%
      removeAntpath(layerId = sample(coords$FGN, 10))
  })

}
shinyApp(ui, server)
