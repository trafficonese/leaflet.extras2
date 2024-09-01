library(shiny)
library(leaflet)
library(leaflet.extras2)

## Data ###################
set.seed(100)
rand_lng <- function(n = 10) rnorm(n, -93.65, .01)
rand_lat <- function(n = 10) rnorm(n, 42.0285, .01)
categories <- LETTERS[1:10]
n = 1000
df <- data.frame(
  lat = rand_lat(n), lng = rand_lng(n),
  size = runif(n, 1, 20),
  category = factor(sample(categories, n, replace = TRUE), levels = categories),
  value = rnorm(n, 20, 200)
)
df$id <- 1:nrow(df)
pal <- colorNumeric("viridis", df$value)
col <- pal(df$value)


## CSS style ###################
style <- "
  .hexbin-hexagon {
  	stroke: #000;
  	stroke-width: .5px;
  }
  .hexbin-container:hover .hexbin-hexagon {
  	transition: 200ms;
  	stroke: black;
  	stroke-width: 4px;
  	stroke-opacity: 1;
  }
  .hexbin-tooltip {
  	padding: 8px;
  	border-radius: 4px;
  	border: 1px solid black;
  	background-color: white;
  }
"

## UI ###################
ui <- fluidPage(
  tags$head(tags$style(style)),
  leafletOutput("map", height = "700px"),
  actionButton("update_data", "Update Hexbin Data"),
  actionButton("update_color", "Update Hexbin Colors"),
  actionButton("update_both", "Update Hexbin Data & Colors"),
  actionButton("hide",   "Hide Hexbin"),
  actionButton("show",   "Show Hexbin"),
  actionButton("clear",  "Clear Hexbin Layers"),
  verbatimTextOutput("txt")
)

## SERVER ###################
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles(group = "base") %>%
      addHexbin(
        data = df, opacity = 1,
        # radius = 20,
        layerId = "hexbin_id", group = "hexbin_group",
        options = hexbinOptions(
          duration = 300,
          # colorRange = c("#ff0000", "#08306b"),
          colorRange = c("red", "yellow", "blue"),
          # colorRange = col,
          # colorScaleExtent = c(1, 40),
          # colorRange = c('red', 'red', 'orange', 'orange', 'yellow', 'yellow', 'green', 'green', 'blue', 'blue'),

          # radiusScaleExtent = (JS("[40, undefined]")),
          radiusRange = c(10, 20),
          pointerEvents = "all",
          resizetoCount = TRUE,
          # resizetoCount = JS("function(d) { return (Math.cos(d.length) * 10); }"),

          tooltip = JS("function(d) {return 'Amount of coordinates: ' + d.length;} ")
          # tooltip = "Amount of Markers: "
          # tooltip = T
        )) %>%
      addMarkers(data = df, group = "markers") %>%
      hideGroup("markers") %>%
      addLayersControl(overlayGroups = c("hexbin_group", "markers"))
  })
  output$txt <- renderPrint({
    txt <- req(input$map_hexbin_click)
    print(txt)
  })
  observe({
    pts <- req(input$map_hexbin_click)
    pts <- do.call(rbind, lapply(pts$pts, function(x) do.call("cbind", x)))
    colnames(pts) <- c("lng","lat")
    clicked <- df[which(round(df$lng, 10) %in% round(pts[,"lng"], 10)),]

    leafletProxy("map", session)  %>%
      clearGroup("clicked_markers") %>%
      addMarkers(data = clicked, group = "clicked_markers",
                 label = ~category)
  })
  observeEvent(input$update_data, {
    df <- data.frame(lat = rand_lat(n), lng = rand_lng(n))
    leafletProxy("map", session) %>%
      updateHexbin(data = df)
  })
  observeEvent(input$update_color, {
    cols <- sample(colors()[!(grepl("grey", colors())) |
                              grepl("gray", colors())], 2)
    leafletProxy("map", session) %>%
      updateHexbin(colorRange = rgb(t(col2rgb(cols)/255)))
  })
  observeEvent(input$update_both, {
    df <- data.frame(lat = rand_lat(n), lng = rand_lng(n))
    cols <- sample(colors()[!(grepl("grey", colors())) |
                              grepl("gray", colors())], 2)
    leafletProxy("map", session) %>%
      updateHexbin(data = df, colorRange = rgb(t(col2rgb(cols)/255)))
  })
  observeEvent(input$hide, {
    leafletProxy("map", session) %>%
      hideHexbin()
  })
  observeEvent(input$show, {
    leafletProxy("map", session) %>%
      showHexbin()
  })
  observeEvent(input$clear, {
    leafletProxy("map", session) %>%
      clearHexbin()
  })
}
shinyApp(ui, server)


