# Add easyPrint Plugin

Add a control, which allows to print or export a map as .PNG.

## Usage

``` r
addEasyprint(map, options = easyprintOptions())
```

## Arguments

- map:

  a map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- options:

  A named list of options. See
  [`easyprintOptions`](https://trafficonese.github.io/leaflet.extras2/reference/easyprintOptions.md)

## Value

A leaflet map object

## References

<https://github.com/rowanwins/leaflet-easyPrint>

## See also

Other EasyPrint Functions:
[`easyprintMap()`](https://trafficonese.github.io/leaflet.extras2/reference/easyprintMap.md),
[`easyprintOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/easyprintOptions.md),
[`removeEasyprint()`](https://trafficonese.github.io/leaflet.extras2/reference/removeEasyprint.md)

## Examples

``` r
library(leaflet)
leaflet() %>%
  addTiles() %>%
  addEasyprint(options = easyprintOptions(
    title = "Print map",
    position = "bottomleft",
    exportOnly = TRUE
  ))

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addEasyprint","args":[{"title":"Print map","position":"bottomleft","sizeModes":["A4Portrait","A4Landscape","CurrentSize"],"exportOnly":true,"tileWait":500,"filename":"map","hidden":false,"hideControlContainer":true,"spinnerBgColor":"#0DC5C1","customSpinnerClass":"epLoader"}]}]},"evals":[],"jsHooks":[]}
## Custom pixel size (e.g. high-res PNG in a Quarto/HTML document):
leaflet() %>%
  addTiles() %>%
  addEasyprint(options = easyprintOptions(
    title = "Save map to PNG",
    exportOnly = TRUE,
    filename = "map",
    tileWait = 1000,
    sizeModes = list(
      "CurrentSize",
      list(scale = 3, name = "3x current view")
    )
  ))

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addEasyprint","args":[{"title":"Save map to PNG","position":"topleft","sizeModes":["CurrentSize",{"scale":3,"name":"3x current view","className":"custom-scale-3","keepView":true}],"exportOnly":true,"tileWait":1000,"filename":"map","hidden":false,"hideControlContainer":true,"spinnerBgColor":"#0DC5C1","customSpinnerClass":"epLoader"}]}]},"evals":[],"jsHooks":[]}
```
