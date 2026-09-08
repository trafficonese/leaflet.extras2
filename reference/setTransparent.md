# Set Transparency for GIBS Layers

Change the transparency for no-data pixels.

## Usage

``` r
setTransparent(map, layers = NULL, transparent = TRUE)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- layers:

  A character vector of GIBS-layers. See
  [`gibs_layers`](https://trafficonese.github.io/leaflet.extras2/reference/gibs_layers.md)

- transparent:

  Should the layer be transparent. If multiple `layers` are added, you
  can add a boolean vector of the same length

## Value

the new `map` object

## See also

Other GIBS Functions:
[`addGIBS()`](https://trafficonese.github.io/leaflet.extras2/reference/addGIBS.md),
[`setDate()`](https://trafficonese.github.io/leaflet.extras2/reference/setDate.md)
