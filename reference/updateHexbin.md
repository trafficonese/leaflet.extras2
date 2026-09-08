# updateHexbin

Dynamically change the `data` and/or the `colorRange`.

## Usage

``` r
updateHexbin(map, data = NULL, lng = NULL, lat = NULL, colorRange = NULL)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

- lng:

  a numeric vector of longitudes, or a one-sided formula of the form
  `~x` where `x` is a variable in `data`; by default (if not explicitly
  provided), it will be automatically inferred from `data` by looking
  for a column named `lng`, `long`, or `longitude` (case-insensitively)

- lat:

  a vector of latitudes or a formula (similar to the `lng` argument; the
  names `lat` and `latitude` are used when guessing the latitude column
  from `data`)

- colorRange:

  The range of the color scale used to fill the hexbins

## Value

the new `map` object

## See also

Other Hexbin-D3 Functions:
[`addHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/addHexbin.md),
[`clearHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/clearHexbin.md),
[`hexbinOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/hexbinOptions.md),
[`hideHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/hideHexbin.md),
[`showHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/showHexbin.md)
