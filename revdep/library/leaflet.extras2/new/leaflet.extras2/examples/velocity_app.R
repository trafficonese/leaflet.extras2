library(shiny)
library(leaflet)
library(leaflet.extras2)

# content <- "https://raw.githubusercontent.com/danwild/leaflet-velocity/master/demo/wind-global.json"
# content <- "https://raw.githubusercontent.com/danwild/leaflet-velocity/master/demo/water-gbr.json"
content <- "https://raw.githubusercontent.com/danwild/leaflet-velocity/master/demo/wind-gbr.json"

ui <- fluidPage(
  leafletOutput("map", height = "800px")
  , actionButton("showGroup", "showGroup")
  , actionButton("hideGroup", "hideGroup")
  , actionButton("removeVelocity", "removeVelocity")
  , actionButton("clearGroup", "clearGroup"), br()
  , actionButton("setOptions", "setOptions")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      setView(145, -20, 4) %>%
      addVelocity(content = content, group = "Wind", layerId = "veloid",
                  options = velocityOptions(
                    position = "bottomright",
                    emptyString = "Nothing to see",
                    speedUnit = "k/h",
                    lineWidth = 2,
                    colorScale = rainbow(12))) %>%
      addLayersControl(baseGroups = "base", overlayGroups = "Wind")
  })
  observeEvent(input$showGroup, {
    leafletProxy("map") %>%
      showGroup("Wind")
  })
  observeEvent(input$hideGroup, {
    leafletProxy("map") %>%
      hideGroup("Wind")
  })
  observeEvent(input$removeVelocity, {
    leafletProxy("map") %>%
      removeVelocity("veloid")
  })
  observeEvent(input$clearGroup, {
    leafletProxy("map") %>%
      clearGroup("Wind")
  })
  observeEvent(input$setOptions, {
    leafletProxy("map") %>%
      setOptionsVelocity(layerId = "veloid", options = velocityOptions(
        position = "topleft",
        emptyString = "There is no wind",
        speedUnit = "m/s",
        lineWidth = 4,
        colorScale = heat.colors(12),
        particleAge = 10
      ))
  })
}

shinyApp(ui, server)
