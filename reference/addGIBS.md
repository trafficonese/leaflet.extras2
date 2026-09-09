# Add GIBS Layers

A leaflet plugin for NASA EOSDIS GIBS imagery integration. 154 products
are available. The date can be set dynamically for multi-temporal
products. No-data pixels of MODIS Multiband Imagery can be made
transparent.

## Usage

``` r
addGIBS(
  map,
  layers = NULL,
  group = NULL,
  dates = NULL,
  opacity = 0.5,
  transparent = TRUE
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- layers:

  A character vector of GIBS-layers. See
  [`gibs_layers`](https://trafficonese.github.io/leaflet.extras2/reference/gibs_layers.md)

- group:

  the name of the group the newly created layers should belong to (for
  [`clearGroup()`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl()`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g., markers and polygons) can share the same group
  name.

- dates:

  Date object. If multiple `layers` are added, you can add a Date vector
  of the same length

- opacity:

  Numeric value determining the opacity. If multiple `layers` are added,
  you can add a numeric vector of the same length

- transparent:

  Should the layer be transparent. If multiple `layers` are added, you
  can add a boolean vector of the same length

## Value

the new `map` object

## References

<https://github.com/aparshin/leaflet-GIBS>

## See also

Other GIBS Functions:
[`setDate()`](https://trafficonese.github.io/leaflet.extras2/reference/setDate.md),
[`setTransparent()`](https://trafficonese.github.io/leaflet.extras2/reference/setTransparent.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

layers <- gibs_layers$title[c(35, 128, 185)]

leaflet() %>%
  addTiles() %>%
  setView(9, 50, 4) %>%
  addGIBS(
    layers = layers,
    dates = Sys.Date() - 1,
    group = layers
  ) %>%
  addLayersControl(overlayGroups = layers)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addGIBS","args":[["AIRS_Precipitation_Day","MODIS_Terra_Chlorophyll_A","MODIS_Aqua_AOD_Deep_Blue_Combined"],["AIRS_Precipitation_Day","MODIS_Terra_Chlorophyll_A","MODIS_Aqua_AOD_Deep_Blue_Combined"],["2026-09-08","2026-09-08","2026-09-08"],[0.5,0.5,0.5],[true,true,true]]},{"method":"addLayersControl","args":[[],["AIRS_Precipitation_Day","MODIS_Terra_Chlorophyll_A","MODIS_Aqua_AOD_Deep_Blue_Combined"],{"collapsed":true,"autoZIndex":true,"position":"topright"}]}],"setView":[[50,9],4,[]]},"evals":[],"jsHooks":[]}
```
