# Add Queryable WMS Layer

A Leaflet plugin for working with Web Map services, providing:
single-tile/untiled/nontiled layers, shared WMS sources, and
**GetFeatureInfo**-powered identify.

You can also use **CQL-Filters** by appending a string to the
`'baseUrl'`.

Something like `'http://server/wms?cql_filter=attribute=value'`

## Usage

``` r
addWMS(
  map,
  baseUrl,
  layerId = NULL,
  group = NULL,
  options = WMSTileOptions(),
  attribution = NULL,
  layers = NULL,
  popupOptions = NULL,
  checkempty = FALSE,
  data = getMapData(map)
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- baseUrl:

  a base URL of the WMS service

- layerId:

  the layer id

- group:

  the name of the group the newly created layers should belong to (for
  [`clearGroup`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g. markers and polygons) can share the same group
  name.

- options:

  a list of extra options for tile layers, popups, paths (circles,
  rectangles, polygons, ...), or other map elements

- attribution:

  the attribution text of the tile layer (HTML)

- layers:

  comma-separated list of WMS layers to show

- popupOptions:

  List of popup options. See
  [`popupOptions`](https://rstudio.github.io/leaflet/reference/map-options.html).
  Default is NULL.

- checkempty:

  Should the returned HTML-content be checked for emptiness? If the
  HTML-body is empty no popup is opened. Default is `FALSE`

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Value

the new `map` object

## References

<https://github.com/heigeo/leaflet.wms>

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

leaflet() %>%
  addTiles(group = "base") %>%
  setView(9, 50, 5) %>%
  addWMS(
    baseUrl = "https://maps.dwd.de/geoserver/dwd/wms",
    layers = "dwd:BRD_1km_winddaten_10m",
    popupOptions = popupOptions(maxWidth = 600),
    checkempty = TRUE,
    options = WMSTileOptions(
      transparent = TRUE,
      format = "image/png",
      info_format = "text/html"
    )
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,"base",{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addWMS","args":["https://maps.dwd.de/geoserver/dwd/wms",null,null,{"styles":"","format":"image/png","transparent":true,"version":"1.1.1","info_format":"text/html","layers":"dwd:BRD_1km_winddaten_10m","checkempty":true},{"maxWidth":600,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":""}]}],"setView":[[50,9],5,[]]},"evals":[],"jsHooks":[]}
```
