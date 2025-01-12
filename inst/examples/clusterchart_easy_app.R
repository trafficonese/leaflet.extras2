library(shiny)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)

# data <- sf::st_as_sf(breweries91)
data <- sf::st_as_sf(mapview::trails[1:100, ])
data <- st_transform(data, 4326)
data <- st_cast(data, "POINT")
categories <- c("Schwer", "Mäßig", "Leicht", "kein Schaden")
data$category <- sample(categories, size = nrow(data), replace = TRUE)
data$label <- sample(breweries91$brewery, size = nrow(data), replace = TRUE)

ui <- fluidPage(
  leafletOutput("map", height = 800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
      addClusterCharts(
        data = data
        , type = "bar"
        , categoryField = "category"
        ,  options = clusterchartOptions(rmax = 40, size = 30,
                                         width = 50, height = 40,
                                         strokeWidth = 1,
                                         labelOpacity = 0.5,
                                         innerRadius = 10)
        , categoryMap = data.frame(labels = categories,
                                   colors  = c("#F88", "#FA0", "#FF3", "#BFB"),
                                   strokes = "gray")
        , group = "clustermarkers"
        , popupFields = c("brewery", "address", "zipcode", "category")
        , popupLabels = c("Brauerei", "Adresse", "PLZ", "Art")
        , label = "label"
      )
  })
}
shinyApp(ui, server)
