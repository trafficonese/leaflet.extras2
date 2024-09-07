library(shiny)
library(leaflet)
library(leaflet.extras2)


ui <- fluidPage(
  leafletOutput("map", height = "500px")
)

base64pwd <- paste0("user:strongpwd")

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet()  %>%
      addTiles(group = "base") %>%
      addWMSHeader(baseUrl = "http://localhost:8080/geoserver/wms",
             layers = c("tiger:poi"),
             group = "wmsgroup",
             header = list(
               list("header" = "Authorization",
                    "value" = paste0("Basic ", base64enc::base64encode(charToRaw(base64pwd))) ),
               list("header" = "content-type",
                    "value" = "text/plain")
             ),
             options = leaflet::WMSTileOptions(
               transparent = TRUE, format = "image/png")) %>%
      addLayersControl(baseGroups = "base",
                       overlayGroups = c("tiger:poi"))

  })
}
shinyApp(ui, server)


