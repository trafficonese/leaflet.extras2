# History Options

History Options

## Usage

``` r
historyOptions(
  position = c("topright", "topleft", "bottomleft", "bottomright"),
  maxMovesToSave = 10,
  backImage = "fa fa-caret-left",
  forwardImage = "fa fa-caret-right",
  backText = "",
  forwardText = "",
  backTooltip = "Go to Previous Extent",
  forwardTooltip = "Go to Next Extent",
  backImageBeforeText = TRUE,
  forwardImageBeforeText = FALSE,
  orientation = c("horizontal", "vertical"),
  shouldSaveMoveInHistory = NULL
)
```

## Arguments

- position:

  Set the position of the History control. Default is `topright`.

- maxMovesToSave:

  Number of moves in the history to save before clearing out the oldest.
  Default value is 10, use 0 or a negative number to make unlimited.

- backImage:

  The class for the \`back\` button icon. Default is
  `"fa fa-caret-left"`.

- forwardImage:

  The class for the \`forward\` button icon. Default is
  `"fa fa-caret-right"`.

- backText:

  The text in the buttons. Default is ”.

- forwardText:

  The text in the buttons. Default is ”.

- backTooltip:

  Tooltip content. Default is `"Go to Previous Extent"`.

- forwardTooltip:

  Tooltip content. Default is `"Go to Next Extent"`.

- backImageBeforeText:

  When both text and image are present, whether to show the image first
  or the text first (left to right). Default is `TRUE`

- forwardImageBeforeText:

  When both text and image are present, whether to show the image first
  or the text first (left to right). Default is `FALSE`

- orientation:

  Whether to position the buttons on top of one another or side-by-side.
  Default is `horizontal`

- shouldSaveMoveInHistory:

  A JS callback you can provide that gets called with every move. return
  false to not save a move.

## Value

A list of further options for `addHistory`

## References

<https://github.com/cscott530/leaflet-history>

## See also

Other History Functions:
[`addHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/addHistory.md),
[`clearFuture()`](https://trafficonese.github.io/leaflet.extras2/reference/clearFuture.md),
[`clearHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/clearHistory.md),
[`goBackHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/goBackHistory.md),
[`goForwardHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/goForwardHistory.md)

## Examples

``` r
library(leaflet)
leaflet() %>%
  addTiles() %>%
  addHistory(options = historyOptions(
    position = "bottomright",
    maxMovesToSave = 20,
    backText = "Go back",
    forwardText = "Go forward",
    orientation = "vertical"
  ))

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addHistory","args":[null,{"position":"bottomright","maxMovesToSave":20,"backImage":"fa fa-caret-left","forwardImage":"fa fa-caret-right","backText":"Go back","forwardText":"Go forward","backTooltip":"Go to Previous Extent","forwardTooltip":"Go to Next Extent","backImageBeforeText":true,"forwardImageBeforeText":false,"orientation":"vertical"}]}]},"evals":[],"jsHooks":[]}
```
