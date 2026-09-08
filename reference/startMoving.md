# Interact with the moving markers

The marker begins its path or resumes if it is paused.

## Usage

``` r
startMoving(map, layerId = NULL)

stopMoving(map, layerId = NULL)

pauseMoving(map, layerId = NULL)

resumeMoving(map, layerId = NULL)

addLatLngMoving(map, layerId = NULL, latlng, duration)

moveToMoving(map, layerId = NULL, latlng, duration)

addStationMoving(map, layerId = NULL, pointIndex, duration)
```

## Arguments

- map:

  The leafletProxy object

- layerId:

  You can pass a string or a vector of strings for the moving markers
  that you want to address. If none is specified, the action will be
  applied to all moving markers.

- latlng:

  Coordinates as list (e.g.: `list(33, -67)` or `list(lng=-65, lat=33)`)

- duration:

  Duration in milliseconds

- pointIndex:

  Index of a certain point

## Value

the new `map` object

## Functions

- `stopMoving()`: Manually stops the marker, if you call `start` after,
  the marker starts again the polyline at the beginning.

- `pauseMoving()`: Pauses the marker

- `resumeMoving()`: The marker resumes its animation

- `addLatLngMoving()`: Adds a point to the polyline. Useful, if we have
  to set the path one by one.

- `moveToMoving()`: Stop the current animation and make the marker move
  to `latlng` in `duration` ms.

- `addStationMoving()`: The marker will stop at the `pointIndex` point
  of the polyline for `duration` milliseconds. You can't add a station
  at the first or last point of the polyline.

## References

<https://github.com/ewoken/Leaflet.MovingMarker>

## See also

Other MovingMarker Functions:
[`addMovingMarker()`](https://trafficonese.github.io/leaflet.extras2/reference/addMovingMarker.md),
[`movingMarkerOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/movingMarkerOptions.md)
