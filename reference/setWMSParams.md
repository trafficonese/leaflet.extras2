# Update WMS request parameters

Change WMS parameters such as `time`, `styles` or `cql_filter` on an
existing layer without rebuilding the map. In Shiny, call this on
[`leafletProxy`](https://rstudio.github.io/leaflet/reference/leafletProxy.html).

## Usage

``` r
setWMSParams(map, layerId = NULL, group = NULL, ...)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- layerId:

  the layer id

- group:

  the name of the group the newly created layers should belong to (for
  [`clearGroup()`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl()`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g., markers and polygons) can share the same group
  name.

- ...:

  Named WMS request parameters to set, for example
  `time = "2022-11-10T21:00:00Z"`.

## Value

the new `map` object

## See also

Other WMS Functions:
[`addWMS()`](https://trafficonese.github.io/leaflet.extras2/reference/addWMS.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

leaflet() %>%
  addTiles() %>%
  addWMS(
    baseUrl = "https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi",
    layers = "MODIS_Terra_CorrectedReflectance_TrueColor",
    layerId = "modis",
    options = WMSTileOptions(format = "image/jpeg", time = "2022-11-10")
  ) %>%
  setWMSParams(layerId = "modis", time = "2022-11-11")

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addWMS","args":["https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi","modis",null,{"styles":"","format":"image/jpeg","transparent":false,"version":"1.1.1","time":"2022-11-10","layers":"MODIS_Terra_CorrectedReflectance_TrueColor","checkempty":false},null]},{"method":"setWMSParams","args":["modis",null,{"time":"2022-11-11"}]}]},"evals":[],"jsHooks":[]}
```
