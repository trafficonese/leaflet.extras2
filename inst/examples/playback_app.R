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
# data$popup1 <- paste("This is a <b>popup</b> for <em>time:", data$time,"</em>")
# data$label1 <- paste("Time: ", data$time)

## Multiple Trails ##############
n <- 150
rows <- c(10, 21)
trail_pts <- sf::st_line_sample(x = st_cast(mapview::trails[rows, ], "LINESTRING"), n = n)
trail_pts <- st_transform(trail_pts, 4326)
data <- sf::st_as_sf(st_cast(trail_pts, "POINT"))
colnames(data) <- "geometry"
st_geometry(data) <- "geometry"
nrows <- length(rows)
data$id <- rep(1:nrows, each = n)
time <- as.POSIXct(seq.POSIXt(Sys.time() - 1000, Sys.time(),
                              length.out = nrow(data) / nrows))
data$time <- rep(time, nrows)
data <- data[, c("id", "time", "geometry")]
data$popup1 <- paste("This is a <b>popup</b> for Track ID: <em>",
                     data$id, "</em> and <em>time:", data$time, "</em>")
data$label1 <- paste("Track ID: ",data$id, "<br>", data$time)
data <- split(data, data$id)

## Icon #################
iconship <- makeIcon(
  iconUrl = "https://cdn0.iconfinder.com/data/icons/man-listening-to-music-with-earphone-headphone/247/listern-music-006-512.png",
  iconWidth = 30, iconHeight = 35, shadowWidth = 30, shadowHeight = 35,
  iconAnchorX = 0, iconAnchorY = 0
)

## UI #################
ui <- fluidPage(
  splitLayout(
    cellWidths = c("60%", "40%"),
      leafletOutput("map", height = "800px"),
      div(
        h4("Clicks"),
        verbatimTextOutput("click"),
        h4("Mouseover"),
        verbatimTextOutput("mouseover")
      )
  ),
  actionButton("rm", "Remove Playback")
)

## Server ###############
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(options = list(closePopupOnClick = FALSE)) %>%
      addProviderTiles("CartoDB.Positron", group = "CartoDB") %>%
      # addCircleMarkers(data=sf::st_as_sf(breweries), radius = 1,
      #                  popup="I am a regular Popup") %>%
      leafem::addMouseCoordinates() %>%
      addPlayback(data = data, icon = iconship,
                  popup = ~popup1,
                  # popup = ~sprintf("this popup is created with sprintf:<br> %s",popup1),
                  label = ~label1,
                  options = playbackOptions(
                    maxInterpolationTime = 6, color = list("red", "green"),
                    speed = 250, orientIcons = FALSE,
                    playCommand = "Let's go", stopCommand = "Stop it!",
                    transitionpopup = TRUE, transitionlabel = TRUE,
                    locale = list(locale = "de-DE",
                                  options = list(weekday = "long",
                                                 year = "numeric",
                                                 month = "long",
                                                 day = "numeric",
                                                 timeZone = "UTC",
                                                 timeZoneName = "short")),
                    radius = 3),
                  popupOptions = popupOptions(maxWidth = 700,
                                              closeOnClick = TRUE),
                  labelOptions = labelOptions(
                    interactive = FALSE, clickable = NULL,
                    noHide = TRUE, permanent = FALSE,
                    className = "", direction = "auto",
                    offset = c(0, 0), opacity = 1,
                    textsize = "10px", textOnly = FALSE,
                    style = NULL, sticky = TRUE
                    ),
                  pathOpts = pathOptions(weight = 5))
  })
  output$click <- renderPrint({
    inp <- req(input$map_pb_click)
    print(inp)
  })
  output$mouseover <- renderPrint({
    req(input$map_pb_mouseover)
    input$map_pb_mouseover
  })
  observeEvent(input$rm, {
    leafletProxy("map", session) %>%
      removePlayback()
  })
}

shinyApp(ui, server)
