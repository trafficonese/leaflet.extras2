library(shiny)
library(sf)
library(geojsonsf)
library(leaflet)
library(leaflet.extras2)

data <- sf::st_as_sf(breweries91)
data$category <- sample(factor(c("Schwer", "Mäßig", "Leicht", "kein Schaden"), ordered = TRUE), size = nrow(data), replace = TRUE)
data$label <- paste0(data$brewery, "<br>", data$address)
data$id <- paste0("ID", seq.int(nrow(data)))
data$popup <- paste0("<h6>", data$brewery, "</h6><div>", data$address, "</div>")
# data <- geojson_sf("https://gist.githubusercontent.com/gisminister/10001728/raw/97156c7676f85a1f2689ce0adceec3a759baa359/traffic_accidents.geojson")
# data <- "https://gist.githubusercontent.com/gisminister/10001728/raw/97156c7676f85a1f2689ce0adceec3a759baa359/traffic_accidents.geojson"

ui <- fluidPage(
  # tags$head(tags$style(css)),
  leafletOutput("map", height = 500),
  splitLayout(cellWidths = paste0(rep(20,4), "%"),
              div(verbatimTextOutput("click")),
              div(verbatimTextOutput("mouseover")),
              div(verbatimTextOutput("mouseout")),
              div(verbatimTextOutput("dragend"))
              )
)

options("shiny.autoreload" = TRUE)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>% addMapPane("clusterpane", 420) %>%
      addProviderTiles("CartoDB") %>%
      leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
      # addCircleMarkers(data = data, clusterOptions = markerClusterOptions()) %>%
      # addCircleMarkers(data = data, options = pathOptions(pane = "clusterpane")) %>%
      addClusterCharts(data = data
                       , options = clusterchartOptions(rmax = 40, size = 30,
                                                       width = 30, height = 30,
                                                       strokeWidth = 10,
                                                       innerRadius = 14)
                       , type = "bar"
                       , categoryField = "category"
                       , categoryMap =
                         data.frame(label = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                              color  = c("#F88", "#FA0", "#FF3", "#BFB"),
                              # color  = c("lightblue", "orange", "lightyellow", "lightgreen"),
                              # color = c("cyan", "darkorange", "yellow", "#9fca8b"),
                              icons = c("icons/Icon 29.svg", "icons/Icon 8.svg", "icons/Icon 5.svg", "icons/Icon 25.svg"),
                              # stroke = c("#800", "#B60", "#D80", "#070")
                              stroke = "gray"
                         )
                       , group = "clustermarkers"
                       # group = "zipcode",
                       , layerId = "id"
                       , clusterId = "id"
                       , popupFields = c("brewery","address","zipcode", "category")
                       , popupLabels = c("Brauerei","Addresse","PLZ", "Art")
                       # , popup = "popup"
                       , label = "label"
                       ## Options #############
                       , markerOptions = markerOptions(interactive = TRUE,
                                                       draggable = TRUE,
                                                       keyboard = TRUE,
                                                       title = "Some Marker Title",
                                                       alt = "The alt info",
                                                       zIndexOffset = 100,
                                                       opacity = 1,
                                                       riseOnHover = TRUE,
                                                       riseOffset = 400)
                       , legendOptions = list(position = "bottomright", title = "Unfälle im Jahr 2003")
                       , clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE,
                                                               zoomToBoundsOnClick = TRUE,
                                                               spiderfyOnMaxZoom = TRUE,
                                                               removeOutsideVisibleBounds = TRUE,
                                                               spiderLegPolylineOptions = list(weight = 1.5, color = "#222", opacity = 0.5),
                                                               freezeAtZoom = TRUE,
                                                               # clusterPane = "clusterpane",
                                                               spiderfyDistanceMultiplier = 2
                                                               )
                       , labelOptions = labelOptions(opacity = 0.8, textsize = "14px")
                       , popupOptions = popupOptions(maxWidth = 900, minWidth = 200, keepInView = TRUE)
                       )
  })
  output$click <- renderPrint({input$map_marker_click})
  output$mouseover <- renderPrint({input$map_marker_mouseover})
  output$mouseout <- renderPrint({input$map_marker_mouseout})
  output$dragend <- renderPrint({input$map_marker_dragend})
}
shinyApp(ui, server)
