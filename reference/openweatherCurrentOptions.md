# openweatherCurrentOptions

openweatherCurrentOptions

## Usage

``` r
openweatherCurrentOptions(
  lang = "en",
  minZoom = 7,
  interval = 10,
  imageLoadingUrl = paste0(openweatherDependency()[[1]]$name, "-",
    openweatherDependency()[[1]]$version, "/owmloading.gif"),
  ...
)
```

## Arguments

- lang:

  'en', 'de', 'ru', 'fr', 'es', 'ca'. Language of popup texts. Note: not
  every translation is finished yet.

- minZoom:

  Number (7). Minimal zoom level for fetching city data. Use smaller
  values only at your own risk.

- interval:

  Number (10). Time in minutes to reload city data. Please do not use
  less than 10 minutes.

- imageLoadingUrl:

  URL of the loading image.

- ...:

  Further options passed to `L.OWM.current`. See the [full list of
  options](https://github.com/trafficonese/leaflet-openweathermap#options)

## Value

A list of options for `addOpenweatherCurrent`

## See also

Other Openweathermap Functions:
[`addOpenweatherCurrent()`](https://trafficonese.github.io/leaflet.extras2/reference/addOpenweatherCurrent.md),
[`addOpenweatherTiles()`](https://trafficonese.github.io/leaflet.extras2/reference/addOpenweatherTiles.md),
[`openweatherOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/openweatherOptions.md)
