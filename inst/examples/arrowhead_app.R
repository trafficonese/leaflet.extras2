library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(
  leafletOutput("map", height=800),
  actionButton("clear", "Clear Group"),
  actionButton("remove", "Remove"),
  actionButton("clearArrowhead", "Remove Arrowheads by group"),
  actionButton("removeArrowhead", "Remove Arrowheads by layerId's")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addLayersControl(overlayGroups = c("blue","red")) %>%
      ## Blue #############
      addArrowhead(data = atlStorms2005[1:10,], color="blue",
                   group="blue",
                   options = arrowheadOptions(
                     yawn = 60,
                     size = '7%',
                     frequency = 'endonly',
                     fill = TRUE,
                     opacity=0.5, stroke=FALSE, fillOpacity=0.4,
                     proportionalToTotal = TRUE,
                     offsets = NULL,
                     perArrowheadOptions = NULL)) %>%
      ## Red #############
      addArrowhead(data = atlStorms2005[11:20,], color = "red",
                   group = "red",
                   layerId = paste0("inp",1:10),
                   options = arrowheadOptions(
                     yawn = 90,
                     size = '10px',
                     frequency = 'allvertices',
                     fill = TRUE,
                     offsets = NULL,
                     perArrowheadOptions = NULL)) %>%
      ## Green #############
      addArrowhead(data = atlStorms2005[21,], color = "green", group="green",
                   options = arrowheadOptions(
                     size = '10px',
                     frequency = '50px',
                     offsets = list('start' = '100m', 'end' = '15px'),
                     fill = TRUE)) %>%
      ## Yellow #############
      addArrowhead(data = atlStorms2005[22,], color = "yellow",
                   options = arrowheadOptions(
                     size = "25000m",
                     frequency = '200000m',
                     fill = TRUE)) %>%
      ## Purple #############
      addArrowhead(data = atlStorms2005[24,], color = "purple",
                   options = arrowheadOptions(
                     opacity=1, fillOpacity=1,
                     frequency = "30px",
                     size= "20px", fill=TRUE,
                     perArrowheadOptions = leaflet::JS("(i) => ({
                         color: `rgba(150, 20, ${0 + 20 * i}, 1)`,
                      })")))
  })
  observeEvent(input$clear, {
    leafletProxy("map") %>%
      leaflet::clearGroup("blue")
  })
  observeEvent(input$remove, {
    leafletProxy("map") %>%
      leaflet::removeShape(layerId = "inp3")
  })
  observeEvent(input$clearArrowhead, {
    leafletProxy("map") %>%
      clearArrowhead(group = "blue")
  })
  observeEvent(input$removeArrowhead, {
    leafletProxy("map") %>%
      removeArrowhead(paste0("inp",1:5))
  })
}
shinyApp(ui, server)
