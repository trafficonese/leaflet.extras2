library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras2)

# df <- sf::st_as_sf(atlStorms2005)
# df <- df[1,]
#
# dfp <- st_cast(df, "POINT")
# dfp$label = sample(LETTERS[1:20], nrow(dfp), TRUE)
# dfp$popup = sample(LETTERS[1:20], nrow(dfp), TRUE)
# dfp$duratios = sample(c(1000, 2000, 3000, 4000, 5000), nrow(dfp), TRUE)

greenLeafIcon <- makeIcon(
  iconUrl = "https://image.flaticon.com/icons/png/512/905/905567.png",
  iconWidth = 40, iconHeight = 50,
  iconAnchorX = 0, iconAnchorY = 0
)

ui <- fluidPage(
  leafletOutput("map"),
  actionButton("start", "Start"),
  actionButton("stop", "Stop"),
  actionButton("pause", "Pause"),
  actionButton("resume", "Resume"),
  actionButton("addLatLng", "addLatLng"),
  actionButton("moveTo", "moveTo"),
  actionButton("addStation", "addStation"),
  h5("Click Events"),
  verbatimTextOutput("click")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addPolylines(data = df, group = "mapkey") %>%
      # addMovingMarker(data = df, group = "mapkey", icon = icon("cogs"))
      addMovingMarker(data = dfp,
                      duration = ~duratios,
                      # duration = 1000,
                      icon = greenLeafIcon,
                      movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
                      options = list(title="title some"),
                      label=~label, popup=dfp$popup[1],
                      group = "movingmarker"
                      )
  })

  output$click <- renderPrint({
    txt <- req(input$map_movingmarker_click)
    print(txt)
  })
  observeEvent(input$start, {
    leafletProxy("map", session) %>%
      startMoving()
  })
  observeEvent(input$stop, {
    leafletProxy("map", session) %>%
      stopMoving()
  })
  observeEvent(input$pause, {
    leafletProxy("map", session) %>%
      pauseMoving()
  })
  observeEvent(input$resume, {
    leafletProxy("map", session) %>%
      resumeMoving()
  })

  # observeEvent(input$addLatLng, {
  #   leafletProxy("map", session) %>%
  #     addLatLngMoving(latlng, duration)
  # })
  # observeEvent(input$moveTo, {
  #   leafletProxy("map", session) %>%
  #     moveToMoving(latlng, duration)
  # })
  observeEvent(input$addStation, {
    pti <- sample(seq.int(nrow(dfp)), 1, TRUE)
    print(paste("Stay at Point Index:", pti, "for 4000 ms."))
    leafletProxy("map", session) %>%
      addStationMoving(pointIndex = pti,
                       duration = 4000)
  })
}
shinyApp(ui, server)
