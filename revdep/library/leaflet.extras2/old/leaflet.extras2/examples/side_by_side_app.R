library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(
  leafletOutput("map"),
  actionButton("removeSidebyside", "removeSidebyside")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(quakes) %>%
      addMapPane("left", zIndex = 0) %>%
      addMapPane("right", zIndex = 0) %>%
      addTiles(group = "base", layerId = "baseid",
               options = pathOptions(pane = "right")) %>%
      addProviderTiles(providers$CartoDB.DarkMatter, group="carto", layerId = "cartoid",
                       options = pathOptions(pane = "left")) %>%
      addCircleMarkers(data = breweries91[1:15,], color = "blue", group = "blue",
                       options = pathOptions(pane = "left")) %>%
      addCircleMarkers(data = breweries91[15:20,], color = "yellow", group = "yellow") %>%
      addCircleMarkers(data = breweries91[15:30,], color = "red", group = "red",
                       options = pathOptions(pane = "right")) %>%
      addLayersControl(overlayGroups = c("blue","red", "yellow")) %>%
      addSidebyside(layerId = "sidecontrols",
                    rightId = "baseid",
                    leftId = "opencycle")
  })
  observeEvent(input$removeSidebyside, {
    leafletProxy("map") %>%
      removeSidebyside("sidecontrols")
  })
}

shinyApp(ui, server)
