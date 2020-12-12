library(leaflet)
library(leaflet.extras2)
library(sf)
library(geojsonsf)
library(shiny)

data <- sf::st_as_sf(leaflet::atlStorms2005[1,])
data <- st_cast(data, "POINT")
data$time = as.POSIXct(seq.POSIXt(as.POSIXct("2010-01-01"), as.POSIXct("2020-01-01"), by = "year"))


ui <- fluidPage(leafletOutput("map", height = "600px"))
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    opac <- runif(nrow(data), 0.5, 1)
    leaflet() %>%
      addTiles() %>%
      addTimeslider(data = data,
                    color = colorNumeric("viridis", seq.int(nrow(data)))(seq.int(nrow(data))),
                    opacity = opac, fillOpacity = opac,
                    radius = sample(5:15, nrow(data), TRUE),
                    popupOptions = popupOptions(maxWidth = 1000, closeOnClick= TRUE, closeButton = FALSE),
                    popup = ~sprintf("Time: %s<br>Name: %s<br>MaxWind: %s<br>MinPress: %s",
                                     time, Name, MaxWind, MinPress),
                    options = timesliderOptions(
                      startTimeIdx = 2,
                      follow = 3,
                      alwaysShowDate = TRUE,
                      range = FALSE))
  })
}
shinyApp(ui, server)

