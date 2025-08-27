library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(
  leafletOutput("map"),
  actionButton("goBack", "Go Back in Leaflet History"),
  actionButton("goFwd", "Go Forward in Leaflet History"),
  actionButton("clHi", "Clear History"),
  actionButton("clFu", "Clear Future"),
  actionButton("remo", "Remove Control"),
  actionButton("clear", "Clear Control"),
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addHistory(layerId = "histid",
                 options = historyOptions(
                   backText = "Back",
                   forwardText = "Forward",
                   position = "bottomleft"))
  })
  observeEvent(input$goBack, {
    leafletProxy("map") %>%
      goBackHistory()
  })
  observeEvent(input$goFwd, {
    leafletProxy("map") %>%
      goForwardHistory()
  })
  observeEvent(input$clHi, {
    leafletProxy("map") %>%
      clearHistory()
  })
  observeEvent(input$clFu, {
    leafletProxy("map") %>%
      clearFuture()
  })
  observeEvent(input$remo, {
    leafletProxy("map") %>%
      removeControl(layerId = "histid")
  })
  observeEvent(input$clear, {
    leafletProxy("map") %>%
      clearControls()
  })
}

shinyApp(ui, server)
