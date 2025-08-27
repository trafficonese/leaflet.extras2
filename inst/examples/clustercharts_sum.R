library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
options("shiny.autoreload" = TRUE)

## Icons ##############
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

## Data ##############
data <- sf::st_as_sf(breweries91)
data$category <- sample(c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                        size = nrow(data), replace = TRUE)
data$label <- paste0(data$brewery, "<br>", data$address)
data$id <- paste0("ID", seq.int(nrow(data)))
data$popup <- paste0("<h6>", data$brewery, "</h6><div>", data$address, "</div>")
data$tosum <- sample(1:100, nrow(data), replace = TRUE)
data$tosumlabel <- paste("Sum: ", data$tosum)
data$web <- gsub(">(.*?)<", ">", data$tosum, "<", data$web)
data$web <- ifelse(is.na(data$web), "",
                   paste0("<div class='markerhtml'>", data$web, "</div>"))

## UI ##############
ui <- fluidPage(
  titlePanel("Cluster Markers and calculate Sum/Max/Min/Mean/Median across Categories"),
  tags$head(tags$style("
  .markerhtml {
    height: 100%;
    margin-top: 8px;
    left: 41px;
    position: absolute;
  }")),
  leafletOutput("map", height = 650),
    selectInput("type", "Plot type",
                choices = c("bar", "horizontal", "custom", "pie"),
                selected = "custom"),
    conditionalPanel("input.type == 'custom'",
                     selectInput("aggr", "Aggregation",
                                 choices = c("sum", "max", "min",
                                             "mean", "median"),
                                 selected = "sum")
                     ),
  splitLayout(cellWidths = paste0(rep(20, 4), "%"),
              div(h4("Click Event"), verbatimTextOutput("click")),
              div(h4("Mouseover Event"), verbatimTextOutput("mouseover")),
              div(h4("Mouseout Event"), verbatimTextOutput("mouseout")),
              div(h4("Dragend Event"), verbatimTextOutput("dragend"))
  )
)

## Server ##############
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>% addMapPane("clusterpane", 420) %>%
      addProviderTiles("CartoDB") %>%
      leaflet::addLayersControl(overlayGroups = c("clustermarkers")) %>%
      # addCircleMarkers(data = data, group = "normalcircles", clusterOptions = markerClusterOptions()) %>%
      addClusterCharts(
        data = data
        , options = clusterchartOptions(rmax = 50,
                                        size = 40,
                                        labelBackground = TRUE,
                                        labelOpacity = 1,
                                        strokeWidth = 0.1,
                                        innerRadius = 20,
                                        digits = 0,
                                        sortTitlebyCount = TRUE)
        , aggregation = input$aggr
        , valueField = "tosum"
        , type = input$type
        , categoryField = "category"
        , html = "web"
        , icon = shipIcon
        , categoryMap =
          data.frame(labels = c("Schwer", "Mäßig",
                                "Leicht", "kein Schaden"),
                     colors  = c("lightblue", "orange",
                                 "lightyellow", "lightgreen"))
        , group = "clustermarkers"
        , layerId = "id"
        , clusterId = "id"
        , popupFields = c("id", "brewery", "address", "zipcode",
                          "category", "tosum")
        , popupLabels = c("id", "Brauerei", "Addresse", "PLZ", "Art", "tosum")
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
        , legendOptions = list(position = "bottomright",
                               title = "Unfälle im Jahr 2003")
        , clusterOptions = markerClusterOptions(
            showCoverageOnHover = TRUE,
            zoomToBoundsOnClick = TRUE,
            spiderfyOnMaxZoom = TRUE,
            removeOutsideVisibleBounds = TRUE,
            spiderLegPolylineOptions = list(weight = 1.5, color = "#222",
                                            opacity = 0.5),
            freezeAtZoom = TRUE,
            clusterPane = "clusterpane",
            spiderfyDistanceMultiplier = 2
        )
        , labelOptions = labelOptions(opacity = 0.8, textsize = "14px")
        , popupOptions = popupOptions(maxWidth = 900, minWidth = 200,
                                      keepInView = TRUE)
      )
  })
  output$click <- renderPrint({input$map_marker_click})
  output$mouseover <- renderPrint({input$map_marker_mouseover})
  output$mouseout <- renderPrint({input$map_marker_mouseout})
  output$dragend <- renderPrint({input$map_marker_dragend})
}
shinyApp(ui, server)
