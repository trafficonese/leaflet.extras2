# Add protobuf vector tiles

Loads remote Mapbox Vector Tiles (`.pbf` / `.mvt`) with
`L.vectorGrid.protobuf`. Style each vector-tile layer by name via
[`vectorStyling`](https://trafficonese.github.io/leaflet.extras2/reference/vectorStyling.md)
(OpenMapTiles / Mapbox / Nextzen names).

## Usage

``` r
addProtobuf(
  map,
  urlTemplate,
  attribution = NULL,
  layerId = NULL,
  group = NULL,
  key = NULL,
  interactive = TRUE,
  options = leaflet::tileOptions(),
  popup = NULL,
  label = NULL,
  styling = vectorStyling(),
  data = getMapData(map)
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- urlTemplate:

  Tile URL with `{z}`, `{x}`, `{y}`. Use `{key}` together with `key` for
  API tokens.

- attribution:

  the attribution text of the tile layer (HTML)

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

- key:

  Optional API key substituted into `{key}` in the URL.

- interactive:

  Whether the layer fires mouse events. Default `TRUE`.

- options:

  a list of extra options for tile layers, popups, paths (circles,
  rectangles, polygons, ...), or other map elements

- popup:

  Name of a feature property shown in a popup on click.

- label:

  Name of a feature property shown as a tooltip on hover.

- styling:

  Named list of path styles, one per vector-tile layer name. See
  [`vectorStyling`](https://trafficonese.github.io/leaflet.extras2/reference/vectorStyling.md).

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Value

the new `map` object

## Details

In Shiny a click updates `input$MAPID_vectorgrid_pbf_click`.

## References

<https://github.com/Leaflet/Leaflet.VectorGrid>

## See also

Other Vectorgrid Functions:
[`addVectorgrid()`](https://trafficonese.github.io/leaflet.extras2/reference/addVectorgrid.md),
[`clearVectorgrid()`](https://trafficonese.github.io/leaflet.extras2/reference/clearVectorgrid.md),
[`removeVectorgrid()`](https://trafficonese.github.io/leaflet.extras2/reference/removeVectorgrid.md),
[`vectorStyling()`](https://trafficonese.github.io/leaflet.extras2/reference/vectorStyling.md)

## Examples

``` r
if (FALSE) { # \dontrun{
leaflet() %>%
  addTiles() %>%
  addProtobuf(
    urlTemplate = "https://vector.openstreetmap.org/shortbread_v1/{z}/{x}/{y}.mvt",
    layerId = "osm",
    attribution = "OpenStreetMap"
  )
} # }
```
