library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(
  leafletOutput("map", height = "700px"),
  dateInput("date", "Date:"),
  actionButton("go", "Set the new Date"),
  checkboxInput("trans", "Transparency", value = TRUE),
  actionButton("go1", "Set the new Transparency")
)

layers <- gibs_layers$title[c(35, 128, 185)]

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles() %>%
      setView(9, 50, 6) %>%
      addGIBS(layers = layers,
              dates = Sys.Date() - 1,
              group = layers, opacity = c(0.5, 0.3, 1)) %>%
      addLayersControl(overlayGroups = layers)
  })

  observeEvent(input$go, {
    leafletProxy("map",session) %>%
      setDate(layers, input$date)
  })
  observeEvent(input$go1, {
    leafletProxy("map",session) %>%
      setTransparent(layers, input$trans)
  })
}

shinyApp(ui, server)
