library(leaflet)
library(leaflet.extras2)

## Static map (Quarto/HTML): CurrentSize exports at widget size.
## scale = 3 exports the current view at 3x pixel size.
## width/height keep the current view by default (keepView = TRUE).
leaflet() %>%
  fitBounds(-91, 47, -87, 50) %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topographic") %>%
  addProviderTiles("Esri.WorldImagery", group = "Imagery") %>%
  addMarkers(lng = c(-89, -89.0001, -90), lat = c(48, 48.00001, 49)) %>%
  addLayersControl(
    baseGroups = c("Topographic", "Imagery"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addEasyprint(options = easyprintOptions(
    title = "Save map to PNG",
    position = "topleft",
    filename = "check",
    exportOnly = TRUE,
    hideControlContainer = FALSE,
    tileLayer = "Topographic",
    tileWait = 1000,
    sizeModes = list(
      "CurrentSize",
      list(scale = 3, name = "3x current view"),
      list(width = 3000, height = 1800, name = "High res (3000x1800)")
    )
  ))
