# Add addLabelgun Plugin

The plugin allows to avoid cluttering in marker labels and gives
priority to labels of your choice (with higher weight).

## Usage

``` r
addLabelgun(map, group = NULL, weight = NULL, entries = NULL)
```

## Arguments

- map:

  A map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- group:

  The group name of the layer/s for which label collisions are to be
  avoided. To see the effects of this plugin the `labelOptions` of the
  markers must be configured with either `permanent = TRUE` or
  `noHide = TRUE`.

- weight:

  An optional weight for markers. If a vector is given, the length
  should match the number of all markers in the corresponding groups. If
  a numeric value is specified, it is used for each marker and thus no
  prioritization of the labels takes place. In all other cases a random
  integer is calculated.

- entries:

  A numeric value, a higher value relates to faster insertion and slower
  search, and vice versa. The default is 10

## Value

A leaflet map object

## Note

It is important to invoke the function after the markers have been added
to the map. Otherwise nothing will happen.

## References

<https://github.com/Geovation/labelgun>

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

leaflet() %>%
  addTiles() %>%
  addMarkers(
    data = breweries91,
    label = ~brewery,
    group = "markers",
    labelOptions = labelOptions(permanent = TRUE)
  ) %>%
  addLabelgun("markers", 1)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addMarkers","args":[[49.71979,49.884051,49.502098,49.274716,49.861905,49.794334,49.701477,49.067436,49.070292,49.77994,49.060542,49.561804,49.595108,49.602554,49.72581,49.7202,49.644533,49.645651,49.615866,49.50683,48.900742,49.707329,49.884229,49.677827,49.450083,49.710838,49.276265,49.554706,49.882777,49.727998,49.737703,49.755953],[10.889217,11.228988,10.416021,10.928096,11.291932,11.509409,11.163238,10.34418,10.316987,11.186931,10.965571,11.368508,11.009011,11.005049,11.059662,11.056749,11.252699,11.248618,10.630027,11.428338,11.029479,10.806113,11.267583,11.252911,11.308721,11.172792,10.685605,11.22997,11.129541,11.202701,11.223148,11.175664],null,null,"markers",{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,["Brauerei Rittmayer","Aufsesser Brauerei","Brauhaus Doebler","Brauerei Gundel GmbH","Krug-Braeu","Brauerei-Gasthof Herold","Brauerei Alt Dietzhof","Brauerei Hauf KG","Weib's Brauhaus Dinkelsbuehl","Schwanenbraeu","Fuerst Carl Schlossbrauerei Ellingen","Brauerei Enzensteiner","Kitzmann-Braeu GmbH &amp; Co. Kg","Steinbach Braeu","Brauerei Greif","Brauerei Hebendanz GmbH","Brauerei Friedmann","Lindenbraeu","Brauerei Windsheimer GmbH","Buergerbraeu Hersbruck, Deinlein &amp; Co.","Hochholzer Brauhaus Poeverlein GbR","Brauhaus Hoechstadt","Brauerei und Gasthof Reichold GmbH","Brauerei Hofmann/Nentwig GbR","Leinburger Bier","Brauerei Gasthof Drummer","Hauff Braeu Lichtnerau GmbH &amp; Co. KG","Brauerei Wiethaler","Brauerei Gasthof Ott","Brauerei Penning-Zeissler","Brauerei Meister","Brauerei Nikl"],{"interactive":false,"permanent":true,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addLabelgun","args":["markers",1,null]}],"limits":{"lat":[48.900742,49.884229],"lng":[10.316987,11.509409]}},"evals":[],"jsHooks":[]}
```
