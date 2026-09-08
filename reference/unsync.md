# Removes synchronization.

Removes the synchronization of multiple maps from a specific map.

## Usage

``` r
unsync(map, id = NULL, unsyncids = NULL)
```

## Arguments

- map:

  the map

- id:

  The map id from which to unsynchronize the maps in `unsyncids`

- unsyncids:

  Unsynchronize the maps with the following IDs

## Value

A map

## See also

Other leafletsync Functions:
[`addLeafletsync()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsync.md),
[`addLeafletsyncDependency()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsyncDependency.md),
[`isSynced()`](https://trafficonese.github.io/leaflet.extras2/reference/isSynced.md),
[`leafletsyncOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/leafletsyncOptions.md)
