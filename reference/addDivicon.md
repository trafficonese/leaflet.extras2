# Add DivIcon Markers to a Leaflet Map

Adds customizable DivIcon markers to a Leaflet map. The function can
accept either spatial data (lines or points) in the form of a Simple
Feature (sf) object or numeric vectors for latitude and longitude
coordinates. It allows for the application of custom HTML content and
CSS classes to each marker, providing high flexibility in marker design.

## Usage

``` r
addDivicon(
  map,
  lng = NULL,
  lat = NULL,
  layerId = NULL,
  group = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  className = NULL,
  html = NULL,
  options = markerOptions(),
  clusterOptions = NULL,
  clusterId = NULL,
  divOptions = list(),
  data = getMapData(map)
)
```

## Arguments

- map:

  the map to add awesome Markers to.

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
  [`clearGroup()`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl()`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g., markers and polygons) can share the same group
  name.

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

- className:

  A single CSS class or a vector of CSS classes.

- html:

  A single HTML string or a vector of HTML strings.

- options:

  a list of extra options for tile layers, popups, paths (circles,
  rectangles, polygons, ...), or other map elements

- clusterOptions:

  if not `NULL`, markers will be clustered using
  [Leaflet.markercluster](https://github.com/Leaflet/Leaflet.markercluster);
  you can use
  [`markerClusterOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to specify marker cluster options

- clusterId:

  the id for the marker cluster layer

- divOptions:

  A list of extra options for Leaflet DivIcon.

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Value

The modified Leaflet map object.

## Examples

``` r
library(sf)
library(leaflet)
library(leaflet.extras2)

# Sample data
df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(1:nrow(df), 50, replace = FALSE), ]
df$classes <- sample(x = c("myclass1", "myclass2", "myclass3"), nrow(df), replace = TRUE)
df$ID <- paste0("ID_", 1:nrow(df))

leaflet() %>%
  addTiles() %>%
  addDivicon(
    data = df,
    html = ~ paste0(
      '<div class="custom-html">',
      '<div class="title">', Name, "</div>",
      '<div class="subtitle">MaxWind: ', MaxWind, "</div>",
      "</div>"
    ),
    label = ~Name,
    layerId = ~ID,
    group = "Divicons",
    popup = ~ paste(
      "ID: ", ID, "<br>",
      "Name: ", Name, "<br>",
      "MaxWind:", MaxWind, "<br>",
      "MinPress:", MinPress
    ),
    options = markerOptions(draggable = TRUE)
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addDivicon","args":[[11,43.3,12,29.6,19.7,41.3,11,37,19.9,42.3,20.9,16.1,21.8,31.7,11,34.9,13.9,30.7,32.2,29.1,17.6,21.6,13.7,31.3,28.5,26.2,39.1,25.2,24.4,44.2,34.5,19.7,30.5,24.7,21.6,25.5,18.9,16.7,16.6,38.4,44.5,30.8,19.3,44,31.6,52.2,19.7,28.2,41.1,39.2],[-53.7,-30.7,-61.8,-56,-96.40000000000001,-31.5,-50.2,-87.8,-47.2,-41.1,-79.5,-53.2,-39.4,-77.3,-52,-44.1,-46.7,-66,-68.3,-27.5,-58.9,-87,-68.40000000000001,-66.40000000000001,-90.3,-76.40000000000001,-74.8,-86.7,-84,-32.2,-45.9,-95.40000000000001,-63.8,-87.3,-72.90000000000001,-53.6,-84.3,-55.9,-81.09999999999999,-66.59999999999999,-37.7,-34.9,-87.90000000000001,-57.5,-69.90000000000001,-30.5,-84.09999999999999,-89.59999999999999,-42.1,-85.7],["ID_1","ID_2","ID_3","ID_4","ID_5","ID_6","ID_7","ID_8","ID_9","ID_10","ID_11","ID_12","ID_13","ID_14","ID_15","ID_16","ID_17","ID_18","ID_19","ID_20","ID_21","ID_22","ID_23","ID_24","ID_25","ID_26","ID_27","ID_28","ID_29","ID_30","ID_31","ID_32","ID_33","ID_34","ID_35","ID_36","ID_37","ID_38","ID_39","ID_40","ID_41","ID_42","ID_43","ID_44","ID_45","ID_46","ID_47","ID_48","ID_49","ID_50"],"Divicons",{"interactive":true,"draggable":true,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,["<div class=\"custom-html\"><div class=\"title\">EMILY<\/div><div class=\"subtitle\">MaxWind: 140<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">HARVEY<\/div><div class=\"subtitle\">MaxWind: 55<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">EMILY<\/div><div class=\"subtitle\">MaxWind: 140<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">MARIA<\/div><div class=\"subtitle\">MaxWind: 100<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">JOSE<\/div><div class=\"subtitle\">MaxWind: 50<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">HARVEY<\/div><div class=\"subtitle\">MaxWind: 55<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">EMILY<\/div><div class=\"subtitle\">MaxWind: 140<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">ARLENE<\/div><div class=\"subtitle\">MaxWind: 60<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">MARIA<\/div><div class=\"subtitle\">MaxWind: 100<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">HARVEY<\/div><div class=\"subtitle\">MaxWind: 55<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">DENNIS<\/div><div class=\"subtitle\">MaxWind: 130<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">TEN<\/div><div class=\"subtitle\">MaxWind: 30<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">DELTA<\/div><div class=\"subtitle\">MaxWind: 60<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">OPHELIA<\/div><div class=\"subtitle\">MaxWind: 75<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">EMILY<\/div><div class=\"subtitle\">MaxWind: 140<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">NATE<\/div><div class=\"subtitle\">MaxWind: 80<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">TEN<\/div><div class=\"subtitle\">MaxWind: 30<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">TWENTY-TWO<\/div><div class=\"subtitle\">MaxWind: 40<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">FRANKLIN<\/div><div class=\"subtitle\">MaxWind: 60<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">DELTA<\/div><div class=\"subtitle\">MaxWind: 60<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">TEN<\/div><div class=\"subtitle\">MaxWind: 30<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">WILMA<\/div><div class=\"subtitle\">MaxWind: 160<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">EMILY<\/div><div class=\"subtitle\">MaxWind: 140<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">HARVEY<\/div><div class=\"subtitle\">MaxWind: 55<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">CINDY<\/div><div class=\"subtitle\">MaxWind: 65<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">FRANKLIN<\/div><div class=\"subtitle\">MaxWind: 60<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">CINDY<\/div><div class=\"subtitle\">MaxWind: 65<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">KATRINA<\/div><div class=\"subtitle\">MaxWind: 150<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">KATRINA<\/div><div class=\"subtitle\">MaxWind: 150<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">HARVEY<\/div><div class=\"subtitle\">MaxWind: 55<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">NATE<\/div><div class=\"subtitle\">MaxWind: 80<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">BRET<\/div><div class=\"subtitle\">MaxWind: 35<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">NATE<\/div><div class=\"subtitle\">MaxWind: 80<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">RITA<\/div><div class=\"subtitle\">MaxWind: 155<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">ALPHA<\/div><div class=\"subtitle\">MaxWind: 45<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">LEE<\/div><div class=\"subtitle\">MaxWind: 35<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">EMILY<\/div><div class=\"subtitle\">MaxWind: 140<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">PHILIPPE<\/div><div class=\"subtitle\">MaxWind: 70<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">WILMA<\/div><div class=\"subtitle\">MaxWind: 160<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">FRANKLIN<\/div><div class=\"subtitle\">MaxWind: 60<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">MARIA<\/div><div class=\"subtitle\">MaxWind: 100<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">EPSILON<\/div><div class=\"subtitle\">MaxWind: 75<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">CINDY<\/div><div class=\"subtitle\">MaxWind: 65<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">WILMA<\/div><div class=\"subtitle\">MaxWind: 160<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">IRENE<\/div><div class=\"subtitle\">MaxWind: 90<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">OPHELIA<\/div><div class=\"subtitle\">MaxWind: 75<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">ARLENE<\/div><div class=\"subtitle\">MaxWind: 60<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">KATRINA<\/div><div class=\"subtitle\">MaxWind: 150<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">MARIA<\/div><div class=\"subtitle\">MaxWind: 100<\/div><\/div>","<div class=\"custom-html\"><div class=\"title\">DENNIS<\/div><div class=\"subtitle\">MaxWind: 130<\/div><\/div>"],["ID:  ID_1 <br> Name:  EMILY <br> MaxWind: 140 <br> MinPress: 929","ID:  ID_2 <br> Name:  HARVEY <br> MaxWind: 55 <br> MinPress: 994","ID:  ID_3 <br> Name:  EMILY <br> MaxWind: 140 <br> MinPress: 929","ID:  ID_4 <br> Name:  MARIA <br> MaxWind: 100 <br> MinPress: 962","ID:  ID_5 <br> Name:  JOSE <br> MaxWind: 50 <br> MinPress: 998","ID:  ID_6 <br> Name:  HARVEY <br> MaxWind: 55 <br> MinPress: 994","ID:  ID_7 <br> Name:  EMILY <br> MaxWind: 140 <br> MinPress: 929","ID:  ID_8 <br> Name:  ARLENE <br> MaxWind: 60 <br> MinPress: 989","ID:  ID_9 <br> Name:  MARIA <br> MaxWind: 100 <br> MinPress: 962","ID:  ID_10 <br> Name:  HARVEY <br> MaxWind: 55 <br> MinPress: 994","ID:  ID_11 <br> Name:  DENNIS <br> MaxWind: 130 <br> MinPress: 930","ID:  ID_12 <br> Name:  TEN <br> MaxWind: 30 <br> MinPress: 1008","ID:  ID_13 <br> Name:  DELTA <br> MaxWind: 60 <br> MinPress: 980","ID:  ID_14 <br> Name:  OPHELIA <br> MaxWind: 75 <br> MinPress: 976","ID:  ID_15 <br> Name:  EMILY <br> MaxWind: 140 <br> MinPress: 929","ID:  ID_16 <br> Name:  NATE <br> MaxWind: 80 <br> MinPress: 979","ID:  ID_17 <br> Name:  TEN <br> MaxWind: 30 <br> MinPress: 1008","ID:  ID_18 <br> Name:  TWENTY-TWO <br> MaxWind: 40 <br> MinPress: 1005","ID:  ID_19 <br> Name:  FRANKLIN <br> MaxWind: 60 <br> MinPress: 997","ID:  ID_20 <br> Name:  DELTA <br> MaxWind: 60 <br> MinPress: 980","ID:  ID_21 <br> Name:  TEN <br> MaxWind: 30 <br> MinPress: 1008","ID:  ID_22 <br> Name:  WILMA <br> MaxWind: 160 <br> MinPress: 882","ID:  ID_23 <br> Name:  EMILY <br> MaxWind: 140 <br> MinPress: 929","ID:  ID_24 <br> Name:  HARVEY <br> MaxWind: 55 <br> MinPress: 994","ID:  ID_25 <br> Name:  CINDY <br> MaxWind: 65 <br> MinPress: 991","ID:  ID_26 <br> Name:  FRANKLIN <br> MaxWind: 60 <br> MinPress: 997","ID:  ID_27 <br> Name:  CINDY <br> MaxWind: 65 <br> MinPress: 991","ID:  ID_28 <br> Name:  KATRINA <br> MaxWind: 150 <br> MinPress: 902","ID:  ID_29 <br> Name:  KATRINA <br> MaxWind: 150 <br> MinPress: 902","ID:  ID_30 <br> Name:  HARVEY <br> MaxWind: 55 <br> MinPress: 994","ID:  ID_31 <br> Name:  NATE <br> MaxWind: 80 <br> MinPress: 979","ID:  ID_32 <br> Name:  BRET <br> MaxWind: 35 <br> MinPress: 1002","ID:  ID_33 <br> Name:  NATE <br> MaxWind: 80 <br> MinPress: 979","ID:  ID_34 <br> Name:  RITA <br> MaxWind: 155 <br> MinPress: 895","ID:  ID_35 <br> Name:  ALPHA <br> MaxWind: 45 <br> MinPress: 998","ID:  ID_36 <br> Name:  LEE <br> MaxWind: 35 <br> MinPress: 1006","ID:  ID_37 <br> Name:  EMILY <br> MaxWind: 140 <br> MinPress: 929","ID:  ID_38 <br> Name:  PHILIPPE <br> MaxWind: 70 <br> MinPress: 985","ID:  ID_39 <br> Name:  WILMA <br> MaxWind: 160 <br> MinPress: 882","ID:  ID_40 <br> Name:  FRANKLIN <br> MaxWind: 60 <br> MinPress: 997","ID:  ID_41 <br> Name:  MARIA <br> MaxWind: 100 <br> MinPress: 962","ID:  ID_42 <br> Name:  EPSILON <br> MaxWind: 75 <br> MinPress: 981","ID:  ID_43 <br> Name:  CINDY <br> MaxWind: 65 <br> MinPress: 991","ID:  ID_44 <br> Name:  WILMA <br> MaxWind: 160 <br> MinPress: 882","ID:  ID_45 <br> Name:  IRENE <br> MaxWind: 90 <br> MinPress: 970","ID:  ID_46 <br> Name:  OPHELIA <br> MaxWind: 75 <br> MinPress: 976","ID:  ID_47 <br> Name:  ARLENE <br> MaxWind: 60 <br> MinPress: 989","ID:  ID_48 <br> Name:  KATRINA <br> MaxWind: 150 <br> MinPress: 902","ID:  ID_49 <br> Name:  MARIA <br> MaxWind: 100 <br> MinPress: 962","ID:  ID_50 <br> Name:  DENNIS <br> MaxWind: 130 <br> MinPress: 930"],null,["EMILY","HARVEY","EMILY","MARIA","JOSE","HARVEY","EMILY","ARLENE","MARIA","HARVEY","DENNIS","TEN","DELTA","OPHELIA","EMILY","NATE","TEN","TWENTY-TWO","FRANKLIN","DELTA","TEN","WILMA","EMILY","HARVEY","CINDY","FRANKLIN","CINDY","KATRINA","KATRINA","HARVEY","NATE","BRET","NATE","RITA","ALPHA","LEE","EMILY","PHILIPPE","WILMA","FRANKLIN","MARIA","EPSILON","CINDY","WILMA","IRENE","OPHELIA","ARLENE","KATRINA","MARIA","DENNIS"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null,[],null]}],"limits":{"lat":[11,52.2],"lng":[-96.40000000000001,-27.5]}},"evals":[],"jsHooks":[]}
```
