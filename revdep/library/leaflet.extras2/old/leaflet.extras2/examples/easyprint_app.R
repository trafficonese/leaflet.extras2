
library(shiny)
library(leaflet)
library(leaflet.extras2)


ui <- fluidPage(
  leafletOutput("map"),
  selectInput("scene", "Select Scene", choices = c("CurrentSize", "A4Landscape", "A4Portrait")),
  textInput("fn", "Filename", value = "map"),
  actionButton("print", "Print Map"),
  actionButton("rem", "removeEasyprint"),
  actionButton("cle", "clearControls")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    input$print
    leaflet()  %>%
      addTiles() %>%
      addEasyprint(options = easyprintOptions(title = 'Give me that map',
                                              position = 'bottomleft',
                                              exportOnly = TRUE,
                                              filename = "mapit",
                                              customWindowTitle = "Some Fancy Title",
                                              customSpinnerClass = "shiny-spinner-placeholder",
                                              spinnerBgColor = "#b48484"))
  })
  observeEvent(input$print, {
    leafletProxy("map") %>%
      easyprintMap(sizeModes = input$scene, filename = input$fn)
  })
  observeEvent(input$rem, {
    leafletProxy("map") %>%
      removeEasyprint()
  })
  observeEvent(input$cle, {
    leafletProxy("map") %>%
      clearControls()
  })
}

shinyApp(ui, server)

