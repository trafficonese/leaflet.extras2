library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)
df <- st_as_sf(breweries91)

ui <- fluidPage(
  tags$head(tags$style(".btn-default {
    width: 49%; display: inline-block; margin-top: 5px; }")),
  h4("Drag/Zoom/Pan the individual maps"),
  splitLayout(cellWidths = rep("33%", 3),
    leafletOutput("map1", height = 700),
    leafletOutput("map2", height = 700),
    leafletOutput("map3", height = 700)
  ),
  div(
    actionButton("sync", label = "Sync all maps"),
    actionButton("unsync", label = "Unsync all maps")
  ),
  splitLayout(
    div(
      actionButton("isSynced1", label = "Is map1 synced with any map?",
                   width = "100%"),
      verbatimTextOutput("issyncprint1")
    ),
    div(
      actionButton("isSynced2", label = "Is map2 synced with map1?",
                   width = "100%"),
      verbatimTextOutput("issyncprint2")
    )
  )
)

server <- function(input, output, session) {
  output$map1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df, color = "red")
  })
  output$map2 <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(provider = "CartoDB") %>%
      addCircleMarkers(data = df, color = "orange")
  })
  output$map3 <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(provider = "CartoDB.DarkMatter") %>%
      addCircleMarkers(data = df[1:10, ], color = "blue") %>%
      addLeafletsync(
        ids = NULL,
        synclist = list(map1 = c("map2", "map3"), map2 = c("map3")),
        options = leafletsyncOptions(noInitialSync = FALSE,
                                     syncCursor = TRUE))
  })
  observeEvent(input$sync, {
    leafletProxy("map1") %>%
      addLeafletsync(c("map1", "map2", "map3"))
  })
  observeEvent(input$unsync, {
    leafletProxy("map1") %>%
      unsync(id = "map1", unsyncids = c("map2", "map3")) %>%
      unsync(id = "map2", unsyncids = c("map1", "map3")) %>%
      unsync(id = "map3", unsyncids = c("map1", "map2"))
  })

  observeEvent(input$isSynced1, {
    leafletProxy("map1") %>%
      isSynced("map1")
  })
  observeEvent(input$isSynced2, {
    leafletProxy("map1") %>%
      isSynced(id = "map2", syncwith = "map1")
  })
  output$issyncprint1 <- renderPrint({
    print(input$map1_synced)
  })
  output$issyncprint2 <- renderPrint({
    print(input$map2_synced)
  })
}
shinyApp(ui, server)
