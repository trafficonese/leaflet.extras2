library(shiny)
library(leaflet)
library(leaflet.extras2)
options("shiny.autoreload" = TRUE)

ui <- fluidPage(
  actionButton("remove", label = "remove"),
  leafletOutput("map", height = 900),
  div(h4("Geosearch Results"),
      verbatimTextOutput("results"))
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addGeosearch(provider = geosearchProvider(
        type = "OpenStreetMap",
        options = list(
          params = list(
            'accept-language'= 'de'
            , countrycodes= 'at'
            , addressdetails= 1
            , extratags = 1
            # , viewbox = c(16.36,48.20,16.38,48.25)
            # , bounded = 1
          )
        )),
        options = list(style = "button",
                       position = "topleft",
                       resetButton = "X",
                       notFoundMessage = "NOTHING FOUND",
                       autoComplete = TRUE,
                       autoCompleteDelay = 250,
                       showMarker = TRUE,
                       showPopup = TRUE,
                       maxMarkers = 3,
                       retainZoomLevel = FALSE,
                       animateZoom = TRUE,
                       autoClose = TRUE,
                       searchLabel = "Enter YOUR address",
                       keepResult = TRUE,
                       updateMap = TRUE))
  })
  observeEvent(input$remove, {
    leafletProxy("map") %>%
      removeGeosearch()
  })

  output$results <- renderPrint({
    txt <- req(input$map_geosearch_result)
    print(txt)
  })
}
shinyApp(ui, server)
