# Is a map synchronized?

Is a map snychronized with any or a specific map? Invoking this method
sets a Shiny input that returns `TRUE` when the map is synchronized with
another map. If `syncwith` is set, `TRUE` is returned if the map is
synchronized exactly with that other map.

## Usage

``` r
isSynced(map, id = NULL, syncwith = NULL)
```

## Arguments

- map:

  the map

- id:

  The map id

- syncwith:

  Is the map synchronized with one of these maps?

## Value

A map

## Details

The Siny input name is combined of the map-id and `"_synced"`. For a map
with id `map1` the input can be retrieved with `input$map1_synced`.

## See also

Other leafletsync Functions:
[`addLeafletsync()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsync.md),
[`addLeafletsyncDependency()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsyncDependency.md),
[`leafletsyncOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/leafletsyncOptions.md),
[`unsync()`](https://trafficonese.github.io/leaflet.extras2/reference/unsync.md)
