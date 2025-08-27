library(leaflet)
library(leaflet.extras2)
library(sf)
library(shiny)

data <- sf::st_as_sf(leaflet::atlStorms2005[1,])
data <- suppressWarnings(st_cast(data, "POINT"))
data$time <- as.POSIXct(
  seq.POSIXt(as.POSIXct(paste0(2020-nrow(data)+1,"-01-01")),
             as.POSIXct("2020-01-01"), by = "year"))
data1 <- sf::st_as_sf(leaflet::atlStorms2005[2,])
data1 <- suppressWarnings(st_cast(data1, "POINT"))
data1$time <- as.POSIXct(
  seq.POSIXt(as.POSIXct(paste0(2020-nrow(data1)+1,"-01-01")),
             as.POSIXct("2020-01-01"), by = "year"))
data <- rbind(data, data1)

ui <- fluidPage(leafletOutput("map", height = "600px"))
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    opac <- runif(nrow(data), 0.5, 1)
    leaflet() %>%
      addTiles() %>%
      addTimeslider(
        data = data,
        color = colorNumeric("viridis",
                             seq.int(nrow(data)))(seq.int(nrow(data))),
        opacity = opac, fillOpacity = opac,
        radius = sample(5:15, nrow(data), TRUE),
        popupOptions = popupOptions(maxWidth = 1000,
                                    closeOnClick = TRUE,
                                    closeButton = FALSE),
        popup = ~sprintf("Time: %s<br>Name: %s<br>MaxWind: %s<br>MinPress: %s",
                         time, Name, MaxWind, MinPress),
        label = ~sprintf("Time: %s<br>Name: %s", time, Name),
        labelOptions = labelOptions(noHide = TRUE),
        options = timesliderOptions(
          alwaysShowDate = TRUE,
          sameDate = TRUE,
          range = FALSE))
  })
}
shinyApp(ui, server)

