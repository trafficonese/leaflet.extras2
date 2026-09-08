library(shiny)
library(leaflet)
library(leaflet.extras2)

times <- as.Date(c("2022-11-08", "2022-11-09", "2022-11-10", "2022-11-11"))

ui <- fluidPage(
  tags$p("Change the date without rebuilding the map (leafletProxy + setWMSParams)."),
  sliderInput("day", "Date", min = times[1], max = times[length(times)],
              value = times[1], timeFormat = "%Y-%m-%d"),
  leafletOutput("map", height = "500px")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(worldCopyJump = FALSE)) %>%
      addTiles(group = "base", options = tileOptions(noWrap = TRUE)) %>%
      setMaxBounds(-180, -85.0511, 180, 85.0511) %>%
      setView(-76, 47, 4) %>%
      addWMS(
        baseUrl = "https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi",
        layers = "MODIS_Terra_CorrectedReflectance_TrueColor",
        layerId = "modis",
        group = "MODIS",
        options = c(
          WMSTileOptions(
            tiled = TRUE,
            noWrap = TRUE,
            format = "image/jpeg",
            time = format(times[1], "%Y-%m-%d")
          ),
          list(identify = FALSE)
        )
      ) %>%
      addLayersControl(baseGroups = "base", overlayGroups = "MODIS")
  })

  observeEvent(input$day, {
    leafletProxy("map") %>%
      setWMSParams(layerId = "modis", time = format(input$day, "%Y-%m-%d"))
  }, ignoreInit = TRUE)
}

shinyApp(ui, server)
