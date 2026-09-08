# leafletsync Options

Additional list of options.

## Usage

``` r
leafletsyncOptions(
  noInitialSync = FALSE,
  syncCursor = TRUE,
  offsetFn = JS("function (center, zoom, refMap, tgtMap) { return center; }")
)
```

## Arguments

- noInitialSync:

  Setting to `TRUE` disables initial synchronization of the maps. The
  default is `FALSE`.

- syncCursor:

  The default `TRUE` adds a circle marker on the synced map.

- offsetFn:

  A JavaScript-function to compute an offset for the center.

## Value

A list of options for `addLeafletsync`

## See also

Other leafletsync Functions:
[`addLeafletsync()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsync.md),
[`addLeafletsyncDependency()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsyncDependency.md),
[`isSynced()`](https://trafficonese.github.io/leaflet.extras2/reference/isSynced.md),
[`unsync()`](https://trafficonese.github.io/leaflet.extras2/reference/unsync.md)
