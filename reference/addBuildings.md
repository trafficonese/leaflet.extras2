# Add OSM-Buildings to a Leaflet Map

This function adds 2.5D buildings to a Leaflet map using the OSM
Buildings plugin.

## Usage

``` r
addBuildings(
  map,
  buildingURL = "https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json",
  group = NULL,
  eachFn = NULL,
  clickFn = NULL,
  data = NULL
)
```

## Arguments

- map:

  A map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html).

- buildingURL:

  The URL template for the building data. Default is the OSM Buildings
  tile server:  
  `"https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json"`.

- group:

  The name of the group the buildings will be added to.

- eachFn:

  A JavaScript function (using
  [`JS`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)) that will be
  called for each building feature. Use this to apply custom logic to
  each feature.

- clickFn:

  A JavaScript function (using
  [`JS`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)) that will be
  called when a building is clicked. Use this to handle click events on
  buildings.

- data:

  A GeoJSON object containing Polygon features representing the
  buildings. The properties of these polygons can include attributes
  like `height`, `color`, `roofColor`, and others as specified in the
  OSM Buildings documentation.

## Details

The \`data\` parameter allows you to provide custom building data as a
GeoJSON object. The following properties can be used within the GeoJSON:

- **height**

- **minHeight**

- **color/wallColor**

- **material**

- **roofColor**

- **roofMaterial**

- **shape**

- **roofShape**

- **roofHeight**

See the OSM Wiki:
[Simple_3D_Buildings](https://wiki.openstreetmap.org/wiki/Simple_3D_Buildings)

## See also

<https://github.com/kekscom/osmbuildings/> for more details on the OSM
Buildings plugin and available properties.

Other OSM-Buildings Plugin:
[`setBuildingData()`](https://trafficonese.github.io/leaflet.extras2/reference/setBuildingData.md),
[`setBuildingStyle()`](https://trafficonese.github.io/leaflet.extras2/reference/setBuildingStyle.md),
[`updateBuildingTime()`](https://trafficonese.github.io/leaflet.extras2/reference/updateBuildingTime.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)

leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addBuildings(group = "Buildings") %>%
  addLayersControl(overlayGroups = "Buildings") %>%
  setView(lng = 13.4, lat = 52.51, zoom = 15)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["CartoDB",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addBuilding","args":["https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json","Buildings",null,null,null]},{"method":"addLayersControl","args":[[],"Buildings",{"collapsed":true,"autoZIndex":true,"position":"topright"}]}],"setView":[[52.51,13.4],15,[]]},"evals":[],"jsHooks":[]}
```
