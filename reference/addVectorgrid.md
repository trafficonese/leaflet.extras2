# Add sliced GeoJSON / TopoJSON as a VectorGrid

Displays large polygon/line datasets as tiled vector features using
[Leaflet.VectorGrid](https://github.com/Leaflet/Leaflet.VectorGrid)
(`L.vectorGrid.slicer`). This is more efficient than
[`addPolygons`](https://rstudio.github.io/leaflet/reference/map-layers.html)
for big GeoJSON.

## Usage

``` r
addVectorgrid(
  map,
  data,
  layerId = NULL,
  group = NULL,
  featureId = NULL,
  popup = NULL,
  stroke = TRUE,
  color = "#03F",
  weight = 5,
  opacity = 0.5,
  fill = TRUE,
  fillColor = color,
  fillOpacity = 0.2,
  dashArray = NULL,
  options = pathOptions(),
  interactive = TRUE
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- data:

  An `sf` / `Spatial` object, a GeoJSON object, or a URL returning
  GeoJSON / TopoJSON.

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

- featureId:

  Formula or vector of unique feature ids (used for highlight and the
  Shiny click `id`). A formula passed as `layerId` is treated as
  `featureId`.

- popup:

  Formula, column name or character vector with HTML for the click
  popup.

- stroke:

  whether to draw stroke along the path (e.g., the borders of polygons
  or circles)

- color:

  stroke color

- weight:

  stroke width in pixels

- opacity:

  stroke opacity (or layer opacity for tile layers)

- fill:

  whether to fill the path with color (e.g., filling on polygons or
  circles)

- fillColor:

  fill color

- fillOpacity:

  fill opacity

- dashArray:

  a string that defines the stroke [dash
  pattern](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-dasharray)

- options:

  a list of extra options for tile layers, popups, paths (circles,
  rectangles, polygons, ...), or other map elements

- interactive:

  Whether the layer fires mouse events. Default `TRUE`.

## Value

the new `map` object

## Details

In Shiny a click updates `input$MAPID_vectorgrid_click` with `id`,
`group`, `lat`, `lng` and `properties`.

## References

<https://github.com/Leaflet/Leaflet.VectorGrid>

## See also

Other Vectorgrid Functions:
[`addProtobuf()`](https://trafficonese.github.io/leaflet.extras2/reference/addProtobuf.md),
[`clearVectorgrid()`](https://trafficonese.github.io/leaflet.extras2/reference/clearVectorgrid.md),
[`removeVectorgrid()`](https://trafficonese.github.io/leaflet.extras2/reference/removeVectorgrid.md),
[`vectorStyling()`](https://trafficonese.github.io/leaflet.extras2/reference/vectorStyling.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(leaflet)
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
leaflet() %>%
  addTiles() %>%
  addVectorgrid(
    data = nc,
    layerId = "nc",
    featureId = ~NAME,
    popup = ~NAME,
    color = "black",
    fillColor = "#4daf4a",
    weight = 1
  )
} # }
```
