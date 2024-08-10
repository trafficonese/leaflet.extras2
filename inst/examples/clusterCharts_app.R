library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
options("shiny.autoreload" = TRUE)


# shipIcon <- leaflet::makeIcon(
#   iconUrl = "./icons/Icon5.svg"
#   ,className = "lsaicons"
#   ,iconWidth = 24, iconHeight = 24, iconAnchorX = 0, iconAnchorY = 0
# )
shipIcon <- iconList(
  "Schwer"       = makeIcon("./icons/Icon5.svg", iconWidth = 32, iconHeight = 32),
  "Mäßig"        = makeIcon("./icons/Icon8.svg", iconWidth = 32, iconHeight = 32),
  "Leicht"       = makeIcon("./icons/Icon25.svg", iconWidth = 32, iconHeight = 32),
  "kein Schaden" = makeIcon("./icons/Icon29.svg", iconWidth = 32, iconHeight = 32)
)
# shipIcon <- makeIcon(
#   iconUrl = "https://cdn-icons-png.flaticon.com/512/1355/1355883.png",
#   iconWidth = 40, iconHeight = 50,
#   iconAnchorX = 0, iconAnchorY = 0
# )

data <- sf::st_as_sf(breweries91)
data$categoryfields <- sample(c("Schwer", "Mäßig", "Leicht", "kein Schaden"), size = nrow(data), replace = TRUE)
data$label <- paste0(data$brewery, "<br>", data$address)
data$id <- paste0("ID", seq.int(nrow(data)))
data$popup <- paste0("<h6>", data$brewery, "</h6><div>", data$address, "</div>")
data$web <- gsub(">(.*?)<", ">LINK<", data$web)
data$web <- ifelse(is.na(data$web), "", paste0("<div class='markerhtml'>", data$web, "</div>"))
data$tosum <- sample(1:100, nrow(data), replace = TRUE)

ui <- fluidPage(
  tags$head(tags$style("
  .clusterchartsicon {
    background-position: left !important;
  }
  .markerhtml {
    height: 100%;
    margin-top: 8px;
    left: 41px;
    position: absolute;
  }")),
  leafletOutput("map", height = 650),
  splitLayout(cellWidths = paste0(rep(20,4), "%"),
              div(verbatimTextOutput("click")),
              div(verbatimTextOutput("mouseover")),
              div(verbatimTextOutput("mouseout")),
              div(verbatimTextOutput("dragend"))
              )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>% addMapPane("clusterpane", 420) %>%
      addProviderTiles("CartoDB") %>%
      leaflet::addLayersControl(overlayGroups = c("clustermarkers","normalcircles")) %>%
      # addCircleMarkers(data = data, group = "normalcircles", clusterOptions = markerClusterOptions()) %>%
      addClusterCharts(data = data
                       , options = clusterchartOptions(rmax = 50,
                                                       size = c(100,40),
                                                       # size=40,
                                                       width = 100, height = 30,
                                                       strokeWidth = 1,
                                                       labelBackground = T,
                                                       # labelFill = "red",
                                                       # labelStroke = "green",
                                                       labelColor = "blue",
                                                       labelOpacity = 0.5,
                                                       innerRadius = 10,
                                                       sortTitlebyCount = T)
                       # , type = "bar"
                       # , type = "horizontal"
                       , categoryField = "categoryfields"
                       , html = "web"
                       , icon = shipIcon
                       , categoryMap =
                         data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                              colors  = c("#F88", "#FA0", "#FF3", "#BFB"),
                              # colors  = c("lightblue", "orange", "lightyellow", "lightgreen"),
                              # colors = c("cyan", "darkorange", "yellow", "#9fca8b"),
                              # icons = c("icons/Icon29.svg", "icons/Icon8.svg", "icons/Icon5.svg", "icons/Icon25.svg"),
                              # strokes = c("#800", "#B60", "#D80", "#070")
                              strokes = "gray"
                         )
                       , group = "clustermarkers"
                       # group = "zipcode",
                       , layerId = "id"
                       , clusterId = "id"
                       , popupFields = c("brewery","address","zipcode", "category")
                       , popupLabels = c("Brauerei","Addresse","PLZ", "Art")
                       , popup = "popup"
                       , label = "label"
                       ## Options #############
                       , markerOptions = markerOptions(interactive = TRUE,
                                                       draggable = TRUE,
                                                       keyboard = TRUE,
                                                       # stroke = 0.1,
                                                       title = "Some Marker Title",
                                                       zIndexOffset = 100,
                                                       opacity = 1,
                                                       riseOnHover = TRUE,
                                                       riseOffset = 400)
                       , legendOptions = list(position = "bottomright", title = "Unfälle im Jahr 2003")
                       , clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE
                                                               , zoomToBoundsOnClick = TRUE
                                                               , spiderfyOnMaxZoom = TRUE
                                                               , removeOutsideVisibleBounds = TRUE
                                                               , spiderLegPolylineOptions = list(weight = 1.5, color = "#222", opacity = 0.5)
                                                               , freezeAtZoom = TRUE
                                                               , clusterPane = "clusterpane"
                                                               , spiderfyDistanceMultiplier = 1
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
