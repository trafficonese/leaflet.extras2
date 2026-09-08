# addClusterCharts

Clusters markers on a Leaflet map and visualizes them using customizable
charts, such as pie or bar charts, showing counts by category. When
using the `"custom"` type, a pie chart is rendered with aggregated data,
employing methods like sum, min, max, mean, or median.

## Usage

``` r
addClusterCharts(
  map,
  layerId = NULL,
  group = NULL,
  type = c("pie", "bar", "horizontal", "custom"),
  aggregation = c("sum", "min", "max", "mean", "median"),
  valueField = NULL,
  options = clusterchartOptions(),
  icon = NULL,
  html = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  clusterOptions = NULL,
  clusterId = NULL,
  categoryField,
  categoryMap,
  popupFields = NULL,
  popupLabels = NULL,
  markerOptions = NULL,
  legendOptions = list(title = "", position = "topright"),
  data = getMapData(map)
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

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

- type:

  The type of chart to use for clusters: `"pie"`, `"bar"`,
  `"horizontal"`, or `"custom"`.

- aggregation:

  Aggregation method for `"custom"` charts (e.g., sum, min, max, mean,
  median).

- valueField:

  Column name with values to aggregate for `"custom"` charts.

- options:

  Additional options for cluster charts (see
  [`clusterchartOptions`](https://trafficonese.github.io/leaflet.extras2/reference/clusterchartOptions.md)).

- icon:

  An icon or set of icons to include, created with `makeIcon` or
  `iconList`.

- html:

  The column name containing the HTML content to include in the markers.

- popup:

  The column name used to retrieve feature properties for the popup.

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

- clusterOptions:

  if not `NULL`, markers will be clustered using
  [Leaflet.markercluster](https://github.com/Leaflet/Leaflet.markercluster);
  you can use
  [`markerClusterOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to specify marker cluster options

- clusterId:

  the id for the marker cluster layer

- categoryField:

  Column name for categorizing charts.

- categoryMap:

  A data.frame mapping categories to chart properties (e.g., label,
  color, icons, stroke).

- popupFields:

  A string or vector of strings indicating the column names to include
  in popups.

- popupLabels:

  A string or vector of strings indicating the labels for the popup
  fields.

- markerOptions:

  Additional options for markers (see
  [`markerOptions::markerOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)).

- legendOptions:

  A list of options for the legend, including the title and position.

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Details

The \`clusterCharts\` use Leaflet's \`L.DivIcon\`, allowing you to fully
customize the styling of individual markers and clusters using CSS. Each
individual marker within a cluster is assigned the CSS class
\`clustermarker\`, while the entire cluster is assigned the class
\`clustermarker-cluster\`. You can modify the appearance of these
elements by targeting these classes in your custom CSS.

## See also

Other clusterCharts:
[`clusterchartOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/clusterchartOptions.md)

## Examples

``` r
# Example usage:
library(sf)
library(leaflet)
library(leaflet.extras2)

data <- sf::st_as_sf(breweries91)
categories <- c("Schwer", "Mäßig", "Leicht", "kein Schaden")
data$category <- sample(categories, size = nrow(data), replace = TRUE)

## Pie Chart
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
  addClusterCharts(
    data = data,
    categoryField = "category",
    categoryMap = data.frame(
      labels = categories,
      colors = c("#F88", "#FA0", "#FF3", "#BFB"),
      strokes = "gray"
    ),
    group = "clustermarkers",
    popupFields = c("brewery", "address", "zipcode", "category"),
    popupLabels = c("Brauerei", "Adresse", "PLZ", "Art"),
    label = "brewery"
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addLayersControl","args":[[],"clustermarkers",{"collapsed":true,"autoZIndex":true,"position":"topright"}]},{"method":"addClusterCharts","args":[{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"brewery":"Brauerei Rittmayer","address":"Aischer Hauptstrasse 5","zipcode":91325,"village":"Adelsdorf","state":"Bayern","web":"<a href='http://www.rittmayer-aisch.de' target=\"_blank\">www.rittmayer-aisch.de\u003c/a>","founded":1422,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[10.889217,49.71979]}},{"type":"Feature","properties":{"brewery":"Aufsesser Brauerei","address":"Im Tal 70b","zipcode":91347,"village":"Aufsess","state":"Bayern","web":"<a href='http://www.aufsesser.de' target=\"_blank\">www.aufsesser.de\u003c/a>","founded":1886,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.228988,49.884051]}},{"type":"Feature","properties":{"brewery":"Brauhaus Doebler","address":"Kornmarkt 6","zipcode":91438,"village":"Bad Windsheim","state":"Bayern","web":"<a href='http://www.brauhaus-doebler.de' target=\"_blank\">www.brauhaus-doebler.de\u003c/a>","founded":1867,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[10.416021,49.502098]}},{"type":"Feature","properties":{"brewery":"Brauerei Gundel GmbH","address":"Noerdlinger Strasse 15","zipcode":91126,"village":"Barthelmesaurach","state":"Bayern","web":"<a href='http://www.brauerei-gundel.de' target=\"_blank\">www.brauerei-gundel.de\u003c/a>","founded":1887,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[10.928096,49.274716]}},{"type":"Feature","properties":{"brewery":"Krug-Braeu","address":"Breitenlesau 1b","zipcode":91344,"village":"Waischenfeld","state":"Bayern","web":"<a href='http://www.krug-braeu.de' target=\"_blank\">www.krug-braeu.de\u003c/a>","founded":1834,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.291932,49.861905]}},{"type":"Feature","properties":{"brewery":"Brauerei-Gasthof Herold","address":"Marktstrasse 29","zipcode":91257,"village":"Buechenbach","state":"Bayern","web":"<a href='http://www.beckn-bier.de' target=\"_blank\">www.beckn-bier.de\u003c/a>","founded":1568,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.509409,49.794334]}},{"type":"Feature","properties":{"brewery":"Brauerei Alt Dietzhof","address":"Dietzhof 42","zipcode":91359,"village":"Leutenbach","state":"Bayern","web":"<a href='http://www.brauerei-alt.de' target=\"_blank\">www.brauerei-alt.de\u003c/a>","founded":1886,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.163238,49.701477]}},{"type":"Feature","properties":{"brewery":"Brauerei Hauf KG","address":"Heiningerstrasse 28","zipcode":91550,"village":"Dinkelsbuehl","state":"Bayern","web":"<a href='http://www.hauf-bier.de' target=\"_blank\">www.hauf-bier.de\u003c/a>","founded":1901,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[10.34418,49.067436]}},{"type":"Feature","properties":{"brewery":"Weib's Brauhaus Dinkelsbuehl","address":"Untere Schmiedgasse 13","zipcode":91550,"village":"Dinkelsbuehl","state":"Bayern","web":"<a href='http://www.weibsbrauhaus.de' target=\"_blank\">www.weibsbrauhaus.de\u003c/a>","founded":1999,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[10.316987,49.070292]}},{"type":"Feature","properties":{"brewery":"Schwanenbraeu","address":"Am Marktplatz 2","zipcode":91320,"village":"Ebermannstadt","state":"Bayern","web":"<a href='http://www.schwanenbraeu.de' target=\"_blank\">www.schwanenbraeu.de\u003c/a>","founded":null,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.186931,49.77994]}},{"type":"Feature","properties":{"brewery":"Fuerst Carl Schlossbrauerei Ellingen","address":"Schloss-Strasse 10","zipcode":91792,"village":"Ellingen","state":"Bayern","web":"<a href='http://www.fuerst-carl.de' target=\"_blank\">www.fuerst-carl.de\u003c/a>","founded":1690,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[10.965571,49.060542]}},{"type":"Feature","properties":{"brewery":"Brauerei Enzensteiner","address":"Enzenreuth 8","zipcode":91220,"village":"Schnaittach","state":"Bayern","web":"<a href='http://www.enzensteiner.de' target=\"_blank\">www.enzensteiner.de\u003c/a>","founded":1998,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.368508,49.561804]}},{"type":"Feature","properties":{"brewery":"Kitzmann-Braeu GmbH & Co. Kg","address":"Suedliche Stadtmauerstrasse 25","zipcode":91054,"village":"Erlangen","state":"Bayern","web":"<a href='http://www.kitzmann.de' target=\"_blank\">www.kitzmann.de\u003c/a>","founded":1712,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.009011,49.595108]}},{"type":"Feature","properties":{"brewery":"Steinbach Braeu","address":"Vierzigmannstrasse 4","zipcode":91054,"village":"Erlangen","state":"Bayern","web":"<a href='http://www.steinbach-braeu.de' target=\"_blank\">www.steinbach-braeu.de\u003c/a>","founded":1861,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.005049,49.602554]}},{"type":"Feature","properties":{"brewery":"Brauerei Greif","address":"Serlbacher Strasse 10","zipcode":91301,"village":"Forchheim","state":"Bayern","web":"<a href='http://www.brauerei-greif.de' target=\"_blank\">www.brauerei-greif.de\u003c/a>","founded":1848,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.059662,49.72581]}},{"type":"Feature","properties":{"brewery":"Brauerei Hebendanz GmbH","address":"Sattlertorstrasse 14","zipcode":91301,"village":"Forchheim","state":"Bayern","web":"<a href='http://www.brauerei-hebendanz.de' target=\"_blank\">www.brauerei-hebendanz.de\u003c/a>","founded":1579,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.056749,49.7202]}},{"type":"Feature","properties":{"brewery":"Brauerei Friedmann","address":"Jaegersberg 16","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.brauerei-friedmann.de' target=\"_blank\">www.brauerei-friedmann.de\u003c/a>","founded":1875,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.252699,49.644533]}},{"type":"Feature","properties":{"brewery":"Lindenbraeu","address":"Am Bach 3","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.lindenbraeu.de' target=\"_blank\">www.lindenbraeu.de\u003c/a>","founded":1932,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.248618,49.645651]}},{"type":"Feature","properties":{"brewery":"Brauerei Windsheimer GmbH","address":"Hauptstrasse 13","zipcode":91468,"village":"Gutenstetten","state":"Bayern","web":"<a href='http://www.brauerei-windsheimer.de' target=\"_blank\">www.brauerei-windsheimer.de\u003c/a>","founded":1767,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[10.630027,49.615866]}},{"type":"Feature","properties":{"brewery":"Buergerbraeu Hersbruck, Deinlein & Co.","address":"Lohweg 38","zipcode":91217,"village":"Hersbruck","state":"Bayern","web":"<a href='http://www.hersbrucker-bier.de' target=\"_blank\">www.hersbrucker-bier.de\u003c/a>","founded":1920,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.428338,49.50683]}},{"type":"Feature","properties":{"brewery":"Hochholzer Brauhaus Poeverlein GbR","address":"Hochholz 4a","zipcode":91807,"village":"Solnhofen","state":"Bayern","web":"<a href='http://www.hochholzer-brauhaus.de' target=\"_blank\">www.hochholzer-brauhaus.de\u003c/a>","founded":2005,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.029479,48.900742]}},{"type":"Feature","properties":{"brewery":"Brauhaus Hoechstadt","address":"Kellerstrasse 11","zipcode":91315,"village":"Hoechstadt","state":"Bayern","web":"<a href='http://www.brauhaus-hoechstadt.de' target=\"_blank\">www.brauhaus-hoechstadt.de\u003c/a>","founded":1926,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[10.806113,49.707329]}},{"type":"Feature","properties":{"brewery":"Brauerei und Gasthof Reichold GmbH","address":"Hochstahl 24","zipcode":91347,"village":"Aufsess","state":"Bayern","web":"<a href='http://www.brauerei-reichold.de' target=\"_blank\">www.brauerei-reichold.de\u003c/a>","founded":1906,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.267583,49.884229]}},{"type":"Feature","properties":{"brewery":"Brauerei Hofmann/Nentwig GbR","address":"Hohenschwaerz 16","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.brauerei-hofmann.de' target=\"_blank\">www.brauerei-hofmann.de\u003c/a>","founded":1897,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.252911,49.677827]}},{"type":"Feature","properties":{"brewery":"Leinburger Bier","address":"Marktplatz 14","zipcode":91227,"village":"Leinburg","state":"Bayern","web":"<a href='http://www.leinburgerbier.de' target=\"_blank\">www.leinburgerbier.de\u003c/a>","founded":1617,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.308721,49.450083]}},{"type":"Feature","properties":{"brewery":"Brauerei Gasthof Drummer","address":"Dorfstrasse 10","zipcode":91359,"village":"Lautenbach","state":"Bayern","web":"<a href='http://www.brauerei-gasthof-drummer.de' target=\"_blank\">www.brauerei-gasthof-drummer.de\u003c/a>","founded":1738,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.172792,49.710838]}},{"type":"Feature","properties":{"brewery":"Hauff Braeu Lichtnerau GmbH & Co. KG","address":"Marktplatz 1","zipcode":91586,"village":"Lichtenau","state":"Bayern","web":"<a href='http://www.hauff-braeu.com' target=\"_blank\">www.hauff-braeu.com\u003c/a>","founded":null,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[10.685605,49.276265]}},{"type":"Feature","properties":{"brewery":"Brauerei Wiethaler","address":"Welserplatz 6-7","zipcode":91207,"village":"Neunhof bei Lauf a.d. Pegnitz","state":"Bayern","web":"<a href='http://www.brauerei-wiethaler.de' target=\"_blank\">www.brauerei-wiethaler.de\u003c/a>","founded":1498,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.22997,49.554706]}},{"type":"Feature","properties":{"brewery":"Brauerei Gasthof Ott","address":"Oberleinleiter 6","zipcode":91332,"village":"Heiligenstadt i. Ofr.","state":"Bayern","web":"<a href='http://www.brauerei-ott.de' target=\"_blank\">www.brauerei-ott.de\u003c/a>","founded":1678,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.129541,49.882777]}},{"type":"Feature","properties":{"brewery":"Brauerei Penning-Zeissler","address":"Hetzelsdorf 9","zipcode":91362,"village":"Pretzfeld","state":"Bayern","web":null,"founded":1623,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.202701,49.727998]}},{"type":"Feature","properties":{"brewery":"Brauerei Meister","address":"Unterzaunsbach 8","zipcode":91362,"village":"Pretzfeld","state":"Bayern","web":"<a href='http://www.xn--meisterbru-y5a.de/mod/main.php' target=\"_blank\">www.meisterbr%C3%A4u.de\u003c/a>","founded":1865,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.223148,49.737703]}},{"type":"Feature","properties":{"brewery":"Brauerei Nikl","address":"Egloffsteiner Strasse 19","zipcode":91363,"village":"Pretzfeld","state":"Bayern","web":"<a href='http://www.brauerei-nikl.de/' target=\"_blank\">www.brauerei-nikl.de\u003c/a>","founded":2008,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.175664,49.755953]}}]},null,"clustermarkers","pie",{"rmax":30,"size":[20,20],"width":40,"height":50,"strokeWidth":1,"innerRadius":10,"labelBackground":false,"labelFill":"white","labelStroke":"black","labelColor":"black","labelOpacity":0.9,"digits":2,"sortTitlebyCount":true,"aggregation":"sum"},null,null,null,null,"brewery",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null,"category",{"1":"Schwer","2":"Mäßig","3":"Leicht","4":"kein Schaden"},["brewery","address","zipcode","category"],["Brauerei","Adresse","PLZ","Art"],null,{"title":"","position":"topright"}]}],"limits":{"lat":[48.900742,49.884229],"lng":[10.316987,11.509409]}},"evals":[],"jsHooks":[]}
## Bar Chart
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
  addClusterCharts(
    data = data,
    type = "bar",
    categoryField = "category",
    categoryMap = data.frame(
      labels = categories,
      colors = c("#F88", "#FA0", "#FF3", "#BFB"),
      strokes = "gray"
    ),
    group = "clustermarkers",
    popupFields = c("brewery", "address", "zipcode", "category"),
    popupLabels = c("Brauerei", "Adresse", "PLZ", "Art"),
    label = "brewery"
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addLayersControl","args":[[],"clustermarkers",{"collapsed":true,"autoZIndex":true,"position":"topright"}]},{"method":"addClusterCharts","args":[{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"brewery":"Brauerei Rittmayer","address":"Aischer Hauptstrasse 5","zipcode":91325,"village":"Adelsdorf","state":"Bayern","web":"<a href='http://www.rittmayer-aisch.de' target=\"_blank\">www.rittmayer-aisch.de\u003c/a>","founded":1422,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[10.889217,49.71979]}},{"type":"Feature","properties":{"brewery":"Aufsesser Brauerei","address":"Im Tal 70b","zipcode":91347,"village":"Aufsess","state":"Bayern","web":"<a href='http://www.aufsesser.de' target=\"_blank\">www.aufsesser.de\u003c/a>","founded":1886,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.228988,49.884051]}},{"type":"Feature","properties":{"brewery":"Brauhaus Doebler","address":"Kornmarkt 6","zipcode":91438,"village":"Bad Windsheim","state":"Bayern","web":"<a href='http://www.brauhaus-doebler.de' target=\"_blank\">www.brauhaus-doebler.de\u003c/a>","founded":1867,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[10.416021,49.502098]}},{"type":"Feature","properties":{"brewery":"Brauerei Gundel GmbH","address":"Noerdlinger Strasse 15","zipcode":91126,"village":"Barthelmesaurach","state":"Bayern","web":"<a href='http://www.brauerei-gundel.de' target=\"_blank\">www.brauerei-gundel.de\u003c/a>","founded":1887,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[10.928096,49.274716]}},{"type":"Feature","properties":{"brewery":"Krug-Braeu","address":"Breitenlesau 1b","zipcode":91344,"village":"Waischenfeld","state":"Bayern","web":"<a href='http://www.krug-braeu.de' target=\"_blank\">www.krug-braeu.de\u003c/a>","founded":1834,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.291932,49.861905]}},{"type":"Feature","properties":{"brewery":"Brauerei-Gasthof Herold","address":"Marktstrasse 29","zipcode":91257,"village":"Buechenbach","state":"Bayern","web":"<a href='http://www.beckn-bier.de' target=\"_blank\">www.beckn-bier.de\u003c/a>","founded":1568,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.509409,49.794334]}},{"type":"Feature","properties":{"brewery":"Brauerei Alt Dietzhof","address":"Dietzhof 42","zipcode":91359,"village":"Leutenbach","state":"Bayern","web":"<a href='http://www.brauerei-alt.de' target=\"_blank\">www.brauerei-alt.de\u003c/a>","founded":1886,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.163238,49.701477]}},{"type":"Feature","properties":{"brewery":"Brauerei Hauf KG","address":"Heiningerstrasse 28","zipcode":91550,"village":"Dinkelsbuehl","state":"Bayern","web":"<a href='http://www.hauf-bier.de' target=\"_blank\">www.hauf-bier.de\u003c/a>","founded":1901,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[10.34418,49.067436]}},{"type":"Feature","properties":{"brewery":"Weib's Brauhaus Dinkelsbuehl","address":"Untere Schmiedgasse 13","zipcode":91550,"village":"Dinkelsbuehl","state":"Bayern","web":"<a href='http://www.weibsbrauhaus.de' target=\"_blank\">www.weibsbrauhaus.de\u003c/a>","founded":1999,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[10.316987,49.070292]}},{"type":"Feature","properties":{"brewery":"Schwanenbraeu","address":"Am Marktplatz 2","zipcode":91320,"village":"Ebermannstadt","state":"Bayern","web":"<a href='http://www.schwanenbraeu.de' target=\"_blank\">www.schwanenbraeu.de\u003c/a>","founded":null,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.186931,49.77994]}},{"type":"Feature","properties":{"brewery":"Fuerst Carl Schlossbrauerei Ellingen","address":"Schloss-Strasse 10","zipcode":91792,"village":"Ellingen","state":"Bayern","web":"<a href='http://www.fuerst-carl.de' target=\"_blank\">www.fuerst-carl.de\u003c/a>","founded":1690,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[10.965571,49.060542]}},{"type":"Feature","properties":{"brewery":"Brauerei Enzensteiner","address":"Enzenreuth 8","zipcode":91220,"village":"Schnaittach","state":"Bayern","web":"<a href='http://www.enzensteiner.de' target=\"_blank\">www.enzensteiner.de\u003c/a>","founded":1998,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.368508,49.561804]}},{"type":"Feature","properties":{"brewery":"Kitzmann-Braeu GmbH & Co. Kg","address":"Suedliche Stadtmauerstrasse 25","zipcode":91054,"village":"Erlangen","state":"Bayern","web":"<a href='http://www.kitzmann.de' target=\"_blank\">www.kitzmann.de\u003c/a>","founded":1712,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.009011,49.595108]}},{"type":"Feature","properties":{"brewery":"Steinbach Braeu","address":"Vierzigmannstrasse 4","zipcode":91054,"village":"Erlangen","state":"Bayern","web":"<a href='http://www.steinbach-braeu.de' target=\"_blank\">www.steinbach-braeu.de\u003c/a>","founded":1861,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.005049,49.602554]}},{"type":"Feature","properties":{"brewery":"Brauerei Greif","address":"Serlbacher Strasse 10","zipcode":91301,"village":"Forchheim","state":"Bayern","web":"<a href='http://www.brauerei-greif.de' target=\"_blank\">www.brauerei-greif.de\u003c/a>","founded":1848,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.059662,49.72581]}},{"type":"Feature","properties":{"brewery":"Brauerei Hebendanz GmbH","address":"Sattlertorstrasse 14","zipcode":91301,"village":"Forchheim","state":"Bayern","web":"<a href='http://www.brauerei-hebendanz.de' target=\"_blank\">www.brauerei-hebendanz.de\u003c/a>","founded":1579,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.056749,49.7202]}},{"type":"Feature","properties":{"brewery":"Brauerei Friedmann","address":"Jaegersberg 16","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.brauerei-friedmann.de' target=\"_blank\">www.brauerei-friedmann.de\u003c/a>","founded":1875,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.252699,49.644533]}},{"type":"Feature","properties":{"brewery":"Lindenbraeu","address":"Am Bach 3","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.lindenbraeu.de' target=\"_blank\">www.lindenbraeu.de\u003c/a>","founded":1932,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.248618,49.645651]}},{"type":"Feature","properties":{"brewery":"Brauerei Windsheimer GmbH","address":"Hauptstrasse 13","zipcode":91468,"village":"Gutenstetten","state":"Bayern","web":"<a href='http://www.brauerei-windsheimer.de' target=\"_blank\">www.brauerei-windsheimer.de\u003c/a>","founded":1767,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[10.630027,49.615866]}},{"type":"Feature","properties":{"brewery":"Buergerbraeu Hersbruck, Deinlein & Co.","address":"Lohweg 38","zipcode":91217,"village":"Hersbruck","state":"Bayern","web":"<a href='http://www.hersbrucker-bier.de' target=\"_blank\">www.hersbrucker-bier.de\u003c/a>","founded":1920,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.428338,49.50683]}},{"type":"Feature","properties":{"brewery":"Hochholzer Brauhaus Poeverlein GbR","address":"Hochholz 4a","zipcode":91807,"village":"Solnhofen","state":"Bayern","web":"<a href='http://www.hochholzer-brauhaus.de' target=\"_blank\">www.hochholzer-brauhaus.de\u003c/a>","founded":2005,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.029479,48.900742]}},{"type":"Feature","properties":{"brewery":"Brauhaus Hoechstadt","address":"Kellerstrasse 11","zipcode":91315,"village":"Hoechstadt","state":"Bayern","web":"<a href='http://www.brauhaus-hoechstadt.de' target=\"_blank\">www.brauhaus-hoechstadt.de\u003c/a>","founded":1926,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[10.806113,49.707329]}},{"type":"Feature","properties":{"brewery":"Brauerei und Gasthof Reichold GmbH","address":"Hochstahl 24","zipcode":91347,"village":"Aufsess","state":"Bayern","web":"<a href='http://www.brauerei-reichold.de' target=\"_blank\">www.brauerei-reichold.de\u003c/a>","founded":1906,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.267583,49.884229]}},{"type":"Feature","properties":{"brewery":"Brauerei Hofmann/Nentwig GbR","address":"Hohenschwaerz 16","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.brauerei-hofmann.de' target=\"_blank\">www.brauerei-hofmann.de\u003c/a>","founded":1897,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.252911,49.677827]}},{"type":"Feature","properties":{"brewery":"Leinburger Bier","address":"Marktplatz 14","zipcode":91227,"village":"Leinburg","state":"Bayern","web":"<a href='http://www.leinburgerbier.de' target=\"_blank\">www.leinburgerbier.de\u003c/a>","founded":1617,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.308721,49.450083]}},{"type":"Feature","properties":{"brewery":"Brauerei Gasthof Drummer","address":"Dorfstrasse 10","zipcode":91359,"village":"Lautenbach","state":"Bayern","web":"<a href='http://www.brauerei-gasthof-drummer.de' target=\"_blank\">www.brauerei-gasthof-drummer.de\u003c/a>","founded":1738,"category":"Schwer"},"geometry":{"type":"Point","coordinates":[11.172792,49.710838]}},{"type":"Feature","properties":{"brewery":"Hauff Braeu Lichtnerau GmbH & Co. KG","address":"Marktplatz 1","zipcode":91586,"village":"Lichtenau","state":"Bayern","web":"<a href='http://www.hauff-braeu.com' target=\"_blank\">www.hauff-braeu.com\u003c/a>","founded":null,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[10.685605,49.276265]}},{"type":"Feature","properties":{"brewery":"Brauerei Wiethaler","address":"Welserplatz 6-7","zipcode":91207,"village":"Neunhof bei Lauf a.d. Pegnitz","state":"Bayern","web":"<a href='http://www.brauerei-wiethaler.de' target=\"_blank\">www.brauerei-wiethaler.de\u003c/a>","founded":1498,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.22997,49.554706]}},{"type":"Feature","properties":{"brewery":"Brauerei Gasthof Ott","address":"Oberleinleiter 6","zipcode":91332,"village":"Heiligenstadt i. Ofr.","state":"Bayern","web":"<a href='http://www.brauerei-ott.de' target=\"_blank\">www.brauerei-ott.de\u003c/a>","founded":1678,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.129541,49.882777]}},{"type":"Feature","properties":{"brewery":"Brauerei Penning-Zeissler","address":"Hetzelsdorf 9","zipcode":91362,"village":"Pretzfeld","state":"Bayern","web":null,"founded":1623,"category":"kein Schaden"},"geometry":{"type":"Point","coordinates":[11.202701,49.727998]}},{"type":"Feature","properties":{"brewery":"Brauerei Meister","address":"Unterzaunsbach 8","zipcode":91362,"village":"Pretzfeld","state":"Bayern","web":"<a href='http://www.xn--meisterbru-y5a.de/mod/main.php' target=\"_blank\">www.meisterbr%C3%A4u.de\u003c/a>","founded":1865,"category":"Mäßig"},"geometry":{"type":"Point","coordinates":[11.223148,49.737703]}},{"type":"Feature","properties":{"brewery":"Brauerei Nikl","address":"Egloffsteiner Strasse 19","zipcode":91363,"village":"Pretzfeld","state":"Bayern","web":"<a href='http://www.brauerei-nikl.de/' target=\"_blank\">www.brauerei-nikl.de\u003c/a>","founded":2008,"category":"Leicht"},"geometry":{"type":"Point","coordinates":[11.175664,49.755953]}}]},null,"clustermarkers","bar",{"rmax":30,"size":[20,20],"width":40,"height":50,"strokeWidth":1,"innerRadius":10,"labelBackground":false,"labelFill":"white","labelStroke":"black","labelColor":"black","labelOpacity":0.9,"digits":2,"sortTitlebyCount":true,"aggregation":"sum"},null,null,null,null,"brewery",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null,"category",{"1":"Schwer","2":"Mäßig","3":"Leicht","4":"kein Schaden"},["brewery","address","zipcode","category"],["Brauerei","Adresse","PLZ","Art"],null,{"title":"","position":"topright"}]}],"limits":{"lat":[48.900742,49.884229],"lng":[10.316987,11.509409]}},"evals":[],"jsHooks":[]}
## Custom Pie Chart with "mean" aggregation on column "value"
data <- sf::st_as_sf(breweries91)
categories <- c("Schwer", "Mäßig", "Leicht", "kein Schaden")
data$category <- sample(categories, size = nrow(data), replace = TRUE)
data$value <- round(runif(nrow(data), 0, 100), 0)

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
  addClusterCharts(
    data = data,
    type = "custom",
    valueField = "value",
    aggregation = "mean",
    categoryField = "category",
    categoryMap = data.frame(
      labels = categories,
      colors = c("#F88", "#FA0", "#FF3", "#BFB"),
      strokes = "gray"
    ),
    options = clusterchartOptions(rmax = 50, digits = 0, innerRadius = 20),
    group = "clustermarkers",
    popupFields = c("brewery", "address", "zipcode", "category", "value"),
    popupLabels = c("Brauerei", "Adresse", "PLZ", "Art", "Value"),
    label = "brewery"
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addLayersControl","args":[[],"clustermarkers",{"collapsed":true,"autoZIndex":true,"position":"topright"}]},{"method":"addClusterCharts","args":[{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"brewery":"Brauerei Rittmayer","address":"Aischer Hauptstrasse 5","zipcode":91325,"village":"Adelsdorf","state":"Bayern","web":"<a href='http://www.rittmayer-aisch.de' target=\"_blank\">www.rittmayer-aisch.de\u003c/a>","founded":1422,"category":"kein Schaden","value":31.0},"geometry":{"type":"Point","coordinates":[10.889217,49.71979]}},{"type":"Feature","properties":{"brewery":"Aufsesser Brauerei","address":"Im Tal 70b","zipcode":91347,"village":"Aufsess","state":"Bayern","web":"<a href='http://www.aufsesser.de' target=\"_blank\">www.aufsesser.de\u003c/a>","founded":1886,"category":"Leicht","value":87.0},"geometry":{"type":"Point","coordinates":[11.228988,49.884051]}},{"type":"Feature","properties":{"brewery":"Brauhaus Doebler","address":"Kornmarkt 6","zipcode":91438,"village":"Bad Windsheim","state":"Bayern","web":"<a href='http://www.brauhaus-doebler.de' target=\"_blank\">www.brauhaus-doebler.de\u003c/a>","founded":1867,"category":"Leicht","value":72.0},"geometry":{"type":"Point","coordinates":[10.416021,49.502098]}},{"type":"Feature","properties":{"brewery":"Brauerei Gundel GmbH","address":"Noerdlinger Strasse 15","zipcode":91126,"village":"Barthelmesaurach","state":"Bayern","web":"<a href='http://www.brauerei-gundel.de' target=\"_blank\">www.brauerei-gundel.de\u003c/a>","founded":1887,"category":"Mäßig","value":41.0},"geometry":{"type":"Point","coordinates":[10.928096,49.274716]}},{"type":"Feature","properties":{"brewery":"Krug-Braeu","address":"Breitenlesau 1b","zipcode":91344,"village":"Waischenfeld","state":"Bayern","web":"<a href='http://www.krug-braeu.de' target=\"_blank\">www.krug-braeu.de\u003c/a>","founded":1834,"category":"Mäßig","value":2.0},"geometry":{"type":"Point","coordinates":[11.291932,49.861905]}},{"type":"Feature","properties":{"brewery":"Brauerei-Gasthof Herold","address":"Marktstrasse 29","zipcode":91257,"village":"Buechenbach","state":"Bayern","web":"<a href='http://www.beckn-bier.de' target=\"_blank\">www.beckn-bier.de\u003c/a>","founded":1568,"category":"Leicht","value":5.0},"geometry":{"type":"Point","coordinates":[11.509409,49.794334]}},{"type":"Feature","properties":{"brewery":"Brauerei Alt Dietzhof","address":"Dietzhof 42","zipcode":91359,"village":"Leutenbach","state":"Bayern","web":"<a href='http://www.brauerei-alt.de' target=\"_blank\">www.brauerei-alt.de\u003c/a>","founded":1886,"category":"Mäßig","value":70.0},"geometry":{"type":"Point","coordinates":[11.163238,49.701477]}},{"type":"Feature","properties":{"brewery":"Brauerei Hauf KG","address":"Heiningerstrasse 28","zipcode":91550,"village":"Dinkelsbuehl","state":"Bayern","web":"<a href='http://www.hauf-bier.de' target=\"_blank\">www.hauf-bier.de\u003c/a>","founded":1901,"category":"kein Schaden","value":7.0},"geometry":{"type":"Point","coordinates":[10.34418,49.067436]}},{"type":"Feature","properties":{"brewery":"Weib's Brauhaus Dinkelsbuehl","address":"Untere Schmiedgasse 13","zipcode":91550,"village":"Dinkelsbuehl","state":"Bayern","web":"<a href='http://www.weibsbrauhaus.de' target=\"_blank\">www.weibsbrauhaus.de\u003c/a>","founded":1999,"category":"Leicht","value":4.0},"geometry":{"type":"Point","coordinates":[10.316987,49.070292]}},{"type":"Feature","properties":{"brewery":"Schwanenbraeu","address":"Am Marktplatz 2","zipcode":91320,"village":"Ebermannstadt","state":"Bayern","web":"<a href='http://www.schwanenbraeu.de' target=\"_blank\">www.schwanenbraeu.de\u003c/a>","founded":null,"category":"Mäßig","value":2.0},"geometry":{"type":"Point","coordinates":[11.186931,49.77994]}},{"type":"Feature","properties":{"brewery":"Fuerst Carl Schlossbrauerei Ellingen","address":"Schloss-Strasse 10","zipcode":91792,"village":"Ellingen","state":"Bayern","web":"<a href='http://www.fuerst-carl.de' target=\"_blank\">www.fuerst-carl.de\u003c/a>","founded":1690,"category":"kein Schaden","value":37.0},"geometry":{"type":"Point","coordinates":[10.965571,49.060542]}},{"type":"Feature","properties":{"brewery":"Brauerei Enzensteiner","address":"Enzenreuth 8","zipcode":91220,"village":"Schnaittach","state":"Bayern","web":"<a href='http://www.enzensteiner.de' target=\"_blank\">www.enzensteiner.de\u003c/a>","founded":1998,"category":"Schwer","value":23.0},"geometry":{"type":"Point","coordinates":[11.368508,49.561804]}},{"type":"Feature","properties":{"brewery":"Kitzmann-Braeu GmbH & Co. Kg","address":"Suedliche Stadtmauerstrasse 25","zipcode":91054,"village":"Erlangen","state":"Bayern","web":"<a href='http://www.kitzmann.de' target=\"_blank\">www.kitzmann.de\u003c/a>","founded":1712,"category":"kein Schaden","value":49.0},"geometry":{"type":"Point","coordinates":[11.009011,49.595108]}},{"type":"Feature","properties":{"brewery":"Steinbach Braeu","address":"Vierzigmannstrasse 4","zipcode":91054,"village":"Erlangen","state":"Bayern","web":"<a href='http://www.steinbach-braeu.de' target=\"_blank\">www.steinbach-braeu.de\u003c/a>","founded":1861,"category":"kein Schaden","value":45.0},"geometry":{"type":"Point","coordinates":[11.005049,49.602554]}},{"type":"Feature","properties":{"brewery":"Brauerei Greif","address":"Serlbacher Strasse 10","zipcode":91301,"village":"Forchheim","state":"Bayern","web":"<a href='http://www.brauerei-greif.de' target=\"_blank\">www.brauerei-greif.de\u003c/a>","founded":1848,"category":"Mäßig","value":69.0},"geometry":{"type":"Point","coordinates":[11.059662,49.72581]}},{"type":"Feature","properties":{"brewery":"Brauerei Hebendanz GmbH","address":"Sattlertorstrasse 14","zipcode":91301,"village":"Forchheim","state":"Bayern","web":"<a href='http://www.brauerei-hebendanz.de' target=\"_blank\">www.brauerei-hebendanz.de\u003c/a>","founded":1579,"category":"Leicht","value":84.0},"geometry":{"type":"Point","coordinates":[11.056749,49.7202]}},{"type":"Feature","properties":{"brewery":"Brauerei Friedmann","address":"Jaegersberg 16","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.brauerei-friedmann.de' target=\"_blank\">www.brauerei-friedmann.de\u003c/a>","founded":1875,"category":"Mäßig","value":38.0},"geometry":{"type":"Point","coordinates":[11.252699,49.644533]}},{"type":"Feature","properties":{"brewery":"Lindenbraeu","address":"Am Bach 3","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.lindenbraeu.de' target=\"_blank\">www.lindenbraeu.de\u003c/a>","founded":1932,"category":"Leicht","value":98.0},"geometry":{"type":"Point","coordinates":[11.248618,49.645651]}},{"type":"Feature","properties":{"brewery":"Brauerei Windsheimer GmbH","address":"Hauptstrasse 13","zipcode":91468,"village":"Gutenstetten","state":"Bayern","web":"<a href='http://www.brauerei-windsheimer.de' target=\"_blank\">www.brauerei-windsheimer.de\u003c/a>","founded":1767,"category":"kein Schaden","value":95.0},"geometry":{"type":"Point","coordinates":[10.630027,49.615866]}},{"type":"Feature","properties":{"brewery":"Buergerbraeu Hersbruck, Deinlein & Co.","address":"Lohweg 38","zipcode":91217,"village":"Hersbruck","state":"Bayern","web":"<a href='http://www.hersbrucker-bier.de' target=\"_blank\">www.hersbrucker-bier.de\u003c/a>","founded":1920,"category":"Leicht","value":99.0},"geometry":{"type":"Point","coordinates":[11.428338,49.50683]}},{"type":"Feature","properties":{"brewery":"Hochholzer Brauhaus Poeverlein GbR","address":"Hochholz 4a","zipcode":91807,"village":"Solnhofen","state":"Bayern","web":"<a href='http://www.hochholzer-brauhaus.de' target=\"_blank\">www.hochholzer-brauhaus.de\u003c/a>","founded":2005,"category":"Leicht","value":44.0},"geometry":{"type":"Point","coordinates":[11.029479,48.900742]}},{"type":"Feature","properties":{"brewery":"Brauhaus Hoechstadt","address":"Kellerstrasse 11","zipcode":91315,"village":"Hoechstadt","state":"Bayern","web":"<a href='http://www.brauhaus-hoechstadt.de' target=\"_blank\">www.brauhaus-hoechstadt.de\u003c/a>","founded":1926,"category":"kein Schaden","value":15.0},"geometry":{"type":"Point","coordinates":[10.806113,49.707329]}},{"type":"Feature","properties":{"brewery":"Brauerei und Gasthof Reichold GmbH","address":"Hochstahl 24","zipcode":91347,"village":"Aufsess","state":"Bayern","web":"<a href='http://www.brauerei-reichold.de' target=\"_blank\">www.brauerei-reichold.de\u003c/a>","founded":1906,"category":"kein Schaden","value":94.0},"geometry":{"type":"Point","coordinates":[11.267583,49.884229]}},{"type":"Feature","properties":{"brewery":"Brauerei Hofmann/Nentwig GbR","address":"Hohenschwaerz 16","zipcode":91322,"village":"Graefenberg","state":"Bayern","web":"<a href='http://www.brauerei-hofmann.de' target=\"_blank\">www.brauerei-hofmann.de\u003c/a>","founded":1897,"category":"kein Schaden","value":52.0},"geometry":{"type":"Point","coordinates":[11.252911,49.677827]}},{"type":"Feature","properties":{"brewery":"Leinburger Bier","address":"Marktplatz 14","zipcode":91227,"village":"Leinburg","state":"Bayern","web":"<a href='http://www.leinburgerbier.de' target=\"_blank\">www.leinburgerbier.de\u003c/a>","founded":1617,"category":"Leicht","value":46.0},"geometry":{"type":"Point","coordinates":[11.308721,49.450083]}},{"type":"Feature","properties":{"brewery":"Brauerei Gasthof Drummer","address":"Dorfstrasse 10","zipcode":91359,"village":"Lautenbach","state":"Bayern","web":"<a href='http://www.brauerei-gasthof-drummer.de' target=\"_blank\">www.brauerei-gasthof-drummer.de\u003c/a>","founded":1738,"category":"Schwer","value":22.0},"geometry":{"type":"Point","coordinates":[11.172792,49.710838]}},{"type":"Feature","properties":{"brewery":"Hauff Braeu Lichtnerau GmbH & Co. KG","address":"Marktplatz 1","zipcode":91586,"village":"Lichtenau","state":"Bayern","web":"<a href='http://www.hauff-braeu.com' target=\"_blank\">www.hauff-braeu.com\u003c/a>","founded":null,"category":"Schwer","value":14.0},"geometry":{"type":"Point","coordinates":[10.685605,49.276265]}},{"type":"Feature","properties":{"brewery":"Brauerei Wiethaler","address":"Welserplatz 6-7","zipcode":91207,"village":"Neunhof bei Lauf a.d. Pegnitz","state":"Bayern","web":"<a href='http://www.brauerei-wiethaler.de' target=\"_blank\">www.brauerei-wiethaler.de\u003c/a>","founded":1498,"category":"Mäßig","value":22.0},"geometry":{"type":"Point","coordinates":[11.22997,49.554706]}},{"type":"Feature","properties":{"brewery":"Brauerei Gasthof Ott","address":"Oberleinleiter 6","zipcode":91332,"village":"Heiligenstadt i. Ofr.","state":"Bayern","web":"<a href='http://www.brauerei-ott.de' target=\"_blank\">www.brauerei-ott.de\u003c/a>","founded":1678,"category":"Leicht","value":41.0},"geometry":{"type":"Point","coordinates":[11.129541,49.882777]}},{"type":"Feature","properties":{"brewery":"Brauerei Penning-Zeissler","address":"Hetzelsdorf 9","zipcode":91362,"village":"Pretzfeld","state":"Bayern","web":null,"founded":1623,"category":"Mäßig","value":23.0},"geometry":{"type":"Point","coordinates":[11.202701,49.727998]}},{"type":"Feature","properties":{"brewery":"Brauerei Meister","address":"Unterzaunsbach 8","zipcode":91362,"village":"Pretzfeld","state":"Bayern","web":"<a href='http://www.xn--meisterbru-y5a.de/mod/main.php' target=\"_blank\">www.meisterbr%C3%A4u.de\u003c/a>","founded":1865,"category":"Schwer","value":3.0},"geometry":{"type":"Point","coordinates":[11.223148,49.737703]}},{"type":"Feature","properties":{"brewery":"Brauerei Nikl","address":"Egloffsteiner Strasse 19","zipcode":91363,"village":"Pretzfeld","state":"Bayern","web":"<a href='http://www.brauerei-nikl.de/' target=\"_blank\">www.brauerei-nikl.de\u003c/a>","founded":2008,"category":"Schwer","value":75.0},"geometry":{"type":"Point","coordinates":[11.175664,49.755953]}}]},null,"clustermarkers","custom",{"rmax":50,"size":[20,20],"width":40,"height":50,"strokeWidth":1,"innerRadius":20,"labelBackground":false,"labelFill":"white","labelStroke":"black","labelColor":"black","labelOpacity":0.9,"digits":0,"sortTitlebyCount":true,"aggregation":"mean","valueField":"value"},null,null,null,null,"brewery",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null,"category",{"1":"Schwer","2":"Mäßig","3":"Leicht","4":"kein Schaden"},["brewery","address","zipcode","category","value"],["Brauerei","Adresse","PLZ","Art","Value"],null,{"title":"","position":"topright"}]}],"limits":{"lat":[48.900742,49.884229],"lng":[10.316987,11.509409]}},"evals":[],"jsHooks":[]}
## For Shiny examples, please run:
# runApp(system.file("examples/clusterCharts_app.R", package = "leaflet.extras2"))
# runApp(system.file("examples/clustercharts_sum.R", package = "leaflet.extras2"))
```
