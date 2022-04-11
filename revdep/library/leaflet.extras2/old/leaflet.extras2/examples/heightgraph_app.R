library(shiny)
library(leaflet)
library(leaflet.extras2)
library(sf)
library(sfheaders)

data <- st_cast(st_as_sf(leaflet::atlStorms2005[1,]), "LINESTRING")
data <- st_transform(data, 4326)
data <- data.frame(st_coordinates(data))
data$elev <-  runif(nrow(data), 10, 500)
data$L1 <- round(seq.int(1, 4, length.out = nrow(data)))
data <- sfheaders::sf_linestring(data, x = "X", y = "Y", z = "elev", linestring_id = "L1")
data$steepness <- 1:nrow(data)
data$suitability <- nrow(data):1
data$popup <- apply(data, 1, function(x) {
  sprintf("Steepness: %s<br>Suitability: %s", x$steepness, x$suitability)
})

ui <- fluidPage(
  leafletOutput("map", height = "700px"),
  actionButton("hideGroup", "hideGroup"),
  actionButton("showGroup", "showGroup"),
  actionButton("clearGeoJSON", "clearGeoJSON"),
  actionButton("clearControls", "clearControls"),
  actionButton("removeControl", "removeControl"),

  h4("Clicks"),
  verbatimTextOutput("click"),
  h4("Mouseover"),
  verbatimTextOutput("mouseover"),
  h4("Mouseout"),
  verbatimTextOutput("mouseout")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      addHeightgraph(color = "red", columns = c("steepness", "suitability"),
                     opacity = 1, data = data, group = "heightgraph",
                     options = heightgraphOptions(
                       width = 800,
                       mappings = list(
                         "steepness" =
                           list(
                             "1" = list(
                               "text"="1-3%",
                               "color"="#a9befc"),
                             "2" = list(
                               "text"="4-6%",
                               "color"="#6f93fc"),
                             "3" = list(
                               "text"="4-6%",
                               "color"="#2d62fc"),
                             "4" = list(
                               "text"="4-6%",
                               "color"="#0026ff")
                             ),
                         "suitability" =
                           list(
                             "1" = list(
                               "text"="Very Good",
                               "color"="green"),
                             "2" = list(
                               "text"="Moderate",
                               "color"="yellow"),
                             "3" = list(
                               "text"="Bad",
                               "color"="orange"),
                             "4" = list(
                               "text"="Very Bad",
                               "color"="red")
                           )
                       ),
                       highlightStyle = list(weight= 10,
                                             opacity= 0.8,
                                             color= 'orange'),
                       translation = list(distance= "Distanz",
                                          elevation= "Höhe",
                                          segment_length= "Segment Länge",
                                          type= "Typ",
                                          legend= "Legende"),
                       xTicks = 3)
      ) %>%
      addLayersControl(baseGroups = "base", overlayGroups = "heightgraph")
  })
  observeEvent(input$hideGroup, {
    leafletProxy("map") %>%
      leaflet::hideGroup("heightgraph")
  })
  observeEvent(input$showGroup, {
    leafletProxy("map") %>%
      leaflet::showGroup("heightgraph")
  })
  observeEvent(input$clearGeoJSON, {
    leafletProxy("map") %>%
      clearGeoJSON()
  })
  observeEvent(input$clearControls, {
    leafletProxy("map") %>%
      clearControls()
  })
  observeEvent(input$removeControl, {
    leafletProxy("map") %>%
      removeControl("hg_control")
  })

  output$click <- renderPrint({
    txt <- req(input$map_heightgraph_click)
    print(txt)
  })
  output$mouseover <- renderPrint({
    txt <- req(input$map_heightgraph_mouseover)
    print(txt)
  })
  output$mouseout <- renderPrint({
    txt <- req(input$map_heightgraph_mouseout)
    print(txt)
  })
}
shinyApp(ui, server)
