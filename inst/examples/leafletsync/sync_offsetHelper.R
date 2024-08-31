library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)
df <- st_as_sf(breweries91)

ui <- fluidPage(
  h4("2 Maps with offset using 'L.Sync.offsetHelper'"),
  tags$head(tags$style(".shiny-split-layout {margin-bottom: 4px;}")),
  splitLayout(cellWidths = rep("50%",2),
              leafletOutput("map1", height = 800),
              leafletOutput("map2", height = 800),
  ),
  actionButton("sync", label = "Sync the maps"),
  actionButton("unsync", label = "Unsync the maps")
)

server <- function(input, output, session) {
  output$map1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df, color = "red")
  })
  output$map2 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      ### The following line is needed, otherwise the plugin is not yet loaded and L.Sync will be undefined
      addLeafletsyncDependency() %>%
      addCircleMarkers(data = df, color = "orange")
  })
  observe({
    leafletProxy("map1") %>%
      addLeafletsync(ids = c("map1","map2"),
                     options = list(
                       "map1" = leafletsyncOptions(
                         syncCursor = FALSE,noInitialSync = FALSE,
                         offsetFn = JS("L.Sync.offsetHelper([0, 0.5], [0, 0])")),
                       "map2" = leafletsyncOptions(
                         syncCursor = FALSE,noInitialSync = FALSE,
                         offsetFn = JS("L.Sync.offsetHelper([0, 0], [0, 0.5])"))
                     )
      )
  })

  observeEvent(input$sync, {
    leafletProxy("map1") %>%
      addLeafletsync(c("map1","map2"))
  })
  observeEvent(input$unsync, {
    leafletProxy("map1") %>%
      unsync(id = "map1", unsyncids = "map2") %>%
      unsync(id = "map2", unsyncids = "map1")
  })
}
shinyApp(ui, server)






