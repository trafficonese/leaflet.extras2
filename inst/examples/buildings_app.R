library(shiny)
library(leaflet)
library(yyjsonr)
library(sf)
library(leaflet.extras2)
options("shiny.autoreload" = TRUE)

cols <- c("green", "orange", "red", "pink", "yellow", "blue", "lightblue")
darkcols <- c("lightgray", "gray", "#c49071", "#876302", "#443408")

## Custom GeoJSON ###########
## Get a Sample Building Dataset from
# https://hub.arcgis.com/datasets/IthacaNY::buildings/explore?location=42.432557%2C-76.486649%2C13.42
geojson <- yyjsonr::read_geojson_file("Buildings_mini.geojson")
geojson$height <- sample(seq(50, 100, 5), nrow(geojson), replace = TRUE)
geojson$color <- sample(cols, nrow(geojson), replace = TRUE)
geojson$wallColor <- sample(cols, nrow(geojson), replace = TRUE)
geojson$roofColor <- sample(darkcols, nrow(geojson), replace = TRUE)
geojson$shape <- sample(c("cylinder", "sphere", ""), nrow(geojson), replace = TRUE)
geojson$roofHeight <- geojson$height + sample(seq(1, 10, 1), nrow(geojson), replace = TRUE)
geojson$roofShape <- sample(c("dome", "pyramidal", "butterfly", "gabled", "half-hipped",
                            "gambrel", "onion"), nrow(geojson), replace = TRUE)
geojson <- yyjsonr::write_geojson_str(geojson)
class(geojson) <- "json"

## UI ###########
ui <- fluidPage(
  titlePanel("OSM Buildings (2.5D)"),
  sidebarLayout(
    sidebarPanel(
      h4("Use the OSM Buildings or a Custom GeoJSON")
      , selectInput("src", label = "Data Source", choices = c("OSM", "GeoJSON"))
      , h4("Change the Date and Time-Slider to Adapt the Shadow")
      , dateInput("date", "Date")
      , sliderInput("time", "Time", 7, max = 20, value = 11, step = 1)
      , h4("Change the Style and the Data")
      , actionButton("style", "Update Style")
      , actionButton("data", "Update Data")
    ),
    mainPanel(
      leafletOutput("map", height = "700px")
    ),
    fluid = TRUE
  )
)

## SERVER ###########
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles("CartoDB")

    if (input$src == "OSM") {
      m <- m %>%
        addBuildings(
          group = "Buildings"
          # , eachFn = leaflet::JS("function(e) { console.log('each feature:', e); }")
          # , clickFn = leaflet::JS("function(e) { console.log('clicked:', e); }")
        )
    } else {
      m <- m %>%
        addBuildings(
          group = "Buildings"
          , buildingURL = NULL
          , data = geojson
        )
    }

    m %>%
      addLayersControl(overlayGroups = "Buildings") %>%
      setView(lng = -76.51, lat = 42.433, zoom = 15)
  })
  observe({
    time <- formatC(input$time, width = 2, format = "d", flag = "0")
    updatetime <- paste0(input$date, " ", time, ":00:00")
    leafletProxy("map") %>%
      updateBuildingTime(time = as.POSIXct(updatetime))
  })
  observeEvent(input$style, {
    leafletProxy("map") %>%
      setBuildingStyle(style = list(
        color = sample(cols, 1),
        wallColor = sample(cols, 1),
        roofColor = sample(cols, 1),
        roofShape = sample(c("dome", "pyramidal", "butterfly",
                             "gabled", "half-hipped",
                             "gambrel", "onion"), 1),
        shadows = sample(c(TRUE, FALSE), 1)))
  })
  observeEvent(input$data, {
    geojson <- yyjsonr::read_geojson_file("Buildings_mini.geojson")
    filtered <- geojson[sample(1:nrow(geojson), 10, FALSE),]
    filtered$height <- sample(seq(50,140,5), nrow(filtered), replace = TRUE)
    filtered$color <- sample(cols, nrow(filtered), replace = TRUE)
    filtered$wallColor <- sample(cols, nrow(filtered), replace = TRUE)
    filtered$roofColor <- sample(cols, nrow(filtered), replace = TRUE)
    filtered <- yyjsonr::write_geojson_str(filtered)
    class(filtered) <- "json"

    leafletProxy("map") %>%
      setBuildingData(data = filtered)
  })
}

shinyApp(ui, server)

