# OpenWeatherMap Options

OpenWeatherMap Options

## Usage

``` r
openweatherOptions(
  showLegend = TRUE,
  legendImagePath = NULL,
  legendPosition = c("bottomleft", "bottomright", "topleft", "topright")
)
```

## Arguments

- showLegend:

  If `TRUE` and option `legendImagePath` is set there will be a legend
  image on the map

- legendImagePath:

  A URL (is set to a default image for some layers, null for others, see
  below). URL or relative path to an image which is a legend to this
  layer

- legendPosition:

  Position of the legend images on the map. Must be one of
  `'bottomleft', 'bottomright', 'topleft', 'topright'`

## Value

A list of options for `addOpenweatherTiles`

## See also

Other Openweathermap Functions:
[`addOpenweatherCurrent()`](https://trafficonese.github.io/leaflet.extras2/reference/addOpenweatherCurrent.md),
[`addOpenweatherTiles()`](https://trafficonese.github.io/leaflet.extras2/reference/addOpenweatherTiles.md),
[`openweatherCurrentOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/openweatherCurrentOptions.md)
