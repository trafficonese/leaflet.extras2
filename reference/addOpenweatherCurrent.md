# Add current OpenWeatherMap Marker

Add current OpenWeatherMap Marker

## Usage

``` r
addOpenweatherCurrent(
  map,
  apikey = NULL,
  group = NULL,
  layerId = NULL,
  options = openweatherCurrentOptions()
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- apikey:

  a valid Openweathermap-API key.

- group:

  the name of the group the newly created layers should belong to (for
  [`clearGroup`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g. markers and polygons) can share the same group
  name.

- layerId:

  the layer id

- options:

  List of further options. See
  [`openweatherCurrentOptions`](https://trafficonese.github.io/leaflet.extras2/reference/openweatherCurrentOptions.md)

## Value

the new `map` object

## Note

The current weather icons will appear beginning with zoom level 9 and if
used in Shiny, a click on an icon will update a Shiny input at
`input$MAPID_owm_click`.

## References

<https://github.com/trafficonese/leaflet-openweathermap>

## See also

Other Openweathermap Functions:
[`addOpenweatherTiles()`](https://trafficonese.github.io/leaflet.extras2/reference/addOpenweatherTiles.md),
[`openweatherCurrentOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/openweatherCurrentOptions.md),
[`openweatherOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/openweatherOptions.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(leaflet)
library(leaflet.extras2)

Sys.setenv("OPENWEATHERMAP" = "Your_API_Key")

leaflet() %>%
  addTiles() %>%
  setView(9, 50, 9) %>%
  addOpenweatherCurrent(options = openweatherCurrentOptions(
    lang = "en", popup = TRUE
  ))
} # }
```
