# Add Velocity Animation

Add velocity animated data to leaflet. Based on the [leaflet-velocity
plugin](https://github.com/onaci/leaflet-velocity)

## Usage

``` r
addVelocity(
  map,
  layerId = NULL,
  group = NULL,
  content = NULL,
  options = velocityOptions()
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
  [`clearGroup`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g. markers and polygons) can share the same group
  name.

- content:

  the path or URL to a JSON file representing the velocity data or a
  data.frame which can be transformed to such a JSON file. Please see
  the [demo
  files](https://github.com/onaci/leaflet-velocity/tree/master/demo) for
  some example data.

- options:

  List of further options. See
  [`velocityOptions`](https://trafficonese.github.io/leaflet.extras2/reference/velocityOptions.md)

## Value

the new `map` object

## References

<https://github.com/onaci/leaflet-velocity>

## See also

Other Velocity Functions:
[`removeVelocity()`](https://trafficonese.github.io/leaflet.extras2/reference/removeVelocity.md),
[`setOptionsVelocity()`](https://trafficonese.github.io/leaflet.extras2/reference/setOptionsVelocity.md),
[`velocityOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/velocityOptions.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(leaflet)
library(leaflet.extras2)
content <- "https://raw.githubusercontent.com/onaci/leaflet-velocity/master/demo/water-gbr.json"
leaflet() %>%
  addTiles(group = "base") %>%
  setView(145, -20, 4) %>%
  addVelocity(content = content, group = "velo", layerId = "veloid") %>%
  addLayersControl(baseGroups = "base", overlayGroups = "velo")
} # }
```
