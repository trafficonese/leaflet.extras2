# Add Side by Side View

A Leaflet control to add a split screen to compare two map overlays. The
plugin works with Panes, see the example.

## Usage

``` r
addSidebyside(
  map,
  layerId = NULL,
  leftId = NULL,
  rightId = NULL,
  options = list(thumbSize = 42, padding = 0)
)
```

## Arguments

- map:

  a map widget

- layerId:

  the layer id, needed for
  [`removeSidebyside`](https://trafficonese.github.io/leaflet.extras2/reference/removeSidebyside.md)

- leftId:

  the `layerId` of the Tile layer that should be visible on the **left**
  side

- rightId:

  the `layerId` of the Tile layer that should be visible on the
  **right** side

- options:

  A list of options. Currently only `thumbSize` and `padding` can be
  changed.

## Value

the new `map` object

## Note

It is currently not working correctly if the `baseGroups` are defined in
[`addLayersControl`](https://rstudio.github.io/leaflet/reference/addLayersControl.html).

## References

<https://github.com/digidem/leaflet-side-by-side>

## See also

Other Sidebyside Functions:
[`removeSidebyside()`](https://trafficonese.github.io/leaflet.extras2/reference/removeSidebyside.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

leaflet(quakes) %>%
  addMapPane("left", zIndex = 0) %>%
  addMapPane("right", zIndex = 0) %>%
  addTiles(
    group = "base", layerId = "baseid",
    options = pathOptions(pane = "right")
  ) %>%
  addProviderTiles(providers$CartoDB.DarkMatter,
    group = "carto", layerId = "cartoid",
    options = pathOptions(pane = "left")
  ) %>%
  addCircleMarkers(
    data = breweries91[1:15, ], color = "blue", group = "blue",
    options = pathOptions(pane = "left")
  ) %>%
  addCircleMarkers(data = breweries91[15:20, ], color = "yellow", group = "yellow") %>%
  addCircleMarkers(
    data = breweries91[15:30, ], color = "red", group = "red",
    options = pathOptions(pane = "right")
  ) %>%
  addLayersControl(overlayGroups = c("blue", "red", "yellow")) %>%
  addSidebyside(
    layerId = "sidecontrols",
    rightId = "baseid",
    leftId = "cartoid"
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"createMapPane","args":["left",0]},{"method":"createMapPane","args":["right",0]},{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png","baseid","base",{"interactive":true,"className":"","pane":"right","attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addProviderTiles","args":["CartoDB.DarkMatter","cartoid","carto",{"interactive":true,"className":"","pane":"left"}]},{"method":"addCircleMarkers","args":[[49.71979,49.884051,49.502098,49.274716,49.861905,49.794334,49.701477,49.067436,49.070292,49.77994,49.060542,49.561804,49.595108,49.602554,49.72581],[10.889217,11.228988,10.416021,10.928096,11.291932,11.509409,11.163238,10.34418,10.316987,11.186931,10.965571,11.368508,11.009011,11.005049,11.059662],10,null,"blue",{"interactive":true,"className":"","pane":"left","stroke":true,"color":"blue","weight":5,"opacity":0.5,"fill":true,"fillColor":"blue","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[49.72581,49.7202,49.644533,49.645651,49.615866,49.50683],[11.059662,11.056749,11.252699,11.248618,10.630027,11.428338],10,null,"yellow",{"interactive":true,"className":"","stroke":true,"color":"yellow","weight":5,"opacity":0.5,"fill":true,"fillColor":"yellow","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[49.72581,49.7202,49.644533,49.645651,49.615866,49.50683,48.900742,49.707329,49.884229,49.677827,49.450083,49.710838,49.276265,49.554706,49.882777,49.727998],[11.059662,11.056749,11.252699,11.248618,10.630027,11.428338,11.029479,10.806113,11.267583,11.252911,11.308721,11.172792,10.685605,11.22997,11.129541,11.202701],10,null,"red",{"interactive":true,"className":"","pane":"right","stroke":true,"color":"red","weight":5,"opacity":0.5,"fill":true,"fillColor":"red","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addLayersControl","args":[[],["blue","red","yellow"],{"collapsed":true,"autoZIndex":true,"position":"topright"}]},{"method":"addSidebyside","args":["sidecontrols","cartoid","baseid",{"thumbSize":42,"padding":0}]}],"limits":{"lat":[48.900742,49.884229],"lng":[10.316987,11.509409]}},"evals":[],"jsHooks":[]}
```
