library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras2)
options("shiny.autoreload" = TRUE)

# data <- sf::st_as_sf(breweries91)
# data <- sf::st_as_sf(mapview::trails[1:100,])
# data <- st_transform(data, 4326)
# data <- st_cast(data, "POINT")
# data <- data[1:300,]

df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(1:nrow(df), 150, replace = F),]
# df$classes = sample(x = c("myclass1","myclass2","myclass3"), nrow(df), replace = TRUE)
df$classes = sample(x = 1:5, nrow(df), replace = TRUE)
df$ID <- paste0("ID_", 1:nrow(df))
df$scalerank <-  sample(x = 1:5, nrow(df), replace = TRUE)

ui <- fluidPage(
  ## CSS-style ############
  tags$head(tags$style("
		.city-label {
			background: white;
			border: 1px solid #888;
			position: relative;
			display: inline-block;
			white-space: nowrap;
		}

		.city-label-0 { font-size: 20px; top: -27px; }
		.city-label-1 { font-size: 19px; top: -26px; }
		.city-label-2 { font-size: 18px; top: -25px; }
		.city-label-3 { font-size: 17px; top: -24px; }
		.city-label-4 { font-size: 16px; top: -23px; }
		.city-label-5 { font-size: 15px; top: -22px; }
		.city-label-6 { font-size: 14px; top: -21px; }
		.city-label-7 { font-size: 13px; top: -20px; }
		.city-label-8 { font-size: 12px; top: -19px; }
		.city-label-9 { font-size: 11px; top: -18px; }
		.city-label-10{ font-size: 10px; top: -17px; }

  ")),
  leafletOutput("map", height = 800)
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      leaflet::addLayersControl(overlayGroups = c("Divicons","markers")) %>%
      # addMarkers(data = df, label = ~Name,
      #            , group = "markers") %>%
        addLayerGroupCollision(data = df
                   , html = ~paste0(
                     '<div class="custom-html">',
                     '<div class="title">', Name, '</div>',
                     '<div class="subtitle">MaxWind: ', MaxWind, '</div>',
                     '</div>'
                   )
                   , className = ~paste0("city-label city-label-", classes)
                   , label = ~Name
                   , layerId = ~ID
                   , group = "Divicons"
                   , popup = ~paste("ID: ", ID, "<br>",
                                    "Name: ", Name, "<br>",
                                    "MaxWind:", MaxWind, "<br>",
                                    "MinPress:", MinPress)
                   , options = markerOptions(draggable = TRUE)
        )

  })
}
shinyApp(ui, server)
