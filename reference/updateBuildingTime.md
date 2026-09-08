# Update the Shadows OSM-Buildings with a POSIXct timestamp

Update the Shadows OSM-Buildings with a POSIXct timestamp

## Usage

``` r
updateBuildingTime(map, time)
```

## Arguments

- map:

  A map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html).

- time:

  a timestamp that can be converted to POSIXct

## See also

Other OSM-Buildings Plugin:
[`addBuildings()`](https://trafficonese.github.io/leaflet.extras2/reference/addBuildings.md),
[`setBuildingData()`](https://trafficonese.github.io/leaflet.extras2/reference/setBuildingData.md),
[`setBuildingStyle()`](https://trafficonese.github.io/leaflet.extras2/reference/setBuildingStyle.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

leaflet() %>%
  addTiles() %>%
  addBuildings() %>%
  updateBuildingTime(as.POSIXct("2024-09-01 19:00:00 CET")) %>%
  setView(13.40, 52.51836, 15)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addBuilding","args":["https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json",null,null,null,null]},{"method":"updateBuildingTime","args":["2024-09-01T19:00:00Z"]}],"setView":[[52.51836,13.4],15,[]]},"evals":[],"jsHooks":[]}
```
