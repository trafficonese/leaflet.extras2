library(shiny)
library(leaflet)
library(leaflet.extras2)

## Include your API-Key
# Sys.setenv("OPENWEATHERMAP" = 'Your_API_Key')
apikey <- Sys.getenv("OPENWEATHERMAP")

ui <- fluidPage(
  leafletOutput("map", height = "700px"),
  ## Buttons for Overlay Tiles
  actionButton("clgr", "Clear Group"),
  actionButton("higr", "Hide Group"),
  actionButton("shgr", "Show Group"),
  actionButton("rmti", "Remove Tiles"),
  ## Buttons for Current Markers
  actionButton("clgrc", "Clear Group - Current"),
  actionButton("higrc", "Hide Group - Current"),
  actionButton("shgrc", "Show Group - Current"),
  actionButton("rmtic", "Remove Marker - Current"),

  uiOutput("popuptxt")
)


owmlayers <- c("clouds", "pressure",
            "precipitation", "rain", "wind")

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>% setView(9, 50, 11) %>%
      addOpenweatherTiles(apikey = apikey,
                          layers = owmlayers,
                          layerId = owmlayers,
                          group = owmlayers) %>%
      addOpenweatherCurrent(apikey = apikey,
                            group = "currentgr", layerId = "currentid",
                            options = openweatherCurrentOptions(
                              lang = "de",
                              temperatureUnit = "F",
                              temperatureDigits = 2,
                              speedUnit = 'kmh',
                              speedDigits = 3,
                              popup = TRUE,
                              # markerFunction = htmlwidgets::JS('function(data) {
                              #                                  return L.marker([data.coord.Lat, data.coord.Lon]);}'),
                              # popupFunction = htmlwidgets::JS('function(data) {
                              #                                 return L.popup().setContent(typeof data.name != "undefined" ? data.name : data.id);}'),
                              useLocalTime = FALSE
                            )) %>%
      addLayersControl(overlayGroups = owmlayers)
  })

  observeEvent(input$clgr , {
    leafletProxy("map") %>%
      clearGroup(group = "pressure")
  })
  observeEvent(input$higr , {
    leafletProxy("map") %>%
      hideGroup(group = "pressure")
  })
  observeEvent(input$shgr , {
    leafletProxy("map") %>%
      showGroup(group = "pressure")
  })
  observeEvent(input$rmti , {
    leafletProxy("map") %>%
      removeTiles(layerId = "precipitation")
  })

  observeEvent(input$clgrc , {
    leafletProxy("map") %>%
      clearGroup(group = "currentgr")
  })
  observeEvent(input$higrc , {
    leafletProxy("map") %>%
      hideGroup(group = "currentgr")
  })
  observeEvent(input$shgrc , {
    leafletProxy("map") %>%
      showGroup(group = "currentgr")
  })
  observeEvent(input$rmtic , {
    leafletProxy("map") %>%
      removeMarker(layerId = "currentid")
  })

  output$popuptxt <- renderUI({
    txt <- req(input$map_owm_click)
    HTML(txt$content)
  })
}

shinyApp(ui, server)
