# Add History Plugin

The plugin enables tracking of map movements in a history similar to a
web browser. By default, it is a simple pair of buttons – back and
forward.

## Usage

``` r
addHistory(map, layerId = NULL, options = historyOptions())
```

## Arguments

- map:

  a map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- layerId:

  the control id

- options:

  A named list of options. See
  [`historyOptions`](https://trafficonese.github.io/leaflet.extras2/reference/historyOptions.md)

## Value

the new `map` object

## References

<https://github.com/cscott530/leaflet-history>

## See also

Other History Functions:
[`clearFuture()`](https://trafficonese.github.io/leaflet.extras2/reference/clearFuture.md),
[`clearHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/clearHistory.md),
[`goBackHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/goBackHistory.md),
[`goForwardHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/goForwardHistory.md),
[`historyOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/historyOptions.md)

## Examples

``` r
library(leaflet)
leaflet() %>%
  addTiles() %>%
  addHistory()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addHistory","args":[null,{"position":"topright","maxMovesToSave":10,"backImage":"fa fa-caret-left","forwardImage":"fa fa-caret-right","backText":"","forwardText":"","backTooltip":"Go to Previous Extent","forwardTooltip":"Go to Next Extent","backImageBeforeText":true,"forwardImageBeforeText":false,"orientation":"horizontal"}]}]},"evals":[],"jsHooks":[]}
```
