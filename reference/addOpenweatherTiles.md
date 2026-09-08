# Add OpenWeatherMap Tiles

Add OpenWeatherMap Tiles

## Usage

``` r
addOpenweatherTiles(
  map,
  apikey = NULL,
  layers = NULL,
  group = NULL,
  layerId = NULL,
  opacity = 0.5,
  options = openweatherOptions()
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- apikey:

  a valid OpenWeatherMap-API key.

- layers:

  character vector of layers you wish to add to the map. The following
  layers are currently possible
  `c("clouds", "cloudsClassic", "precipitation", "precipitationClassic", "rain", "rainClassic", "snow", "pressure", "pressureContour", "temperature", "wind")`.

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

- opacity:

  opacity of the layer

- options:

  List of further options. See
  [`openweatherOptions`](https://trafficonese.github.io/leaflet.extras2/reference/openweatherOptions.md)

## Value

the new `map` object

## Note

Out of the box a legend image is only available for Pressure,
Precipitation Classic, Clouds Classic, Rain Classic, Snow, Temperature
and Wind Speed. Please add your own images if you need some more.

## References

<https://github.com/trafficonese/leaflet-openweathermap>

## See also

Other Openweathermap Functions:
[`addOpenweatherCurrent()`](https://trafficonese.github.io/leaflet.extras2/reference/addOpenweatherCurrent.md),
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
  setView(9, 50, 6) %>%
  addOpenweatherTiles(layers = "wind")
} # }
```
