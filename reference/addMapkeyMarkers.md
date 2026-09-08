# Add Mapkey Markers

Add Mapkey Markers

## Usage

``` r
addMapkeyMarkers(
  map,
  lng = NULL,
  lat = NULL,
  layerId = NULL,
  group = NULL,
  icon = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  options = leaflet::markerOptions(),
  clusterOptions = NULL,
  clusterId = NULL,
  data = leaflet::getMapData(map)
)
```

## Arguments

- map:

  the map to add mapkey Markers to.

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

- options:

  a list of extra options for markers. See
  [`markerOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)

- clusterOptions:

  if not `NULL`, markers will be clustered using
  [Leaflet.markercluster](https://github.com/Leaflet/Leaflet.markercluster);
  you can use
  [`markerClusterOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to specify marker cluster options

- clusterId:

  the id for the marker cluster layer

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Value

the new `map` object

## References

<https://github.com/mapshakers/leaflet-mapkey-icon>

## See also

Other Mapkey Functions:
[`[.leaflet_mapkey_icon_set()`](https://trafficonese.github.io/leaflet.extras2/reference/sub-.leaflet_mapkey_icon_set.md),
[`makeMapkeyIcon()`](https://trafficonese.github.io/leaflet.extras2/reference/makeMapkeyIcon.md),
[`mapkeyIconList()`](https://trafficonese.github.io/leaflet.extras2/reference/mapkeyIconList.md),
[`mapkeyIcons()`](https://trafficonese.github.io/leaflet.extras2/reference/mapkeyIcons.md)

## Examples

``` r
library(leaflet)

leaflet() %>%
  addTiles() %>%
  addMapkeyMarkers(
    data = breweries91,
    icon = makeMapkeyIcon(
      icon = "mapkey",
      iconSize = 30,
      boxShadow = FALSE,
      background = "transparent"
    ),
    group = "mapkey",
    label = ~state, popup = ~village
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addMapkeyMarkers","args":[[49.71979,49.884051,49.502098,49.274716,49.861905,49.794334,49.701477,49.067436,49.070292,49.77994,49.060542,49.561804,49.595108,49.602554,49.72581,49.7202,49.644533,49.645651,49.615866,49.50683,48.900742,49.707329,49.884229,49.677827,49.450083,49.710838,49.276265,49.554706,49.882777,49.727998,49.737703,49.755953],[10.889217,11.228988,10.416021,10.928096,11.291932,11.509409,11.163238,10.34418,10.316987,11.186931,10.965571,11.368508,11.009011,11.005049,11.059662,11.056749,11.252699,11.248618,10.630027,11.428338,11.029479,10.806113,11.267583,11.252911,11.308721,11.172792,10.685605,11.22997,11.129541,11.202701,11.223148,11.175664],{"icon":"mapkey","color":"#ff0000","size":30,"background":"transparent","borderRadius":"100%","hoverScale":1.4,"hoverEffect":true,"boxShadow":false},null,"mapkey",{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},["Adelsdorf","Aufsess","Bad Windsheim","Barthelmesaurach","Waischenfeld","Buechenbach","Leutenbach","Dinkelsbuehl","Dinkelsbuehl","Ebermannstadt","Ellingen","Schnaittach","Erlangen","Erlangen","Forchheim","Forchheim","Graefenberg","Graefenberg","Gutenstetten","Hersbruck","Solnhofen","Hoechstadt","Aufsess","Graefenberg","Leinburg","Lautenbach","Lichtenau","Neunhof bei Lauf a.d. Pegnitz","Heiligenstadt i. Ofr.","Pretzfeld","Pretzfeld","Pretzfeld"],null,null,null,["Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern","Bayern"],null]}],"limits":{"lat":[48.900742,49.884229],"lng":[10.316987,11.509409]}},"evals":[],"jsHooks":[]}
```
