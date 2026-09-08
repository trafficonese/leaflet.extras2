# Add Moving Markers

The function expects either line or point data as spatial data or as
Simple Feature. Alternatively, coordinates can also be passed as numeric
vectors.

## Usage

``` r
addMovingMarker(
  map,
  lng = NULL,
  lat = NULL,
  layerId = NULL,
  group = NULL,
  duration = 2000,
  icon = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  movingOptions = movingMarkerOptions(),
  options = leaflet::markerOptions(),
  data = leaflet::getMapData(map)
)
```

## Arguments

- map:

  the map to add moving markers

- lng:

  a numeric vector of longitudes, or a one-sided formula of the form
  `~x` where `x` is a variable in `data`; by default (if not explicitly
  provided), it will be automatically inferred from `data` by looking
  for a column named `lng`, `long`, or `longitude` (case-insensitively)

- lat:

  a vector of latitudes or a formula (similar to the `lng` argument; the
  names `lat` and `latitude` are used when guessing the latitude column
  from `data`)

- layerId:

  In order to be able to address the moving markings individually, a
  layerId is required. If none is specified, one is created that is
  derived from the current timestamp.

- group:

  the name of the group the newly created layers should belong to (for
  [`clearGroup`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g. markers and polygons) can share the same group
  name.

- duration:

  Duration in milliseconds per line segment between 2 points. Can be a
  vector or a single number. Default is `1000`

- icon:

  the icon(s) for markers;

- popup:

  a character vector of the HTML content for the popups (you are
  recommended to escape the text using
  [`htmlEscape()`](https://rstudio.github.io/htmltools/reference/htmlEscape.html)
  for security reasons)

- popupOptions:

  A Vector of
  [`popupOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide popups

- label:

  a character vector of the HTML content for the labels

- labelOptions:

  A Vector of
  [`labelOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide label options for each label. Default `NULL`

- movingOptions:

  a list of extra options for moving markers. See
  [`movingMarkerOptions`](https://trafficonese.github.io/leaflet.extras2/reference/movingMarkerOptions.md)

- options:

  a list of extra options for markers. See
  [`markerOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Value

the new `map` object

## References

<https://github.com/ewoken/Leaflet.MovingMarker>

## See also

Other MovingMarker Functions:
[`movingMarkerOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/movingMarkerOptions.md),
[`startMoving()`](https://trafficonese.github.io/leaflet.extras2/reference/startMoving.md)

## Examples

``` r
library(sf)
library(leaflet)
library(leaflet.extras2)

crds <- data.frame(structure(
  c(
    -67.5, -68.5, -69.6, -70.5, -71.3, -72.2, -72.7,
    -72.9, -73, -72.4, -70.8, 15.8, 16.5, 17.3, 17.8, 18.3, 18.6,
    19.8, 21.6, 23.5, 25.1, 27.9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  ),
  dim = c(11L, 3L), dimnames = list(NULL, c("X", "Y", "L1"))
))
df <- st_sf(st_sfc(st_linestring(as.matrix(crds), dim = "XYZ"), crs = 4326))
st_geometry(df) <- "geometry"
df <- st_zm(df)

leaflet() %>%
  addTiles() %>%
  addPolylines(data = df) %>%
  addMovingMarker(
    data = df,
    movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
    label = "I am a pirate!",
    popup = "Arrr"
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addPolylines","args":[[[[{"lng":[-67.5,-68.5,-69.59999999999999,-70.5,-71.3,-72.2,-72.7,-72.90000000000001,-73,-72.40000000000001,-70.8],"lat":[15.8,16.5,17.3,17.8,18.3,18.6,19.8,21.6,23.5,25.1,27.9]}]]],null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":false,"fillColor":"#03F","fillOpacity":0.2,"smoothFactor":1,"noClip":false},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addMovingMarker","args":[[[15.8,-67.5],[16.5,-68.5],[17.3,-69.59999999999999],[17.8,-70.5],[18.3,-71.3],[18.6,-72.2],[19.8,-72.7],[21.6,-72.90000000000001],[23.5,-73],[25.1,-72.40000000000001],[27.9,-70.8]],2000,null,"_1788893425.7894",null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250,"autostart":true,"loop":true,"pauseOnZoom":false},"Arrr",null,"I am a pirate!",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true}]}],"limits":{"lat":[15.8,27.9],"lng":[-73,-67.5]}},"evals":[],"jsHooks":[]}
```
