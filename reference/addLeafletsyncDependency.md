# Add the Leaflet Sync JS dependencies

Sometimes it makes sense to include the Leaflet Sync dependencies
already before synchronizing maps. For example, if you want to use the
\`L.Sync.offsetHelper\`. See the example in
`./inst/examples/offsetHelper.R`

## Usage

``` r
addLeafletsyncDependency(map)
```

## Arguments

- map:

  the map

## Value

A modified leaflet map

## See also

Other leafletsync Functions:
[`addLeafletsync()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsync.md),
[`isSynced()`](https://trafficonese.github.io/leaflet.extras2/reference/isSynced.md),
[`leafletsyncOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/leafletsyncOptions.md),
[`unsync()`](https://trafficonese.github.io/leaflet.extras2/reference/unsync.md)
