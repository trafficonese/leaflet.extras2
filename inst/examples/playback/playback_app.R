library(leaflet)
library(leaflet.extras2)
library(shiny)
library(geojsonio)


# drivejson <- system.file("examples/playback/drive.json", package = "leaflet.extras2")
drivejson <- system.file("examples/playback/drive.json", package = "leaflet.extras2")
drivejson1 <- system.file("examples/playback/drive1.json", package = "leaflet.extras2")
csvpath <- system.file("examples/playback/data.csv", package = "leaflet.extras2")
url = "https://raw.githubusercontent.com/hallahan/LeafletPlayback/master/data/demo/drive.json"

asd <- geojson_read(drivejson)                              # "list"
# asd <- jsonlite::read_json(drivejson)                       # "list"
# asd <- paste(readLines(drivejson, warn = F), collapse = "") # "character" containing the JSON
# asd <- read.csv(file = csvpath)                             # "data.frame"
# asd <- as.matrix(asd)                                       # "matrix"
# data.table::setDT(asd)                                      # "data.table" "data.frame"
# sp::coordinates(asd) <- ~x+y                                # "SpatialPointsDataFrame"
# asd <- sf::st_as_sf(asd)                                    # "sf"         "data.frame"
# asd <- drivejson                                            # "character" with JSON path
# asd <- url                                                  # "character" with JSON URL




iconship = makeIcon(
  iconUrl = 'https://cdn0.iconfinder.com/data/icons/man-listening-to-music-with-earphone-headphone/247/listern-music-006-512.png',
  iconWidth = 50, iconHeight = 60, shadowWidth = 55, shadowHeight = 65 ,iconAnchorX = 25, iconAnchorY = 25
)

ui <- fluidPage(
  leafletOutput("map"),
  h4("Clicks"),
  verbatimTextOutput("click"),
  h4("Mouseover"),
  verbatimTextOutput("mouseover")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-123.3, 44.53, 11) %>%
      addPlayback(data = asd, icon = iconship,
                  options = playbackOptions(
                    radius = 3),
                  pathOptions = pathOptions(
                    color = "red", weight = 5,
                    fillColor = "green"
                  ))
  })
  output$click <- renderPrint({
    req(input$map_pb_click)
    input$map_pb_click
  })
  output$mouseover <- renderPrint({
    req(input$map_pb_mouseover)
    input$map_pb_mouseover
  })
}

shinyApp(ui, server)


