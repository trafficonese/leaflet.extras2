library(sf)
library(shiny)
library(leaflet)
library(leaflet.extras2)
# options("shiny.autoreload" = TRUE)

shipIcon <- leaflet::makeIcon(
  iconUrl = "./icons/Icon5.svg"
  ,className = "lsaicons"
  ,iconWidth = 24, iconHeight = 24, iconAnchorX = 0, iconAnchorY = 0
)
# shipIcon <- iconList(
#   "Schwer"       = makeIcon("./icons/Icon5.svg", iconWidth = 32, iconHeight = 32),
#   "Mäßig"        = makeIcon("./icons/Icon8.svg", iconWidth = 32, iconHeight = 32),
#   "Leicht"       = makeIcon("./icons/Icon25.svg", iconWidth = 32, iconHeight = 32),
#   "kein Schaden" = makeIcon("./icons/Icon29.svg", iconWidth = 32, iconHeight = 32)
# )
# shipIcon <- makeIcon(
#   iconUrl = "https://cdn-icons-png.flaticon.com/512/1355/1355883.png",
#   iconWidth = 40, iconHeight = 50,
#   iconAnchorX = 0, iconAnchorY = 0
# )

df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(1:nrow(df), 50, replace = F),]
df$classes = sample(x = c("myclass1","myclass2","myclass3"), nrow(df), replace = TRUE)
df$ID <- paste0("ID_", 1:nrow(df))

## UI ##################
ui <- fluidPage(
  ## CSS-style ############
  tags$head(tags$style("
    .globalclass {
      width: inherit !important;
      height: inherit !important;
      font-size: 10px;
      border-radius: 90%;
      padding: 4px;
    }
    .myclass1 {
      background-color: yellow;
    }
    .myclass2 {
      background-color: orange;
    }
    .myclass3 {
      background-color: green;
    }
    ")),
  ## CSS-style END ############
  leafletOutput("map", height = 600),
  splitLayout(cellWidths = paste0(rep(20,4), "%"),
              div(h4("Click Event"), verbatimTextOutput("click")),
              div(h4("Mouseover Event"), verbatimTextOutput("mouseover")),
              div(h4("Mouseout Event"), verbatimTextOutput("mouseout")),
              div(h4("Dragend Event"), verbatimTextOutput("dragend"))
  )
)

## SERVER ##################
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      addDivicon(data = df,
                 html = ~Name,
                 class=~paste("globalclass", classes),
                 label=~Name,
                 layerId = ~ID,
                 icon = shipIcon,
                 popup=~paste("ID: ", ID, "<br>",
                              "Name: ", Name, "<br>",
                              "MaxWind:", MaxWind, "<br>",
                              "MinPress:", MinPress),
                 options = markerOptions(draggable = TRUE)
      )
  })
  output$click <- renderPrint({input$map_marker_click})
  output$mouseover <- renderPrint({input$map_marker_mouseover})
  output$mouseout <- renderPrint({input$map_marker_mouseout})
  output$dragend <- renderPrint({input$map_marker_dragend})
}
shinyApp(ui, server)
