# showContextmenu

Open the contextmenu at certain lat/lng-coordinates

## Usage

``` r
showContextmenu(map, lat = NULL, lng = NULL, data = leaflet::getMapData(map))
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- lat:

  a vector of latitudes or a formula (similar to the `lng` argument; the
  names `lat` and `latitude` are used when guessing the latitude column
  from `data`)

- lng:

  a numeric vector of longitudes, or a one-sided formula of the form
  `~x` where `x` is a variable in `data`; by default (if not explicitly
  provided), it will be automatically inferred from `data` by looking
  for a column named `lng`, `long`, or `longitude` (case-insensitively)

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Value

A leaflet map object

## See also

Other Contextmenu Functions:
[`addContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/addContextmenu.md),
[`addItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/addItemContextmenu.md),
[`context_mapmenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/context_mapmenuItems.md),
[`context_markermenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/context_markermenuItems.md),
[`context_menuItem()`](https://trafficonese.github.io/leaflet.extras2/reference/context_menuItem.md),
[`disableContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/disableContextmenu.md),
[`enableContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/enableContextmenu.md),
[`hideContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/hideContextmenu.md),
[`insertItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/insertItemContextmenu.md),
[`mapmenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/mapmenuItems.md),
[`markermenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/markermenuItems.md),
[`menuItem()`](https://trafficonese.github.io/leaflet.extras2/reference/menuItem.md),
[`removeItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/removeItemContextmenu.md),
[`removeallItemsContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/removeallItemsContextmenu.md),
[`setDisabledContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/setDisabledContextmenu.md)
