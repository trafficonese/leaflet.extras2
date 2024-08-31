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
data$popup = sprintf("<h3>Customized Popup</h3><b>Name</b>: %s<br><b>Time</b>: %s",
                     data$Name, data$time)
data <- split(data, f = data$Name)


ui <- fluidPage(
  tags$head(tags$style("
                       .leaflet-div-icon {
                           background: transparent !important;
                           border: unset !important;
                       }
                       .divicon {
                          border: 1px solid #666;
                          border-radius: 50%;
                          font-size: 14px;
                          color: black;
                          text-align: center;
                          width: 30px !important;
                          height: 30px !important;
                          padding-top: 3px;
                          font-weight: 800;
                       }
                       .red {
                         background-color: #db0a0a;
                       }
                       .green {
                         background-color: #1fdb0a;
                       }
                       .blue {
                         background-color: #0a34db;
                       }
                       .orange {
                         background-color: #f4ba27;
                       }
                       .purple {
                         background-color: #f127f4;
                       }
                       ")),
  leafletOutput("map", height=800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addPlayback(data = data,
                  popup = ~popup,
                  label = ~label,
                  name = ~Name,
                  popupOptions = popupOptions(offset=c(8,0)),
                  labelOptions  = labelOptions(offset=c(8,-10)),
                  options = playbackOptions(radius = 3, tickLen = 1000000,
                                            speed = 5000,
                                            marker =  htmlwidgets::JS("
                                               function(feature) {
                                                 var CssClass = 'blue';
                                                 var text = null;
                                                 switch (feature.name) {
                                                        case 'ALPHA':
                                                            CssClass = 'red';
                                                            text = 'A';
                                                            break;
                                                        case 'ARLENE':
                                                            CssClass = 'green';
                                                            text = 'B';
                                                            break;
                                                        case 'BRET':
                                                            CssClass = 'blue';
                                                            text = 'C';
                                                            break;
                                                        case 'CINDY':
                                                            CssClass = 'orange';
                                                            text = 'D';
                                                            break;
                                                        case 'DELTA':
                                                            CssClass = 'purple';
                                                            text = 'E';
                                                            break;
                                                 }
                                                 return {
                                                  icon: L.divIcon({
                                                     html: '<div class= \"divicon ' + CssClass + '\">' + text + '</div>'
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
