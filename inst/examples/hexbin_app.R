library(shiny)
library(leaflet)
library(leaflet.extras2)
library(sf)

breweries91 <- st_as_sf(breweries91)
data = st_coordinates(breweries91)

style <- ".hexbin-container:hover .hexbin-hexagon {
	transition: 200ms;
	stroke: orange;
	stroke-width: 3px;
	stroke-opacity: 1;
}"

ui <- fluidPage(
  tags$head(tags$style(style)),
  leafletOutput("map", height = "500px")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles(group = "base") %>%
      addHexbin(data = data)
  })
}
shinyApp(ui, server)


