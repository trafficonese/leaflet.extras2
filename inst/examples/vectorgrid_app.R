library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

ui <- fluidPage(
  leafletOutput("map", height = "700px"),
  actionButton("remov", "Remove layer"),
  actionButton("clear", "Clear"),
  verbatimTextOutput("click_ev")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      addVectorgrid(
        data = nc,
        layerId = "nc",
        group = "counties",
        featureId = ~NAME,
        popup = ~NAME,
        color = "black",
        weight = 1,
        fill = TRUE,
        fillColor = "#4daf4a",
        fillOpacity = 0.4
      ) %>%
      addLayersControl(
        overlayGroups = "counties",
        options = layersControlOptions(collapsed = FALSE)
      )
  })

  observeEvent(input$remov, {
    leafletProxy("map") %>%
      removeVectorgrid("nc")
  })
  observeEvent(input$clear, {
    leafletProxy("map") %>%
      clearVectorgrid()
  })
  output$click_ev <- renderPrint({
    print(req(input$map_vectorgrid_click))
  })
}

shinyApp(ui, server)
