# goBackHistory

If possible, will go to previous map extent. Pushes current extent to
the "future" stack.

## Usage

``` r
goBackHistory(map)
```

## Arguments

- map:

  a map widget object created from
  [`leafletProxy`](https://rstudio.github.io/leaflet/reference/leafletProxy.html)

## Value

the new `map` object

## References

<https://github.com/cscott530/leaflet-history>

## See also

Other History Functions:
[`addHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/addHistory.md),
[`clearFuture()`](https://trafficonese.github.io/leaflet.extras2/reference/clearFuture.md),
[`clearHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/clearHistory.md),
[`goForwardHistory()`](https://trafficonese.github.io/leaflet.extras2/reference/goForwardHistory.md),
[`historyOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/historyOptions.md)
