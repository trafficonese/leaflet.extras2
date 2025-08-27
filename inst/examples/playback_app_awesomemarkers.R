library(shiny)
library(sf)
library(leaflet)
library(leaflet.extras2)

data(atlStorms2005)
data <- sf::st_as_sf(leaflet::atlStorms2005)[1:5,]
data$Name <- as.character(data$Name)
data <- st_cast(data, "POINT")
data$time <- unlist(lapply(rle(data$Name)$lengths, function(x) {
  seq.POSIXt(as.POSIXct(Sys.Date()-2), as.POSIXct(Sys.Date()), length.out = x)
}))
data$time <- as.POSIXct(data$time, origin="1970-01-01")
data$label <- paste0("Time: ", data$time)
data$popup <- sprintf("<h3>Customized Popup</h3><b>Name</b>: %s<br><b>Time</b>: %s",
                     data$Name, data$time)
data <- split(data, f = data$Name)


ui <- fluidPage(
  leafletOutput("map", height=800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    map <- leaflet() %>%
      addTiles()
    map$dependencies <- c(map$dependencies,
                          leaflet:::leafletAwesomeMarkersDependencies())
    map %>%
      addPlayback(data = data,
                  popup = ~popup,
                  label = ~label,
                  name = ~Name,
                  popupOptions = popupOptions(offset=c(0,-35)),
                  options = playbackOptions(radius = 3, tickLen = 1000000,
                                            speed = 5000,
                                            marker =  htmlwidgets::JS("
                                               function(feature) {
                                                 var color = 'blue';
                                                 var icon = null;
                                                 switch (feature.name) {
                                                        case 'ALPHA':
                                                            color = 'red';
                                                            icon = 'glass';
                                                            break;
                                                        case 'ARLENE':
                                                            color = 'green';
                                                            icon = 'flag';
                                                            break;
                                                        case 'BRET':
                                                            color = 'blue';
                                                            icon = 'star';
                                                            break;
                                                        case 'CINDY':
                                                            color = 'orange';
                                                            icon = 'home';
                                                            break;
                                                        case 'DELTA':
                                                            color = 'purple';
                                                            icon = 'bookmark';
                                                            break;
                                                 }
                                                 return {
                                                  icon: L.AwesomeMarkers.icon({
                                                             icon: icon,
                                                             markerColor: color
                                                             })
                                                  }
                                                }"),
                                            maxInterpolationTime = 10000,
                                            transitionpopup = FALSE,
                                            transitionlabel = FALSE,
                                            playCommand = "Let's go",
                                            stopCommand = "Stop it!",
                                            color = c("red","green","blue",
                                                           "orange","purple")),
                                                           pathOpts = pathOptions(weight = 5))
  })
}
shinyApp(ui, server)
