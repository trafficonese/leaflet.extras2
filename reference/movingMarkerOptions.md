# Set options for Moving Markers

Set options for Moving Markers

## Usage

``` r
movingMarkerOptions(autostart = FALSE, loop = FALSE, pauseOnZoom = FALSE)
```

## Arguments

- autostart:

  If `TRUE` the marker will start automatically after it is added to
  map. Default is `FALSE`

- loop:

  if `TRUE` the marker will start automatically at the beginning of the
  polyline when the it arrives at the end. Default is `FALSE`

- pauseOnZoom:

  Pause the marker while zooming. While this improves the animation, it
  is not recommended because the animation time is lost and the marker
  will not appear at the correct time at the next station. Default is
  `FALSE`

## Value

A list of extra options for moving markers

## References

<https://github.com/ewoken/Leaflet.MovingMarker>

## See also

Other MovingMarker Functions:
[`addMovingMarker()`](https://trafficonese.github.io/leaflet.extras2/reference/addMovingMarker.md),
[`startMoving()`](https://trafficonese.github.io/leaflet.extras2/reference/startMoving.md)
