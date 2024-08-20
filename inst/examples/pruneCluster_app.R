# Example usage:
library(sf)
library(shiny)
library(leaflet)
library(leaflet.extras2)

# dat <- breweries91
# data <- sf::st_as_sf(breweries91)
data <- sf::st_as_sf(mapview::trails[1:400,])
data <- st_transform(data, 4326)
data <- st_cast(data, "POINT")
categories <- c("Schwer", "Mäßig", "Leicht", "kein Schaden")
data$category <- sample(categories, size = nrow(data), replace = TRUE)
# data$label <- sample(breweries91$brewery, size = nrow(data), replace = TRUE)
data$id <- paste0("ID_", 1:nrow(data))
options("shiny.autoreload" = TRUE)
pal <- colorFactor("RdYlBu", data$category)
data$color <- pal(data$category)


shipIcon <- iconList(
  "Schwer"       = makeIcon("./icons/Icon5.svg", iconWidth = 32, iconHeight = 32),
  "Mäßig"        = makeIcon("./icons/Icon8.svg", iconWidth = 32, iconHeight = 32),
  "Leicht"       = makeIcon("./icons/Icon25.svg", iconWidth = 32, iconHeight = 32),
  "kein Schaden" = makeIcon("./icons/Icon29.svg", iconWidth = 32, iconHeight = 32)
)

ui <- fluidPage(
  leafletOutput("map", height = 650),
  splitLayout(cellWidths = paste0(rep(20,4), "%"),
              div(h5("Click Event"), verbatimTextOutput("click")),
              div(h5("Mouseover Event"), verbatimTextOutput("mouseover")),
              div(h5("Mouseout Event"), verbatimTextOutput("mouseout")),
              div(h5("Drag-End Event"), verbatimTextOutput("dragend"))
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
      addPruneCluster(data = data
                      , label = "FGN"
                      , layerId = "id"
                      , categoryField = "category"
                      # , categoryField = NULL
                      # , label = "brewery"
                      , color = "color"
                      , group = "clustermarkers"
                      , popup = "category"
                      , icon = shipIcon
      )
  })
  output$click <- renderPrint({input$map_marker_click})
  output$mouseover <- renderPrint({input$map_marker_mouseover})
  output$mouseout <- renderPrint({input$map_marker_mouseout})
  output$dragend <- renderPrint({input$map_marker_dragend})
}
shinyApp(ui, server)
