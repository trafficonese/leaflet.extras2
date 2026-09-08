# reachabilityOptions

Add extra options. For a full list please visit the [plugin
repository](https://github.com/traffordDataLab/leaflet.reachability).

## Usage

``` r
reachabilityOptions(
  collapsed = TRUE,
  pane = "overlayPane",
  position = "topleft",
  ...
)
```

## Arguments

- collapsed:

  Should the control widget start in a collapsed mode. Default is `TRUE`

- pane:

  Leaflet pane to add the isolines GeoJSON to. Default is `overlayPane`

- position:

  Leaflet control pane position. Default is `topleft`

- ...:

  Further arguments passed to \`L.Control.Reachability\`

## Value

A list of options for `addReachability`

## References

<https://github.com/traffordDataLab/leaflet.reachability>

## See also

Other Reachability Functions:
[`addReachability()`](https://trafficonese.github.io/leaflet.extras2/reference/addReachability.md),
[`removeReachability()`](https://trafficonese.github.io/leaflet.extras2/reference/removeReachability.md)
