library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)
df <- st_as_sf(breweries91)

ui <- fluidPage(
  h4("4 Maps synced with a 'synclist'"),
  tags$head(tags$style(".shiny-split-layout {margin-bottom: 4px;}")),
  splitLayout(cellWidths = rep("50%",2),
              leafletOutput("map1", height = 400),
              leafletOutput("map2", height = 400),
  ),
  splitLayout(cellWidths = rep("50%",2),
              leafletOutput("map3", height = 400),
              leafletOutput("map4", height = 400)
  ),
  actionButton("sync", label = "Sync all maps"),
  actionButton("unsync", label = "Unsync all maps")
)

server <- function(input, output, session) {
  output$map1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df, color = "red") %>%
      setView(lng = 10.55, lat = 49.76, zoom = 10)
  })
  output$map2 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df, color = "orange")
  })
  output$map3 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df, color = "purple")
  })
  output$map4 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df, color = "blue")
  })
  observe({
    leafletProxy("map1") %>%
      addLeafletsync(
        synclist = list(mapa = c("map2","map4"),
                        map2 = c("map1"),
                        map3 = c("map1","map2","map4"),
                        map4 = c("map2")),
        options = leafletsyncOptions(syncCursor = FALSE,
                                     noInitialSync = FALSE))
  })

  observeEvent(input$sync, {
    leafletProxy("map1") %>%
      addLeafletsync(
        synclist = list(map1 = c("map2","map4"),
                        map2 = c("map1"),
                        map3 = c("map1","map2","map4"),
                        map4 = c("map2")),
        options = leafletsyncOptions(syncCursor = FALSE,
                                     noInitialSync = FALSE))
  })
  observeEvent(input$unsync, {
    leafletProxy("map1") %>%
      unsync(id = "map1", unsyncids = c("map2","map3","map4")) %>%
      unsync(id = "map2", unsyncids = c("map1","map3","map4")) %>%
      unsync(id = "map3", unsyncids = c("map1","map2","map4")) %>%
      unsync(id = "map4", unsyncids = c("map1","map2","map3"))
  })
}
shinyApp(ui, server)






