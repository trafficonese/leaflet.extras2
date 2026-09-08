# Add Time Slider to Leaflet

The [LeafletSlider plugin](https://github.com/dwilhelm89/LeafletSlider)
enables you to dynamically add and remove Markers/Lines on a map by
using a JQuery UI slider.

## Usage

``` r
addTimeslider(
  map,
  data,
  radius = 10,
  stroke = TRUE,
  color = "#03F",
  weight = 5,
  opacity = 0.5,
  fill = TRUE,
  fillColor = color,
  fillOpacity = 0.2,
  dashArray = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  ordertime = TRUE,
  options = timesliderOptions()
)
```

## Arguments

- map:

  a map widget

- data:

  data must be a Simple Feature collection of type POINT or LINESTRING
  with a column of class Date or POSIXct.

- radius:

  a numeric vector of radii for the circles; it can also be a one-sided
  formula, in which case the radius values are derived from the `data`
  (units in meters for circles, and pixels for circle markers)

- stroke:

  whether to draw stroke along the path (e.g., the borders of polygons
  or circles)

- color:

  stroke color

- weight:

  stroke width in pixels

- opacity:

  stroke opacity (or layer opacity for tile layers)

- fill:

  whether to fill the path with color (e.g., filling on polygons or
  circles)

- fillColor:

  fill color

- fillOpacity:

  fill opacity

- dashArray:

  a string that defines the stroke [dash
  pattern](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-dasharray)

- popup:

  a character vector of the HTML content for the popups (you are
  recommended to escape the text using
  [`htmltools::htmlEscape()`](https://rstudio.github.io/htmltools/reference/htmlEscape.html)
  for security reasons)

- popupOptions:

  A Vector of
  [`popupOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide popups

- label:

  a character vector of the HTML content for the labels

- labelOptions:

  A Vector of
  [`labelOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide label options for each label. Default `NULL`

- ordertime:

  boolean value indicating whether to order the data by the time column.
  The slider will adopt the order of the timestamps. The default is
  `TRUE`.

- options:

  List of additional options. See
  [`timesliderOptions`](https://trafficonese.github.io/leaflet.extras2/reference/timesliderOptions.md)

## Value

the new `map` object

## References

<https://github.com/dwilhelm89/LeafletSlider>

## See also

Other Timeslider Functions:
[`removeTimeslider()`](https://trafficonese.github.io/leaflet.extras2/reference/removeTimeslider.md),
[`timesliderOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/timesliderOptions.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)
library(sf)

data <- sf::st_as_sf(leaflet::atlStorms2005[1, ])
data <- st_cast(data, "POINT")
#> Warning: repeating attributes for all sub-geometries for which they may not be constant
data$time <- as.POSIXct(
  seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data))
)

leaflet() %>%
  addTiles() %>%
  addTimeslider(
    data = data,
    options = timesliderOptions(
      position = "topright",
      timeAttribute = "time",
      range = TRUE
    )
  ) %>%
  setView(-72, 22, 4)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addTimeslider","args":[{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:10:45","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-67.5,15.8]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:12:25","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-68.5,16.5]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:14:05","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-69.6,17.3]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:15:45","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-70.5,17.8]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:17:25","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-71.3,18.3]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:19:05","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-72.2,18.6]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:20:45","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-72.7,19.8]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:22:25","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-72.9,21.6]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:24:05","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-73.0,23.5]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:25:45","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-72.4,25.1]}},{"type":"Feature","properties":{"Name":"ALPHA","MaxWind":45.0,"MinPress":998.0,"time":"2026-09-08 22:27:25","radius":10.0,"stroke":true,"color":"#03F","weight":5.0,"fillColor":"#03F","opacity":0.5,"fill":true,"fillOpacity":0.2},"geometry":{"type":"Point","coordinates":[-70.8,27.9]}}]},{"position":"topright","timeAttribute":"time","isEpoch":false,"startTimeIdx":0,"timeStrLength":19,"maxValue":-1,"minValue":0,"showAllOnStart":false,"range":true,"follow":false,"alwaysShowDate":false,"sameDate":false},null,null]}],"limits":{"lat":[15.8,27.9],"lng":[-73,-67.5]},"setView":[[22,-72],4,[]]},"evals":[],"jsHooks":[]}
```
