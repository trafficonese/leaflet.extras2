library(shiny)
library(leaflet)
library(leaflet.extras2)
library(XML)


ui <- fluidPage(
  leafletOutput("map", height = "500px"),
  actionButton("group", "Clear Group"),
  actionButton("clear", "Clear WMS"),
  actionButton("remov", "Remove WMS"),
  verbatimTextOutput("txt")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles(group = "base") %>%
      addWMS(baseUrl = "http://ows.terrestris.de/osm/service",
             layers = c("TOPO-WMS", "OSM-Overlay-WMS"),
             group = "wmsgroup",
             options = leaflet::WMSTileOptions(
               transparent = TRUE,
               format = "image/png",
               info_format = "text/html",
               tiled = FALSE
             )) %>%
      addLayersControl(baseGroups = "base",
                       overlayGroups = c("TOPO-WMS", "OSM-Overlay-WMS"))

  })
  observeEvent(input$group, {
    leafletProxy("map", session) %>%
      clearGroup("TOPO-WMS")
  })
  observeEvent(input$clear, {
    leafletProxy("map", session) %>%
      clearTiles()
  })
  observeEvent(input$remov, {
    leafletProxy("map", session) %>%
      removeTiles(layerId = "TOPO-WMS")
  })
  output$txt <- renderPrint({
    txt <- req(input$map_wms_click$info)
    print(readHTMLTable(txt))
  })
}
shinyApp(ui, server)
