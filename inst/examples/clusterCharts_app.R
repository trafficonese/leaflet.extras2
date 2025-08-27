library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
options("shiny.autoreload" = TRUE)


shipIcon <- iconList(
  "Schwer"       = makeIcon("./icons/Icon5.svg", iconWidth = 32, iconHeight = 32),
  "Mäßig"        = makeIcon("./icons/Icon8.svg", iconWidth = 32, iconHeight = 32),
  "Leicht"       = makeIcon("./icons/Icon25.svg", iconWidth = 32, iconHeight = 32),
  "kein Schaden" = makeIcon("./icons/Icon29.svg", iconWidth = 32, iconHeight = 32)
)

data <- sf::st_as_sf(breweries91)
data$categoryfields <- sample(c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                              size = nrow(data), replace = TRUE)
data$label <- paste0(data$brewery, "<br>", data$address)
data$id <- paste0("ID", seq.int(nrow(data)))
data$popup <- paste0("<h6>", data$brewery, "</h6><div>", data$address, "</div>")
data$web <- gsub(">(.*?)<", ">LINK<", data$web)
data$web <- ifelse(is.na(data$web), "",
                   paste0("<div class='markerhtml'>", data$web, "</div>"))
data$tosum <- sample(1:100, nrow(data), replace = TRUE)

ui <- fluidPage(
  titlePanel("Cluster Markers and Calculate Category Counts"),
  tags$head(tags$style("
  .inputs {
    display: flex;
  }
  .inputdiv {
    position: relative;
    z-index: 100000000;
  }
  .markerhtml {
    height: 100%;
    margin-top: 8px;
    left: 41px;
    position: absolute;
  }")),
  div(class="inputdiv",
      div(class="inputs",
      selectInput("type", "Plot type", choices = c("bar","horizontal", "pie"),
                  selected = "pie"),
      numericInput("stroke", "strokeWidth", 1, 1, 10),
      numericInput("rmax", "MaxRadius", 50, 1, 150),
      numericInput("innerRadius", "InnerRadius", 10, 1, 100),
      numericInput("width", "Width", 50, 1, 150),
      numericInput("height", "Height", 50, 1, 150),
      selectInput("labelBackground", "labelBackground",
                  choices = c(TRUE, FALSE)),
      selectInput("sortTitlebyCount", "sortTitlebyCount",
                  choices = c(TRUE, FALSE)),
      numericInput("labelOpacity", "labelOpacity", 0.5, 0, 1, step = 0.1),
  )),
  leafletOutput("map", height = 650),
  splitLayout(cellWidths = paste0(rep(20,4), "%"),
              div(h4("Click Event"), verbatimTextOutput("click")),
              div(h4("Mouseover Event"), verbatimTextOutput("mouseover")),
              div(h4("Mouseout Event"), verbatimTextOutput("mouseout")),
              div(h4("Dragend Event"), verbatimTextOutput("dragend"))
              )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>% addMapPane("clusterpane", 420) %>%
      addProviderTiles("CartoDB") %>%
      leaflet::addLayersControl(overlayGroups = c("clustermarkers")) %>%
      # addCircleMarkers(data = data, group = "normalcircles", clusterOptions = markerClusterOptions()) %>%
      addClusterCharts(data = data
                       , options = clusterchartOptions(
                         rmax = input$rmax,
                         size = c(100,40),
                         # size=40,
                         width = input$width,
                         height = input$height,
                         strokeWidth = input$stroke,
                         labelBackground = as.logical(input$labelBackground),
                         # labelFill = "red",
                         # labelStroke = "green",
                         labelColor = "blue",
                         labelOpacity = input$labelOpacity,
                         innerRadius = input$innerRadius,
                         sortTitlebyCount = as.logical(input$sortTitlebyCount))
                       # , type = "bar"
                       # , type = "horizontal"
                       , type = input$type
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
                              strokes = "black"
                         )
                       , group = "clustermarkers"
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
                                                               , spiderfyDistanceMultiplier = 34
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
