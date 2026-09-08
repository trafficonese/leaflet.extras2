# Add a Heightgraph layer

Visualize height information and road attributes of linestring segments.
The linestrings must be a Simple Feature LINESTRING Z and are
transformed to GeoJSON. The function therefore inherits arguments from
[`addGeoJSON`](https://rstudio.github.io/leaflet/reference/map-layers.html).

## Usage

``` r
addHeightgraph(
  map,
  data = NULL,
  columns = NULL,
  layerId = NULL,
  group = NULL,
  color = "#03F",
  weight = 5,
  opacity = 0.5,
  dashArray = NULL,
  smoothFactor = 1,
  noClip = FALSE,
  pathOpts = leaflet::pathOptions(),
  options = heightgraphOptions()
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- data:

  A Simple Feature LINESTRING with Z dimension.

- columns:

  A character vector of the columns you want to include in the
  heightgraph control

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

- color:

  stroke color

- weight:

  stroke width in pixels

- opacity:

  stroke opacity (or layer opacity for tile layers)

- dashArray:

  a string that defines the stroke [dash
  pattern](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-dasharray)

- smoothFactor:

  how much to simplify the polyline on each zoom level (more means
  better performance and less accurate representation)

- noClip:

  whether to disable polyline clipping

- pathOpts:

  List of further options for the path. See
  [`pathOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)

- options:

  List of further plugin options. See
  [`heightgraphOptions`](https://trafficonese.github.io/leaflet.extras2/reference/heightgraphOptions.md)

## Value

the new `map` object

## Note

When used in Shiny, 3 events update a certain Shiny Input:

1.  A click updates `input$MAPID_heightgraph_click`

2.  A mouseover updates `input$MAPID_heightgraph_mouseover`

3.  A mouseout updates `input$MAPID_heightgraph_mouseout`

If you want to explicitly remove the Heightgraph control, please use
[`removeControl`](https://rstudio.github.io/leaflet/reference/remove.html)
with the `layerId = "hg_control"`.

## References

<https://github.com/GIScience/Leaflet.Heightgraph>

## See also

Other Heightgraph Functions:
[`heightgraphOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/heightgraphOptions.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)
library(sf)

data <- st_cast(st_as_sf(leaflet::atlStorms2005[4, ]), "LINESTRING")
data <- st_transform(data, 4326)
data <- data.frame(st_coordinates(data))
data$elev <- round(runif(nrow(data), 10, 500), 2)
data$L1 <- NULL
L1 <- round(seq.int(1, 4, length.out = nrow(data)))
data <- st_as_sf(st_sfc(lapply(split(data, L1), function(x) {
  st_linestring(as.matrix(x))
})))
data$steepness <- 1:nrow(data)
data$suitability <- nrow(data):1
data$popup <- apply(data, 1, function(x) {
  sprintf("Steepness: %s<br>Suitability: %s", x$steepness, x$suitability)
})

leaflet() %>%
  addTiles(group = "base") %>%
  addHeightgraph(
    color = "red", columns = c("steepness", "suitability"),
    opacity = 1, data = data, group = "heightgraph",
    options = heightgraphOptions(width = 400)
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,"base",{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addHeightgraph","args":[[{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"attributeType":1,"suitability":4,"popup":"Steepness: 1<br>Suitability: 4"},"geometry":{"type":"LineString","coordinates":[[-86.7,18.3,264.57],[-87.2,18.6,324.19],[-87.6,19.0,416.65],[-87.9,19.3,460.36],[-88.5,20.9,465.41],[-89.0,22.3,326.2]]}},{"type":"Feature","properties":{"attributeType":2,"suitability":3,"popup":"Steepness: 2<br>Suitability: 3"},"geometry":{"type":"LineString","coordinates":[[-89.7,23.9,393.73],[-90.2,25.1,38.77],[-90.4,26.4,185.6],[-90.5,27.6,244.9],[-90.3,28.5,364.31],[-90.1,29.2,351.24],[-90.0,29.6,436.65],[-89.5,30.2,357.31],[-88.9,30.8,183.85],[-88.1,31.6,405.55],[-87.2,32.4,182.87]]}},{"type":"Feature","properties":{"attributeType":3,"suitability":2,"popup":"Steepness: 3<br>Suitability: 2"},"geometry":{"type":"LineString","coordinates":[[-86.2,33.2,379.03],[-84.1,34.6,454.99],[-81.8,35.6,223.34],[-80.0,37.1,117.92],[-78.3,37.8,28.22],[-76.7,38.4,352.05],[-74.8,39.1,83.42],[-72.0,39.5,275.79],[-70.7,40.8,400.42],[-69.8,41.6,362.62],[-69.6,43.5,366.81]]}},{"type":"Feature","properties":{"attributeType":4,"suitability":1,"popup":"Steepness: 4<br>Suitability: 1"},"geometry":{"type":"LineString","coordinates":[[-69.8,44.9,33.43],[-70.0,45.5,231.17],[-67.6,46.5,399.19],[-66.4,48.0,414.06],[-64.5,48.5,112.44],[-62.5,48.5,92.42]]}}]},{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"steepness":1,"attributeType":4,"popup":"Steepness: 1<br>Suitability: 4"},"geometry":{"type":"LineString","coordinates":[[-86.7,18.3,264.57],[-87.2,18.6,324.19],[-87.6,19.0,416.65],[-87.9,19.3,460.36],[-88.5,20.9,465.41],[-89.0,22.3,326.2]]}},{"type":"Feature","properties":{"steepness":2,"attributeType":3,"popup":"Steepness: 2<br>Suitability: 3"},"geometry":{"type":"LineString","coordinates":[[-89.7,23.9,393.73],[-90.2,25.1,38.77],[-90.4,26.4,185.6],[-90.5,27.6,244.9],[-90.3,28.5,364.31],[-90.1,29.2,351.24],[-90.0,29.6,436.65],[-89.5,30.2,357.31],[-88.9,30.8,183.85],[-88.1,31.6,405.55],[-87.2,32.4,182.87]]}},{"type":"Feature","properties":{"steepness":3,"attributeType":2,"popup":"Steepness: 3<br>Suitability: 2"},"geometry":{"type":"LineString","coordinates":[[-86.2,33.2,379.03],[-84.1,34.6,454.99],[-81.8,35.6,223.34],[-80.0,37.1,117.92],[-78.3,37.8,28.22],[-76.7,38.4,352.05],[-74.8,39.1,83.42],[-72.0,39.5,275.79],[-70.7,40.8,400.42],[-69.8,41.6,362.62],[-69.6,43.5,366.81]]}},{"type":"Feature","properties":{"steepness":4,"attributeType":1,"popup":"Steepness: 4<br>Suitability: 1"},"geometry":{"type":"LineString","coordinates":[[-69.8,44.9,33.43],[-70.0,45.5,231.17],[-67.6,46.5,399.19],[-66.4,48.0,414.06],[-64.5,48.5,112.44],[-62.5,48.5,92.42]]}}]}],{"steepness":[1,2,3,4],"suitability":[4,3,2,1]},null,"heightgraph",{"interactive":true,"className":"","color":"red","weight":5,"opacity":1,"smoothFactor":1,"noClip":false},{"position":"bottomright","width":400,"height":200,"margins":{"top":10,"right":30,"bottom":55,"left":50},"expand":true,"highlightStyle":{"color":"red"},"xTicks":3,"yTicks":3}]}],"limits":{"lat":[18.3,48.5],"lng":[-90.5,-62.5]}},"evals":[],"jsHooks":[]}
```
