library(leaflet)
library(leaflet.extras2)
library(shiny)
library(sf)
library(mapview)

## Single Trail ##############
# trail_pts <- sf::st_line_sample(x = st_cast(mapview::trails[10,], "LINESTRING"), n = 100)
# trail_pts <- st_transform(trail_pts, 4326)
# data <- sf::st_as_sf(st_cast(trail_pts, "POINT"))
# colnames(data) <- "geometry"
# st_geometry(data) <- "geometry"
# data$time = as.POSIXct(
#   seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))
# data <- data[, c("time","geometry")]

## Multiple Trails ##############
n = 150
rows <- c(10, 21)
trail_pts <- sf::st_line_sample(x = st_cast(mapview::trails[rows,], "LINESTRING"), n = n)
trail_pts <- st_transform(trail_pts, 4326)
data <- sf::st_as_sf(st_cast(trail_pts, "POINT"))
colnames(data) <- "geometry"
st_geometry(data) <- "geometry"
nrows <- length(rows)
data$id <- rep(1:nrows, each = n)
time <- as.POSIXct(seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)/nrows))
data$time <- rep(time, nrows)
data <- data[, c("id", "time","geometry")]
data <- split(data, data$id)

## Icon #################
iconship = makeIcon(
  iconUrl = 'https://cdn0.iconfinder.com/data/icons/man-listening-to-music-with-earphone-headphone/247/listern-music-006-512.png',
  iconWidth = 30, iconHeight = 35, shadowWidth = 30, shadowHeight = 35,
  iconAnchorX = 0
)

## UI #################
ui <- fluidPage(
  leafletOutput("map", height = "700px"),
  h4("Clicks"),
  verbatimTextOutput("click"),
  h4("Mouseover"),
  verbatimTextOutput("mouseover")
)

## Server ###############
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addPlayback(data = data, icon = iconship,
                  options = playbackOptions(
                    color = list("red", "green"),
                    radius = 3),
                  pathOpts = pathOptions(weight = 5))
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

