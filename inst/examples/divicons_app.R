library(sf)
library(shiny)
library(leaflet)
library(leaflet.extras2)

df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(seq_len(nrow(df)), 50, replace = FALSE), ]
df$classes <- sample(x = c("myclass1", "myclass2", "myclass3"),
                    nrow(df), replace = TRUE)
df$ID <- paste0("ID_", seq_len(nrow(df)))

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
  splitLayout(cellWidths = paste0(rep(20, 4), "%"),
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
      addMarkers(data = df, group = "normalmarker",
                 clusterId = "someclusterid2",
                 clusterOptions = markerClusterOptions()) %>%
      addDivicon(data = df
                 , html = ~Name
                 , className = ~paste("globalclass", classes)
                 , label = ~Name
                 , layerId = ~ID
                 , group = "Divicons"
                 , popup = ~paste("ID: ", ID, "<br>",
                              "Name: ", Name, "<br>",
                              "MaxWind:", MaxWind, "<br>",
                              "MinPress:", MinPress)
                 , options = markerOptions(draggable = TRUE)
                 , divOptions = list(
                                     popupAnchor = c(10, 0),
                                     iconSize = 10)
                 # , clusterId = "someclusterid"
                 # , clusterOptions = markerClusterOptions()
      ) %>%
      hideGroup("normalmarker") %>%
      addLayersControl(overlayGroups = c("Divicons", "normalmarker"))
  })
  output$click <- renderPrint({
    input$map_marker_click
  })
  output$mouseover <- renderPrint({
    input$map_marker_mouseover
  })
  output$mouseout <- renderPrint({
    input$map_marker_mouseout
  })
  output$dragend <- renderPrint({
    input$map_marker_dragend
  })
}
shinyApp(ui, server)
