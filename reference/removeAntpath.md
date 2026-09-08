# removeAntpath

Remove one or more Antpaths from a map, identified by `layerId`.

## Usage

``` r
removeAntpath(map, layerId = NULL)
```

## Arguments

- map:

  a map widget object, possibly created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html)()
  but more likely from
  [`leafletProxy`](https://rstudio.github.io/leaflet/reference/leafletProxy.html)()

- layerId:

  character vector; the layer id(s) of the item to remove

## Value

the new `map` object

## See also

Other Antpath Functions:
[`addAntpath()`](https://trafficonese.github.io/leaflet.extras2/reference/addAntpath.md),
[`antpathOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/antpathOptions.md),
[`clearAntpath()`](https://trafficonese.github.io/leaflet.extras2/reference/clearAntpath.md)
