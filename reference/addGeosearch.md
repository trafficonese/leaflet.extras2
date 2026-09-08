# Add a GeoSearch control to a Leaflet map

Adds a geocoding search widget to a leaflet map using the
leaflet-geosearch plugin. Supports multiple providers such as
OpenStreetMap, Esri, Google, HERE, etc.

## Usage

``` r
addGeosearch(map, provider = geosearchProvider(), options = geosearchOptions())
```

## Arguments

- map:

  a map widget

- provider:

  A provider list object created with e.g.
  [`geosearchProvider`](https://trafficonese.github.io/leaflet.extras2/reference/geosearchProvider.md)

- options:

  A list of control options created with
  [`geosearchOptions`](https://trafficonese.github.io/leaflet.extras2/reference/geosearchOptions.md).

## Value

the new `map` object

## Shiny value

When used inside a Shiny application, `addGeosearch()` will also
register two reactive inputs that return the most recent geosearch
results:

- `input$<mapId>_geosearch_result` Updated when a search result is
  selected (from the `geosearch/showlocation` event). Returns a list
  with `lat`, `lng`, `label`, `bounds`, and other properties provided by
  the geocoder.

- `input$<mapId>_geosearch_dragend` Updated when the marker placed by
  the geosearch control is dragged to a new location (from the
  `geosearch/marker/dragend` event). Returns the same structure as
  above.

Both values are `NULL` if no result is available.

## References

<https://github.com/smeijer/leaflet-geosearch>

## See also

Other Geosearch Functions:
[`geosearchOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/geosearchOptions.md),
[`removeGeosearch()`](https://trafficonese.github.io/leaflet.extras2/reference/removeGeosearch.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

leaflet() %>%
  addTiles() %>%
  addGeosearch()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addGeosearch","args":[{"type":"OSM","options":[]},{"style":"button","resetButton":"x","notFoundMessage":"Nothing found","autoComplete":true,"autoCompleteDelay":250,"showMarker":true,"showPopup":false,"maxMarkers":1,"retainZoomLevel":false,"animateZoom":true,"autoClose":false,"searchLabel":"Enter address","keepResult":false,"updateMap":true}]}]},"evals":[],"jsHooks":[]}
```
