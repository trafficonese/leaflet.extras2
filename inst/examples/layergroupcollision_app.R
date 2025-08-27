library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)
options("shiny.autoreload" = TRUE)

df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(1:nrow(df), 150, replace = FALSE),]
df$classes <- sample(x = 1:5, nrow(df), replace = TRUE)

## Ordering is important
df <- df[order(df$classes, decreasing = FALSE),]

ui <- fluidPage(
  ## CSS-style ############
  tags$head(tags$style("
		.my-label {
			background: white;
			border: 1px solid #888;
			position: relative;
			display: inline-block;
			white-space: nowrap;
		}
		.my-label-1 { font-size: 28px; background-color: red; top: -26px; }
		.my-label-2 { font-size: 24px; background-color: orange; top: -25px; }
		.my-label-3 { font-size: 22px; background-color: yellow; top: -24px; }
		.my-label-4 { font-size: 16px; background-color: green; top: -23px; }
		.my-label-5 { font-size: 15px; background-color: lightgreen; top: -22px; }
  ")),
  leafletOutput("map", height = 800)
)

## Server ###########
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      leaflet::addLayersControl(overlayGroups = c("Labels")) %>%
        addLayerGroupCollision(data = df
                   , html = ~paste0(
                     '<div class="custom-html">',
                       '<div class="title">', Name, '</div>',
                       '<div class="subtitle">MaxWind: ', MaxWind, '</div>',
                     '</div>'
                   )
                   , className = ~paste0("my-label my-label-", classes)
                   , group = "Labels"
        )

  })
}
shinyApp(ui, server)
