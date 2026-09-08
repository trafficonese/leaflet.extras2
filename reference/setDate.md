# Set Date for GIBS Layers

Set a new date for multi-temporal layers.

## Usage

``` r
setDate(map, layers = NULL, dates = NULL)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- layers:

  A character vector of GIBS-layers. See
  [`gibs_layers`](https://trafficonese.github.io/leaflet.extras2/reference/gibs_layers.md)

- dates:

  Date object. If multiple `layers` are added, you can add a Date vector
  of the same length

## Value

the new `map` object

## See also

Other GIBS Functions:
[`addGIBS()`](https://trafficonese.github.io/leaflet.extras2/reference/addGIBS.md),
[`setTransparent()`](https://trafficonese.github.io/leaflet.extras2/reference/setTransparent.md)
