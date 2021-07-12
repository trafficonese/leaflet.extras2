library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(
  leafletOutput("map", height=700)
)

df <- breweries91
df$weight <- 1:nrow(df)
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df, label=~paste0(weight, " - ", brewery),
                       weight = ~weight,
                 popup=~paste0(weight, " - ", brewery),
                 group = "hidemarkers_1",
                 labelOptions = labelOptions(permanent = TRUE)) %>%
      addCircleMarkers(data = sf::st_jitter(sf::st_as_sf(df), 0.09),
                       label=~paste0(weight, " - ", brewery),
                       weight = ~weight, color = "red",
                       popup=~paste0(weight, " - ", brewery),
                       group = "hidemarkers_2",
                       labelOptions = labelOptions(permanent = TRUE)) %>%
      addLabelgun("hidemarkers_1", 5, df$weight) %>%
      addLayersControl(overlayGroups = c("hidemarkers_1", "hidemarkers_2"))
  })
}
shinyApp(ui, server)
