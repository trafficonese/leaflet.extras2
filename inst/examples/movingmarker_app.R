library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras2)

df <- sf::st_as_sf(atlStorms2005)[1,]
dfp <- st_cast(df, "POINT")
dfp$duratios = sample(c(1000, 1500, 2000, 2500, 3000), nrow(dfp), TRUE)

shipIcon <- makeIcon(
  iconUrl = "https://image.flaticon.com/icons/png/512/905/905567.png",
  iconWidth = 40, iconHeight = 50,
  iconAnchorX = 0, iconAnchorY = 0
)

ui <- fluidPage(
  leafletOutput("map", height = 650),
  actionButton("start", "Start"),
  actionButton("stop", "Stop"),
  actionButton("pause", "Pause"),
  actionButton("resume", "Resume"),
  actionButton("addLatLng", "addLatLng"),
  actionButton("moveTo", "moveTo"),
  actionButton("addStation", "addStation"),
  actionButton("clear", "Clear Group"),
  actionButton("clearmark", "Clear Marker"),
  actionButton("remove", "Remove Marker"),
  splitLayout(
    div(
      h5("Click Events"),
      verbatimTextOutput("click")
    ),
    div(
      h5("Mouseover Events"),
      verbatimTextOutput("mouseover")
    )
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addPolylines(data = df) %>%
      addMovingMarker(data = dfp,
                      duration = ~duratios,
                      icon = shipIcon,
                      movingOptions = movingMarkerOptions(autostart = TRUE,
                                                          loop = TRUE,
                                                          pauseOnZoom = TRUE),
                      label = "I am a pirate!",
                      popup = "Arrr",
                      group = "movingmarker",
                      layerId = "myid"
                      )
  })

  output$click <- renderPrint({
    txt <- req(input$map_movingmarker_click)
    print(txt)
  })
  output$mouseover <- renderPrint({
    txt <- req(input$map_movingmarker_mouseover)
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

  observeEvent(input$addLatLng, {
    leafletProxy("map", session) %>%
      addLatLngMoving(list(33, -67), 2000)
  })
  observeEvent(input$moveTo, {
    leafletProxy("map", session) %>%
      moveToMoving(list(lng=-65, lat=33), 2000)
  })
  observeEvent(input$addStation, {
    pti <- sample(seq.int(nrow(dfp)), 1, TRUE)
    print(paste("Stay at Point Index:", pti, "for 4000 ms."))
    leafletProxy("map", session) %>%
      addStationMoving(pointIndex = pti,
                       duration = 4000)
  })

  observeEvent(input$clear, {
    leafletProxy("map", session) %>%
      clearGroup("movingmarker")
  })
  observeEvent(input$clearmark, {
    leafletProxy("map", session) %>%
      clearMarkers()
  })
  observeEvent(input$remove, {
    leafletProxy("map", session) %>%
      removeMarker("myid")
  })
}
shinyApp(ui, server)
