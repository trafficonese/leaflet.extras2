# Add contextmenu Plugin

Add a contextmenu to the map or markers/vector layers.

## Usage

``` r
addContextmenu(map)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html)

## Value

A leaflet map object

## Details

This function is only used to include the required JavaScript and CSS
bindings and to set up some Shiny event handlers.

### Contextmenu initialization

The contextmenu for

- the **map** must be defined in
  [`leafletOptions`](https://rstudio.github.io/leaflet/reference/leaflet.html).

- the **markers/vector layers** must be defined in
  [`markerOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
  or
  [`pathOptions`](https://rstudio.github.io/leaflet/reference/map-options.html).

### Contextmenu selection

When a contextmenu is selected, a Shiny input with the ID
`"MAPID_contextmenu_select"` is set (\`MAPID\` refers to the map's id).

If the selected contextmenu item is triggered from:

- the **map**, the returned list contains the `text` of the item.

- the **markers**, the returned list also contains the `layerId`,
  `group`, `lat`, `lng` and `label`.

- the **vector layers**, the returned list also contains the `layerId`,
  `group` and `label`.

## References

<https://github.com/aratcliffe/Leaflet.contextmenu>

## See also

Other Contextmenu Functions:
[`addItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/addItemContextmenu.md),
[`context_mapmenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/context_mapmenuItems.md),
[`context_markermenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/context_markermenuItems.md),
[`context_menuItem()`](https://trafficonese.github.io/leaflet.extras2/reference/context_menuItem.md),
[`disableContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/disableContextmenu.md),
[`enableContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/enableContextmenu.md),
[`hideContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/hideContextmenu.md),
[`insertItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/insertItemContextmenu.md),
[`mapmenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/mapmenuItems.md),
[`markermenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/markermenuItems.md),
[`menuItem()`](https://trafficonese.github.io/leaflet.extras2/reference/menuItem.md),
[`removeItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/removeItemContextmenu.md),
[`removeallItemsContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/removeallItemsContextmenu.md),
[`setDisabledContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/setDisabledContextmenu.md),
[`showContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/showContextmenu.md)

## Examples

``` r
library(leaflet)
leaflet(options = leafletOptions(
  contextmenu = TRUE,
  contextmenuWidth = 200,
  contextmenuItems =
    context_mapmenuItems(
      context_menuItem("Zoom Out", "function(e) {this.zoomOut()}", disabled = FALSE),
      "-",
      context_menuItem("Zoom In", "function(e) {this.zoomIn()}")
    )
)) %>%
  addTiles(group = "base") %>%
  addContextmenu() %>%
  addMarkers(
    data = breweries91, label = ~brewery,
    layerId = ~founded, group = "marker",
    options = markerOptions(
      contextmenu = TRUE,
      contextmenuWidth = 200,
      contextmenuItems =
        context_markermenuItems(
          context_menuItem(
            text = "Show Marker Coords",
            callback = "function(e) {alert(e.latlng);}",
            index = 1
          )
        )
    )
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"contextmenu":true,"contextmenuWidth":200,"contextmenuItems":[{"text":"Zoom Out","callback":"function(e) {this.zoomOut()}","disabled":false},"-",{"text":"Zoom In","callback":"function(e) {this.zoomIn()}"}]},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,"base",{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addContextmenu","args":[]},{"method":"addMarkers","args":[[49.71979,49.884051,49.502098,49.274716,49.861905,49.794334,49.701477,49.067436,49.070292,49.77994,49.060542,49.561804,49.595108,49.602554,49.72581,49.7202,49.644533,49.645651,49.615866,49.50683,48.900742,49.707329,49.884229,49.677827,49.450083,49.710838,49.276265,49.554706,49.882777,49.727998,49.737703,49.755953],[10.889217,11.228988,10.416021,10.928096,11.291932,11.509409,11.163238,10.34418,10.316987,11.186931,10.965571,11.368508,11.009011,11.005049,11.059662,11.056749,11.252699,11.248618,10.630027,11.428338,11.029479,10.806113,11.267583,11.252911,11.308721,11.172792,10.685605,11.22997,11.129541,11.202701,11.223148,11.175664],null,[1422,1886,1867,1887,1834,1568,1886,1901,1999,null,1690,1998,1712,1861,1848,1579,1875,1932,1767,1920,2005,1926,1906,1897,1617,1738,null,1498,1678,1623,1865,2008],"marker",{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250,"contextmenu":true,"contextmenuWidth":200,"contextmenuItems":[[{"text":"Show Marker Coords","callback":"function(e) {alert(e.latlng);}","index":1}]]},null,null,null,null,["Brauerei Rittmayer","Aufsesser Brauerei","Brauhaus Doebler","Brauerei Gundel GmbH","Krug-Braeu","Brauerei-Gasthof Herold","Brauerei Alt Dietzhof","Brauerei Hauf KG","Weib's Brauhaus Dinkelsbuehl","Schwanenbraeu","Fuerst Carl Schlossbrauerei Ellingen","Brauerei Enzensteiner","Kitzmann-Braeu GmbH &amp; Co. Kg","Steinbach Braeu","Brauerei Greif","Brauerei Hebendanz GmbH","Brauerei Friedmann","Lindenbraeu","Brauerei Windsheimer GmbH","Buergerbraeu Hersbruck, Deinlein &amp; Co.","Hochholzer Brauhaus Poeverlein GbR","Brauhaus Hoechstadt","Brauerei und Gasthof Reichold GmbH","Brauerei Hofmann/Nentwig GbR","Leinburger Bier","Brauerei Gasthof Drummer","Hauff Braeu Lichtnerau GmbH &amp; Co. KG","Brauerei Wiethaler","Brauerei Gasthof Ott","Brauerei Penning-Zeissler","Brauerei Meister","Brauerei Nikl"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[48.900742,49.884229],"lng":[10.316987,11.509409]}},"evals":["options.contextmenuItems.0.callback","options.contextmenuItems.2.callback","calls.2.args.5.contextmenuItems.0.0.callback"],"jsHooks":[]}
```
