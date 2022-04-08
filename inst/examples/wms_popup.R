library(shiny)
library(leaflet)
library(leaflet.extras2)
library(XML)

ui <- fluidPage(
  leafletOutput("map", height = "500px"),
  verbatimTextOutput("txt")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      setView(9, 50, 5) %>%
      addWMS(baseUrl = "https://maps.dwd.de/geoserver/dwd/wms", layers = "dwd:BRD_1km_winddaten_10m",
             popupOptions = popupOptions(maxWidth = 600),
             checkempty = TRUE,
             options = WMSTileOptions(
               transparent = TRUE,
               format = "image/png",
               info_format = "text/html",
               tiled = FALSE
             ))
  })
  output$txt <- renderPrint({
    txt <- req(input$map_wms_click$info)
    print(readHTMLTable(txt))
  })
}
shinyApp(ui, server)
