library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras2)

df <- breweries91
df$weight <- seq_len(nrow(df))
# df$weight <- sample(c(1,5,10,30), size = nrow(df), T)
dfjitter <- suppressWarnings(sf::st_jitter(sf::st_as_sf(df), 0.09))
dfjitter1 <- suppressWarnings(sf::st_jitter(sf::st_as_sf(df), 0.09, 0.1))
# dfjitter$weight <- rev(dfjitter$weight)
getColor <- function(dfjitter1) {
  sapply(dfjitter1$weight, function(weight) {
    if (weight > 5) {
      "green"
    } else if (weight <= 5) {
      "orange"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(icon = "ios-close", iconColor = "black", library = "ion",
                      markerColor = getColor(dfjitter1))

ui <- fluidPage(leafletOutput("map", height = 700))

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = df, label = ~paste0(weight, " - ", brewery),
                 popup = ~paste0(weight, " - ", brewery),
                 group = "hidemarkers_1",
                 labelOptions = labelOptions(permanent = TRUE)) %>%
      addCircleMarkers(data = dfjitter,
                       label = ~paste0(weight, " - ", brewery),
                       weight = ~weight, color = "red",
                       popup = ~paste0(weight, " - ", brewery),
                       group = "hidemarkers_2",
                       labelOptions = labelOptions(permanent = TRUE)) %>%
      addAwesomeMarkers(data = dfjitter1,
                        label = ~paste0(weight, " - ", brewery),
                        icon = icons,
                        popup = ~paste0(weight, " - ", brewery),
                        group = "hidemarkers_3",
                        labelOptions = labelOptions(permanent = TRUE)) %>%
      addLabelgun(c("hidemarkers_1", "hidemarkers_2", "hidemarkers_3"),
                  rep(df$weight, 3)) %>%
      # addLabelgun("hidemarkers_1") %>%
      # addLabelgun(c("hidemarkers_1","hidemarkers_2"), rep(df$weight, 2)) %>%
      # addLabelgun("hidemarkers_1", rep(df$weight, 3)) %>%
      # addLabelgun("hidemarkers_2", rev(df$weight)) %>%
      # addLabelgun("hidemarkers_1", entries = 50,
      #             weight = c(df$weight, rev(df$weight))) %>%
      # addLabelgun(c("hidemarkers_1","hidemarkers_2"), df$weight) %>%
      # addLabelgun(c("hidemarkers_1","hidemarkers_2")) %>%
      addLayersControl(overlayGroups = c("hidemarkers_1",
                                         "hidemarkers_2",
                                         "hidemarkers_3"))
  })
}
shinyApp(ui, server)
