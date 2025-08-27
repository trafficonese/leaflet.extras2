library(sf)
library(shiny)
library(leaflet)
library(leaflet.extras2)

# Sample data
df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(seq_len(nrow(df)), 50, replace = FALSE), ]
df$classes <- sample(x = c("myclass1", "myclass2", "myclass3"), nrow(df),
                     replace = TRUE)
df$ID <- paste0("ID_", seq_len(nrow(df)))

## UI ##################
ui <- fluidPage(
  ## CSS-style ############
  tags$head(tags$style("
    .globalclass {
      width: 80px !important;
      height: 80px !important;
      margin-top: -40px !important;
      margin-left: -40px !important;
      font-size: 12px;
      text-align: center;
      border-radius: 50%;
      color: black;
      padding: 5px;
      box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center center;
    }
    .myclass1 {
      background-color: #FF5733;
    }
    .myclass2 {
      background-color: #33FF57;
    }
    .myclass3 {
      background-color: #3357FF;
    }
    .custom-html {
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;
    }
    .custom-html img {
      border-radius: 50%;
      width: 20px;
      height: 20px;
      margin-bottom: 5px;
    }
    .custom-html .title {
      font-weight: bold;
    }
    .custom-html .subtitle {
      font-size: 10px;
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
  # Function to get image URL based on class
  getImageUrls <- function(classes) {
    urls <- c(
      "myclass1" = "https://cdn-icons-png.flaticon.com/512/1355/1355883.png",
      "myclass2" = "https://cdn-icons-png.flaticon.com/512/1356/1356623.png",
      "myclass3" = "https://cdn-icons-png.flaticon.com/512/1357/1357674.png"
    )
    return(urls[classes])
  }

  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      # addMarkers(data = df, group="normalmarker",
      #            clusterId = "someclusterid2",
      #            clusterOptions = markerClusterOptions()) %>%
      addDivicon(data = df
                 , html = ~paste0(
                   "<div class='custom-html'>",
                   "<img src='", getImageUrls(classes), "'>",
                   "<div class='title'>", Name, "</div>",
                   "<div class='subtitle'>MaxWind: ", MaxWind, "</div>",
                   "</div>"
                 )
                 , className = ~paste("globalclass", classes)
                 , label = ~Name
                 , layerId = ~ID
                 , group = "Divicons"
                 , popup = ~paste("ID: ", ID, "<br>",
                              "Name: ", Name, "<br>",
                              "MaxWind:", MaxWind, "<br>",
                              "MinPress:", MinPress)
                 , options = markerOptions(draggable = TRUE)
                 # , clusterId = "someclusterid"
                 # , clusterOptions = markerClusterOptions()
      ) %>%
      addLabelgun("Divicons", 1) %>%
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
