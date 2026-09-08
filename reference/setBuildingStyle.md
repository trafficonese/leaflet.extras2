# Update the OSM-Buildings Style

Update the OSM-Buildings Style

## Usage

``` r
setBuildingStyle(
  map,
  style = list(color = "#ffcc00", wallColor = "#ffcc00", roofColor = "orange", shadows =
    TRUE)
)
```

## Arguments

- map:

  A map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html).

- style:

  A named list of styles

## See also

Other OSM-Buildings Plugin:
[`addBuildings()`](https://trafficonese.github.io/leaflet.extras2/reference/addBuildings.md),
[`setBuildingData()`](https://trafficonese.github.io/leaflet.extras2/reference/setBuildingData.md),
[`updateBuildingTime()`](https://trafficonese.github.io/leaflet.extras2/reference/updateBuildingTime.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

style <- list(color = "#0000ff", wallColor = "gray", roofColor = "orange", shadows = TRUE)
leaflet() %>%
  addTiles() %>%
  addBuildings() %>%
  setBuildingStyle(style) %>%
  setView(13.40, 52.51836, 15)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addBuilding","args":["https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json",null,null,null,null]},{"method":"setBuildingStyle","args":[{"color":"#0000ff","wallColor":"gray","roofColor":"orange","shadows":true}]}],"setView":[[52.51836,13.4],15,[]]},"evals":[],"jsHooks":[]}
```
