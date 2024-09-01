library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(
  leafletOutput("map", height = "700px"),
  dateInput("date", "Date"),
  sliderInput("time", "Time", 0, max = 24, value = 4, step = 1)
  # actionButton("update", "Update Date")
  )

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      # addTiles() %>%
      # addProviderTiles("CartoDB.DarkMatter") %>%
      addBuildings() %>%
      addMarkers(data = breweries91) %>%
      setView(lng = 13.40438, lat = 52.51836, zoom = 16)
  })
  observe({
  # observeEvent(input$update, {
    # browser()
    date <- input$date
    time <- formatC(input$time, width = 2, format = "d", flag = "0")
    updatetime <- paste0(date, " ", time, ":00:00")
    leafletProxy("map") %>%
      updateBuildingTime(time = as.POSIXct(updatetime))
  })
}
shinyApp(ui, server)

