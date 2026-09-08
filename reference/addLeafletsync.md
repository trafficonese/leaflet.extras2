# Synchronize multiple Leaflet map

The plugin allows you to synchronize and unsynchronize multiple leaflet
maps in a Shiny application. You can pass additional options to
[`leafletsyncOptions`](https://trafficonese.github.io/leaflet.extras2/reference/leafletsyncOptions.md).
For more information see
[Leaflet.Sync](https://github.com/jieter/Leaflet.Sync)

## Usage

``` r
addLeafletsync(
  map,
  ids = NULL,
  synclist = "all",
  options = leafletsyncOptions()
)
```

## Arguments

- map:

  the map

- ids:

  the map ids to be synced. If you use a `synclist`, you may leave it
  `NULL.` The unique names and values of `synclist` will be used.

- synclist:

  The synchronization list. The default is `'all'`, which creates a list
  of all possible combinations of `ids`. For a more detailed control, a
  named list can be passed in this form
  `list(m1 = c("m2", "m3"), m2 = c("m1", "m3"), m3 = c("m1", "m2"))`,
  where the names and values represent map-ids. The names of the lists
  serve as a basis and the list values are the maps to be kept in sync
  with the basemap.

- options:

  A named list of options. See
  [`leafletsyncOptions`](https://trafficonese.github.io/leaflet.extras2/reference/leafletsyncOptions.md).
  If you want to add different options to multiple maps, you can wrap
  the options in a named list, with the names being the map-ids. See the
  example in `./inst/examples/offset_continuous.R`

## Value

A modified leaflet map

## Note

If you synchronize multiple maps, a map may not yet be initialized and
therefore cannot be used. Make sure to use `addLeafletsync` after all
maps have been rendered.

## References

<https://github.com/jieter/Leaflet.Sync>

## See also

Other leafletsync Functions:
[`addLeafletsyncDependency()`](https://trafficonese.github.io/leaflet.extras2/reference/addLeafletsyncDependency.md),
[`isSynced()`](https://trafficonese.github.io/leaflet.extras2/reference/isSynced.md),
[`leafletsyncOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/leafletsyncOptions.md),
[`unsync()`](https://trafficonese.github.io/leaflet.extras2/reference/unsync.md)
